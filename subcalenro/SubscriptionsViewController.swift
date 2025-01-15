//
//  SubscriptionsViewController.swift
//  subcalenro
//
//  Created by ronaldo avalos on 11/10/24.
//

import Foundation
import UIKit
import Kingfisher

class SubscriptionsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {

  var subscriptions: [Company] = []

  var filteredSubscriptions: [String] = []
  var filteredLogos: [String] = []

  var collectionView: UICollectionView!
  var tableView: UITableView!
  let segmentedControl = UISegmentedControl(items: ["popular", "All"])
  let searchController = UISearchController()

  private var activityIndicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .large)
    indicator.color = .gray
    indicator.hidesWhenStopped = true
    indicator.translatesAutoresizingMaskIntoConstraints = false
    return indicator
  }()

  private var errorLabel: UILabel = {
    let label = UILabel()
    label.text = "No internet connection. Please try again."
    label.textColor = .red
    label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    label.textAlignment = .center
    label.numberOfLines = 0
    label.isHidden = true
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private var retryButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Retry", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    button.setTitleColor(.systemBlue, for: .normal)
    button.isHidden = true
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    self.title = "New Subscription"
    let closeIcon = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeModal))
    closeIcon.tintColor = .systemGray2
    self.navigationItem.rightBarButtonItem = closeIcon

    let customButton = UIBarButtonItem(title: "Custom", style: .plain, target: self, action: #selector(customButtonTapped))
    self.navigationItem.leftBarButtonItem = customButton

    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search by company"
    searchController.hidesNavigationBarDuringPresentation = false


    self.navigationItem.searchController = searchController
    self.navigationItem.hidesSearchBarWhenScrolling = false
    self.definesPresentationContext = true


    view.backgroundColor = ThemeManager.color(for: .primaryBackground)

    setupErrorViews()
    view.addSubview(activityIndicator)
    NSLayoutConstraint.activate([
      activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
    activityIndicator.startAnimating()
     fetchData()
    setupCollectionView()
    setupTableView()
  }

  private func setupErrorViews() {
    view.addSubview(errorLabel)
    view.addSubview(retryButton)
    retryButton.addTarget(self, action: #selector(retryFetchData), for: .touchUpInside)

    NSLayoutConstraint.activate([
      errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
      errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

      retryButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 10),
      retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
  }

  @objc private func retryFetchData() {
    errorLabel.isHidden = true
    retryButton.isHidden = true
    activityIndicator.startAnimating()
    fetchData()
  }

  func fetchData() {
    FirebaseStoreManager().fetchSubscriptions { [weak self] fetchedSubscriptions in
      guard let self = self else { return }

      if fetchedSubscriptions.isEmpty {
        DispatchQueue.main.async {
          self.activityIndicator.stopAnimating()
          self.errorLabel.isHidden = false
          self.retryButton.isHidden = false
          self.collectionView.isHidden = true
        }
      } else {
        self.subscriptions = fetchedSubscriptions
        self.filteredSubscriptions = fetchedSubscriptions.map { $0.name }
        self.filteredLogos = fetchedSubscriptions.map { $0.imageUrl }

        DispatchQueue.main.async {
          self.activityIndicator.stopAnimating()
          self.collectionView.isHidden = false
          self.collectionView.reloadData()
        }
      }
    }
  }


  // Método para configurar la UICollectionView
  private func setupCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 112, height: 112)  // Tamaño de las celdas
    layout.minimumInteritemSpacing = 10  // Espacio entre columnas (horizontal)
    layout.minimumLineSpacing = 20  // Espacio entre filas (vertical)
    layout.sectionInset = UIEdgeInsets(top: 20, left: 14, bottom: 80, right: 14)

    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(SubscriptionViewCell.self, forCellWithReuseIdentifier: "cell")
    collectionView.backgroundColor = ThemeManager.color(for: .primaryBackground)
    collectionView.isHidden = true
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(collectionView)
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }


  private func setupTableView() {
    tableView = UITableView(frame:.zero,  style: .plain)
    tableView.dataSource = self
    tableView.delegate = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tableCell")
    tableView.isHidden = true // Por defecto oculto, hasta que se seleccione "Alls"
    self.view.addSubview(tableView)

    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }

  @objc func customButtonTapped() {
    let vc = FormNewSubController(company: nil,sub: nil)
    self.navigationController?.pushViewController(vc, animated: true)
  }

  @objc func closeModal() {
    self.dismiss(animated: true)
  }

  // MARK: - UICollectionViewDataSource
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return filteredSubscriptions.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SubscriptionViewCell
    cell.label.text = filteredSubscriptions[indexPath.row]
    cell.imageView.kf.setImage(with: URL(string: filteredLogos[indexPath.row]))
    return cell
  }

  // MARK: - UITableViewDataSource
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredSubscriptions.count
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedName = filteredSubscriptions[indexPath.row]
    let selectedCompany = subscriptions.first { $0.name == selectedName }

    if let company = selectedCompany {
      let vc = FormNewSubController(company: company, sub: nil)
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }


  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
    cell.textLabel?.text = filteredSubscriptions[indexPath.row]
    cell.imageView?.kf.setImage(with: URL(string: filteredLogos[indexPath.row]))
    return cell
  }


  // MARK: - UISegmentedControl
  @objc func segmentChanged(_ sender: UISegmentedControl) {
    collectionView.isHidden = true
    tableView.isHidden = false

    updateSearchResults(for: searchController)
  }

  // MARK: - UISearchResultsUpdating

  func updateSearchResults(for searchController: UISearchController) {
    guard let searchText = searchController.searchBar.text?.lowercased(), !searchText.isEmpty else {
      filteredSubscriptions = subscriptions.map { $0.name }
      filteredLogos = subscriptions.map { $0.imageUrl }
      collectionView.reloadData()
      tableView.reloadData()
      return
    }

    filteredSubscriptions = subscriptions.filter { $0.name.lowercased().contains(searchText) }.map { $0.name }
    filteredLogos = subscriptions.filter { $0.name.lowercased().contains(searchText) }.map { $0.imageUrl }

    collectionView.reloadData()
    tableView.reloadData()
  }

}

class SubscriptionViewCell: UICollectionViewCell {

  // Crear contenedor
  let containerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = 12
    view.backgroundColor = .white
    view.layer.masksToBounds = true
    return view
  }()

  // Crear imagen
  let imageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFit
    iv.translatesAutoresizingMaskIntoConstraints = false
    return iv
  }()

  // Crear label
  let label: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 12)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    // Configurar sombra
    contentView.layer.shadowColor = ThemeManager.color(for: .secondaryBackground).cgColor
    contentView.layer.shadowOpacity = 0.15
    contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
    contentView.layer.shadowRadius = 2
    contentView.layer.masksToBounds = false

    // Agregar el contenedor
    contentView.addSubview(containerView)

    // Agregar imagen y label al contenedor
    containerView.addSubview(imageView)
    containerView.addSubview(label)

    // Constraints para el contenedor
    NSLayoutConstraint.activate([
      containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      containerView.widthAnchor.constraint(equalToConstant: 115),
      containerView.heightAnchor.constraint(equalToConstant: 115),
    ])

    // Constraints para la imagen
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
      imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
      imageView.widthAnchor.constraint(equalToConstant: 60),
      imageView.heightAnchor.constraint(equalToConstant: 60),
    ])

    // Constraints para el label
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
      label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
      label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
      label.heightAnchor.constraint(equalToConstant: 20)
    ])
  }

  override var isHighlighted: Bool {
    didSet {
      let transform = isHighlighted ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
      UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
        self.containerView.transform = transform
      }, completion: nil)
    }
  }




  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


extension SubscriptionsViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    Utility.feedbackGenerator(style: .soft)

    // Usar filteredSubscriptions para determinar la selección
    let selectedName = filteredSubscriptions[indexPath.row]
    let selectedCompany = subscriptions.first { $0.name == selectedName }
    if let company = selectedCompany {
      let vc = FormNewSubController(company: company,sub: nil)
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }

}

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "New Subscription"
        let closeIcon = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeModal))
        closeIcon.tintColor = .systemGray2
        self.navigationItem.rightBarButtonItem = closeIcon
    
        FirebaseStoreManager().fetchSubscriptions { [weak self] fetchedSubscriptions in
               guard let self = self else { return }
               self.subscriptions = fetchedSubscriptions
               self.filteredSubscriptions = fetchedSubscriptions.map { $0.name }
               self.filteredLogos = fetchedSubscriptions.map { $0.imageUrl }
               
               DispatchQueue.main.async {
                   self.collectionView.reloadData()
                   self.tableView.reloadData()
               }
           }


        // Configuración del Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by company"
        searchController.hidesNavigationBarDuringPresentation = false
        
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true
        
        
        view.backgroundColor = ThemeManager.color(for: .primaryBackground)
        
        // Configuración del SegmentedControl
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        self.navigationItem.titleView = segmentedControl
        
        setupCollectionView()
        setupTableView()
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
        collectionView.isHidden = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // Método para configurar la UITableView
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

    
    @objc func closeModal() {
        self.dismiss(animated: true)
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredSubscriptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SubscriptionViewCell
        let subscription = subscriptions[indexPath.row]
        cell.label.text = subscription.name
        // Carga la imagen desde la URL usando una librería como Kingfisher o SDWebImage
        cell.imageView.kf.setImage(with: URL(string: subscription.imageUrl))
        return cell
    }
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSubscriptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        let subscription = subscriptions[indexPath.row]
        cell.textLabel?.text = subscription.name
        // Carga la imagen desde la URL usando una librería como Kingfisher o SDWebImage
        cell.imageView?.kf.setImage(with: URL(string: subscription.imageUrl))
        return cell
    }
    
    // MARK: - UISegmentedControl
    @objc func segmentChanged(_ sender: UISegmentedControl) {
           if sender.selectedSegmentIndex == 0 {
               // Mostrar colección de "Populars"
               collectionView.isHidden = false
               tableView.isHidden = true
               
           } else {
               
               // Mostrar lista de "Alls"
               collectionView.isHidden = true
               tableView.isHidden = false
           }
    
        updateSearchResults(for: searchController)
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
           guard let searchText = searchController.searchBar.text?.lowercased(), !searchText.isEmpty else {
               // Si la búsqueda está vacía, mostrar todas las suscripciones
               collectionView.reloadData()
               tableView.reloadData()
               return
           }
           
//           // Filtrar las suscripciones y logos basados en el texto ingresado
//           filteredSubscriptions = su.filter { $0.lowercased().contains(searchText) }
//           filteredLogos = zip(companysNames, logos).filter { $0.0.lowercased().contains(searchText) }.map { $0.1 }
//           
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
        if indexPath.row == 0 {
            let vc = FormNewSubController(company: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let comapany = subscriptions[indexPath.row]
            let vc = FormNewSubController(company: comapany)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

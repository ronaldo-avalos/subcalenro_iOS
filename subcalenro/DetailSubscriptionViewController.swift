//
//  SubPreviewViewController.swift
//  subcalenro
//
//  Created by ronaldo avalos on 12/10/24.
//

import UIKit

class DetailSubscriptionViewController: UIViewController {

    var subId: UUID?
    var imgURL: String?
    var companyName: String?
    var subEdit: Subscription?

    // Referencias a las vistas que se actualizan dinámicamente
    private var nameLabel: UILabel!
    private var priceLabel: UILabel!
    private var nextBillLabel: UILabel!
    private var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeManager.color(for: .primaryBackground)
        self.navigationItem.title = "Preview"
      let closeIcon = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeModal))
      closeIcon.tintColor = .systemGray2
      self.navigationItem.rightBarButtonItem = closeIcon
        setupView()

        // Configurar el observador para actualizaciones
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleUpdateSub),
            name: Notification.Name("updateSub"),
            object: nil
        )
    }

    private func setupView() {
        // Etiqueta para el próximo pago
        nextBillLabel = UILabel()
        nextBillLabel.font = UIFont.systemFont(ofSize: 16)
        nextBillLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextBillLabel)

        // Imagen y contenedor
        let imageContainer = UIView()
        imageContainer.backgroundColor = .white
        imageContainer.layer.cornerRadius = 20
        imageContainer.layer.cornerCurve = .continuous
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageContainer)

        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.addSubview(imageView)

        // Botón de edición
        let editImageButton = UIButton(type: .system)
        editImageButton.setImage(
            UIImage(systemName: "pencil")?.withTintColor(.label, renderingMode: .alwaysOriginal),
            for: .normal
        )
        editImageButton.layer.cornerRadius = 26
        editImageButton.clipsToBounds = true
        editImageButton.backgroundColor = ThemeManager.color(for: .tableViewCellColor)
        editImageButton.translatesAutoresizingMaskIntoConstraints = false
        editImageButton.addTarget(self, action: #selector(toggleEditMode), for: .touchUpInside)
        view.addSubview(editImageButton)

        // Etiqueta para el nombre
        nameLabel = UILabel()
        nameLabel.font = UIFont.boldSystemFont(ofSize: 32)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)

        // Etiqueta para el precio
        priceLabel = UILabel()
        priceLabel.font = UIFont.systemFont(ofSize: 24)
        priceLabel.textColor = .systemBlue
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(priceLabel)

        // Configuración inicial de datos
        loadSubscriptionData()

        // Configuración de restricciones
        NSLayoutConstraint.activate([
            nextBillLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 56),
            nextBillLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            imageContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageContainer.topAnchor.constraint(equalTo: nextBillLabel.bottomAnchor, constant: 26),
            imageContainer.widthAnchor.constraint(equalToConstant: 120),
            imageContainer.heightAnchor.constraint(equalToConstant: 120),

            imageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: imageContainer.widthAnchor, multiplier: 0.8),
            imageView.heightAnchor.constraint(equalTo: imageContainer.heightAnchor, multiplier: 0.8),

            nameLabel.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 14),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            priceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            editImageButton.widthAnchor.constraint(equalToConstant: 52),
            editImageButton.heightAnchor.constraint(equalToConstant: 52),
            editImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editImageButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -40),
        ])
    }

    private func loadSubscriptionData() {
        guard let id = subId,
              let sub = SubscriptionManager().readById(id) else { return }

        subEdit = sub

        // Actualizar datos de las vistas
        nameLabel.text = sub.name
        priceLabel.text = "$\(String(format: "%.2f", sub.amount))"
        nextBillLabel.text = "Next bill: \(sub.nextDateFomatter)"

        if sub.logoUrl.isEmpty {
            imageView.image = UIImage(named: sub.iconName)
        } else {
            imageView.kf.setImage(with: URL(string: sub.logoUrl))
        }
    }

    @objc func handleUpdateSub() {
        // Recargar los datos y actualizar las vistas
        loadSubscriptionData()
    }

    @objc func toggleEditMode() {
        let vc = FormNewSubController(company: nil, sub: subEdit)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

  @objc func closeModal() {
    self.dismiss(animated: true)
  }
}


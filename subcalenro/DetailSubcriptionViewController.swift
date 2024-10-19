//
//  SubPreviewViewController.swift
//  subcalenro
//
//  Created by ronaldo avalos on 12/10/24.
//

import UIKit

class DetailSubcriptionViewController: UIViewController {
    
    var subId: UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeManager.color(for: .primaryBackground)
        setupView()
    }
    
    private func setupView() {
//        self.navigationItem.title = "Subcription"
        self.navigationController?.navigationBar.tintColor = .label
        let nextBillLabel = UILabel()
        nextBillLabel.font = UIFont.systemFont(ofSize: 16)
        nextBillLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextBillLabel)
  
        
        
        let dateLabel = UILabel()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        dateLabel.font = UIFont.systemFont(ofSize: 16)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateLabel)
        
        let imageContainer = UIView()
        imageContainer.backgroundColor = .white
        imageContainer.layer.cornerRadius = 20  // Radio del borde del contenedor
        imageContainer.layer.cornerCurve = .continuous
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageContainer)

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true  // Para que los bordes redondeados se apliquen correctamente
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.addSubview(imageView)
        
        let editImageButton = UIButton(type: .system)
        editImageButton.setImage(UIImage(systemName: "pencil")?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)
        editImageButton.layer.cornerRadius = 26
        editImageButton.clipsToBounds = true
        editImageButton.backgroundColor = ThemeManager.color(for: .tableViewCellColor)
        editImageButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(editImageButton)

        
        let nameLabel = UILabel()
        nameLabel.font = UIFont.boldSystemFont(ofSize: 32)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        let priceLabel = UILabel()
        priceLabel.font = UIFont.systemFont(ofSize: 16)
        priceLabel.textColor = .systemBlue
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(priceLabel)
        
        if let id = subId {
            guard let sub = SubscriptionManager().readById(id) else { return }
            imageView.image = UIImage(named: sub.logoUrl)
            nameLabel.text = sub.name
            priceLabel.text = "$\(String(sub.price))"
            nextBillLabel.text = "Next bill: \(sub.nextDateFomatter)"
            let periodView = createDetailView(title: "Period", value: sub.period.name)
            let reminderView = createDetailView(title: "Remind me", value: sub.reminderTime.name)
            let planDetailsView = createDetailView(title: "Plan details", value:  "N/A")
            
            view.addSubview(periodView)
            view.addSubview(reminderView)
            view.addSubview(planDetailsView)
            
            editImageButton.addAction(UIAction(handler: { [weak self] _ in
                self?.toggleEditMode(button: editImageButton)
            }), for: .touchUpInside)

            // Configurar restricciones
            NSLayoutConstraint.activate([
                nextBillLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 56),
                nextBillLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                dateLabel.topAnchor.constraint(equalTo: nextBillLabel.bottomAnchor, constant: 5),
                dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                imageContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                imageContainer.topAnchor.constraint(equalTo: nextBillLabel.bottomAnchor, constant: 26),
                imageContainer.widthAnchor.constraint(equalToConstant: 120),  // Ancho del contenedor
                imageContainer.heightAnchor.constraint(equalToConstant: 120),  // Altura del contenedor
                
                imageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor),
                imageView.widthAnchor.constraint(equalTo: imageContainer.widthAnchor, multiplier: 0.8),
                imageView.heightAnchor.constraint(equalTo: imageContainer.heightAnchor, multiplier: 0.8),
                
                nameLabel.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 14),
                nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
                priceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                periodView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 20),
                periodView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                periodView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                periodView.heightAnchor.constraint(equalToConstant: 54),
                
                reminderView.topAnchor.constraint(equalTo: periodView.bottomAnchor, constant: 4),
                reminderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                reminderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                reminderView.heightAnchor.constraint(equalToConstant: 54),
                
                planDetailsView.topAnchor.constraint(equalTo: reminderView.bottomAnchor, constant: 4),
                planDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                planDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                planDetailsView.heightAnchor.constraint(equalToConstant: 54),
                
                editImageButton.widthAnchor.constraint(equalToConstant: 52),
                editImageButton.heightAnchor.constraint(equalToConstant: 52),
                editImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                editImageButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor,constant: -40),
            ])
            
        }
    }
    
    private func toggleEditMode(button: UIButton) {
        // Verificamos si ya está en modo "Save"
        if button.currentImage == UIImage(systemName: "checkmark") {
            // Regresar al modo de edición
            UIView.transition(with: button, duration: 0.3, options: .transitionCrossDissolve, animations: {
                button.setImage(UIImage(systemName: "pencil")?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)
                button.setTitle(nil, for: .normal)
            }, completion: nil)
        } else {
            // Cambiar al modo "Save"
            UIView.transition(with: button, duration: 0.3, options: .transitionCrossDissolve, animations: {
                button.setImage(UIImage(systemName: "checkmark")?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)
            }, completion: nil)
        }
    }
    
    private func createDetailView(title: String, value: String) -> UIView {
        let container = UIView()
        container.backgroundColor = ThemeManager.color(for: .tableViewCellColor)
        container.layer.cornerRadius = 10
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 16)
        valueLabel.textAlignment = .right
        valueLabel.textColor = .tertiaryLabel
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(titleLabel)
        container.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            
            valueLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12)
        ])
        
        return container
    }
}

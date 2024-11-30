//
//  EditSubViewController.swift
//  subcalenro
//
//  Created by Ronaldo Avalos on 28/11/24.
//

import Foundation
import UIKit

class EditSubViewController: UIViewController, UITextFieldDelegate {
    
    
    var imgURL: String?
    var companyName: String?
    
    
    private var priceTextField : UITextField = {
        let textField = UITextField()
        textField.keyboardType = .decimalPad
        textField.placeholder = "00.00"
        textField.font = UIFont.systemFont(ofSize: 24)
        textField.backgroundColor = .clear
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeManager.color(for: .primaryBackground)
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        view.addGestureRecognizer(tap)
        priceTextField.delegate = self
        setupView()
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }
    
    private func setupView() {
        self.navigationController?.navigationBar.tintColor = .label
        
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
        
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Save", for: .normal)
        saveButton.layer.cornerRadius = 12
        saveButton.tintColor = ThemeManager.color(for: .secondaryText)
        saveButton.clipsToBounds = true
        saveButton.backgroundColor = ThemeManager.color(for: .secondaryBackground)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveButton)

        
        let nameLabel = UILabel()
        nameLabel.font = UIFont.boldSystemFont(ofSize: 32)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        let priceLabel = UILabel()
        priceLabel.font = UIFont.systemFont(ofSize: 24)
        priceLabel.textColor = .label
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(priceLabel)
     
        
        if let image = imgURL {
            imageView.image = UIImage(named: image)
            nameLabel.text = companyName
            priceLabel.text = "$"
            let periodView = createDetailView(title: "Period", value: "Mensual", options: ["Mensual", "Anual", "Semanal"]) { selectedValue in
                print("Periodo seleccionado: \(selectedValue)")
            }

            let reminderView = createDetailView(title: "Remind me", value: "1 día antes", options: ["1 día antes", "2 días antes", "1 semana antes"]) { selectedValue in
                print("Recordatorio seleccionado: \(selectedValue)")
            }

            let planDetailsView = createDetailView(title: "Plan details", value: "N/A", options: ["Plan A", "Plan B", "Plan C"]) { selectedValue in
                print("Detalles del plan seleccionado: \(selectedValue)")
            }

            // `nextBillView` no tiene opciones, por lo que no tendrá interacción
            let nextBillView = createDetailView(title: "Next bill", value: "19 Dic 2024")

            view.addSubview(periodView)
            view.addSubview(reminderView)
            view.addSubview(planDetailsView)
            view.addSubview(nextBillView)
            view.addSubview(priceTextField)

            
            saveButton.addAction(UIAction(handler: { [weak self] _ in
                    //
            }), for: .touchUpInside)

            // Configurar restricciones
            NSLayoutConstraint.activate([

                imageContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                imageContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 56),
                imageContainer.widthAnchor.constraint(equalToConstant: 120),  // Ancho del contenedor
                imageContainer.heightAnchor.constraint(equalToConstant: 120),  // Altura del contenedor
                
                imageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor),
                imageView.widthAnchor.constraint(equalTo: imageContainer.widthAnchor, multiplier: 0.8),
                imageView.heightAnchor.constraint(equalTo: imageContainer.heightAnchor, multiplier: 0.8),
                
                nameLabel.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 14),
                nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
                priceLabel.trailingAnchor.constraint(equalTo: priceTextField.leadingAnchor, constant: -6),
                priceLabel.centerYAnchor.constraint(equalTo: priceTextField.centerYAnchor),
                priceLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 12),
                
                priceTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
                priceTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                priceTextField.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
                priceTextField.heightAnchor.constraint(equalToConstant: 24),
        
            
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
                
                nextBillView.topAnchor.constraint(equalTo: planDetailsView.bottomAnchor, constant: 4),
                nextBillView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                nextBillView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                nextBillView.heightAnchor.constraint(equalToConstant: 54),
                
                saveButton.topAnchor.constraint(equalTo: nextBillView.bottomAnchor, constant: 48),
                saveButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24),
                saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                saveButton.heightAnchor.constraint(equalToConstant: 54)
                

            ])
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        priceTextField.resignFirstResponder()
        return true
    }
    
    private func createDetailView(title: String, value: String, options: [String]? = nil, onSelect: ((String) -> Void)? = nil) -> UIView {
        let container = UIView()
        container.backgroundColor = ThemeManager.color(for: .tableViewCellColor)
        container.layer.cornerRadius = 10
        container.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let valueButton = UIButton(type: .system)
        valueButton.setTitle(value, for: .normal)
        valueButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        valueButton.setTitleColor(.secondaryLabel, for: .normal)
        valueButton.contentHorizontalAlignment = .right
        valueButton.translatesAutoresizingMaskIntoConstraints = false

        // Configurar menú si hay opciones disponibles
        if let options = options {
            let menuItems = options.map { option in
                UIAction(title: option, handler: { _ in
                    valueButton.setTitle(option, for: .normal) // Actualizar el texto del botón
                    onSelect?(option) // Ejecutar la acción de selección
                })
            }

            valueButton.menu = UIMenu(title: "Selecciona \(title)", children: menuItems)
            valueButton.showsMenuAsPrimaryAction = true // Activa el menú en toques cortos
        }

        container.addSubview(titleLabel)
        container.addSubview(valueButton)

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),

            valueButton.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            valueButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            valueButton.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 10)
        ])

        return container
    }


}

class ContextMenuHandler: NSObject, UIContextMenuInteractionDelegate {
    private let options: [String]
    private let onSelect: (String) -> Void

    init(options: [String], onSelect: @escaping (String) -> Void) {
        self.options = options
        self.onSelect = onSelect
    }

    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let actions = self.options.map { option in
                UIAction(title: option, handler: { _ in
                    self.onSelect(option)
                })
            }
            return UIMenu(title: "Selecciona una opción", children: actions)
        }
    }
}


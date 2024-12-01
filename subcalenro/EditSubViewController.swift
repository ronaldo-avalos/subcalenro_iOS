//
//  EditSubViewController.swift
//  subcalenro
//
//  Created by Ronaldo Avalos on 28/11/24.
//

import Foundation
import UIKit

class EditSubViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingsUITableViewCell
        let settingOption = options[indexPath.row]

        cell.configure(with: settingOption)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Utility.isIpad ? 60 : 50
    }

    
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
    
    let tableOptionsView = UITableView(frame: .zero, style: .insetGrouped)
    let options: [SettingsCellModel] = [
        SettingsCellModel(type: .withAccessory, title: "Period", iconImage: Utility.renderingIcon("repeat.circle")),
        SettingsCellModel(type: .withAccessory, title: "Remind me", iconImage: Utility.renderingIcon("bell.circle")),
        SettingsCellModel(type: .withAccessory, title: "Plan detail", iconImage: Utility.renderingIcon("arrow.trianglehead.counterclockwise")),
        SettingsCellModel(type: .withAccessory, title: "Next bill", iconImage: Utility.renderingIcon("calendar.circle")),
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeManager.color(for: .primaryBackground)
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        view.addGestureRecognizer(tap)
        priceTextField.delegate = self
        tableOptionsView.dataSource = self
        tableOptionsView.delegate = self
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
            
            tableOptionsView.register(SettingsUITableViewCell.self, forCellReuseIdentifier: "cell")
            tableOptionsView.translatesAutoresizingMaskIntoConstraints = false
            tableOptionsView.isScrollEnabled = false
            tableOptionsView.backgroundColor = .clear
            
            view.addSubview(tableOptionsView)
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
        
            
                tableOptionsView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 20),
                tableOptionsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableOptionsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableOptionsView.heightAnchor.constraint(equalToConstant: CGFloat(options.count * 60) ), // Ajuste según contenido

                saveButton.topAnchor.constraint(equalTo: tableOptionsView.bottomAnchor, constant: 48),
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

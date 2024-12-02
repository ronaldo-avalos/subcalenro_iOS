//
//  FormNewSubController.swift
//  subcalenro
//
//  Created by Ronaldo Avalos on 02/12/24.
//

import Foundation
import Eureka


class FormNewSubController: FormViewController {

    var imgURL: String?
    var companyName: String?
    
    init(imgURL: String, companyName: String) {
        self.imgURL = imgURL
        self.companyName = companyName
        super.init(style: .insetGrouped) // Configurar el estilo aquí
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    let imageContainer : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.cornerCurve = .continuous
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.layer.cornerRadius = 12
        button.tintColor = ThemeManager.color(for: .secondaryText)
        button.clipsToBounds = true
        button.backgroundColor = ThemeManager.color(for: .secondaryBackground)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Añadir el gesto tap al fondo para cerrar el teclado
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        view.addGestureRecognizer(tap)
        
        view.backgroundColor = ThemeManager.color(for: .editBackgroud)
        self.navigationController?.navigationBar.tintColor = .label

        // Configurar la vista y agregar los elementos
        view.addSubview(imageContainer)
        view.addSubview(saveButton)
        
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false  // No permitir desplazamiento
        tableView.rowHeight = 54  // Establecer una altura para las celdas
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: imgURL ?? "")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: imageContainer.widthAnchor, multiplier: 0.8),
            imageView.heightAnchor.constraint(equalTo: imageContainer.heightAnchor, multiplier: 0.8),
        ])
        
        let nameField = UITextField()
        nameField.text = companyName ?? ""
        nameField.font = UIFont.boldSystemFont(ofSize: 32)
        nameField.backgroundColor = .clear
        nameField.placeholder = "Name"
        nameField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameField)
        
        NSLayoutConstraint.activate([
            imageContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 56),
            imageContainer.widthAnchor.constraint(equalToConstant: 120),  // Ancho del contenedor
            imageContainer.heightAnchor.constraint(equalToConstant: 120),  // Altura del contenedor
            
            nameField.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 14),
            nameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 24),  // Ajustar la tabla debajo del campo
            tableView.heightAnchor.constraint(equalToConstant: 400),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -54),
            saveButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 54)
        ])
        
        form +++
        Section()
        <<< SegmentedRow<String>() {
            $0.options = ["Trial", "Recurring", "Lifetime"]
            $0.cell.backgroundColor = .clear
            $0.value = $0.options?[1]
        }

        +++ Section()
        <<< IntRow() {
            $0.title = "Subscription cost"
            $0.placeholder = "$129.00"
            $0.useFormatterDuringInput = false
            $0.useFormatterOnDidBeginEditing = true
        }.cellSetup { cell, _ in
            cell.textField.keyboardType = .decimalPad
        }
        
        <<< PickerInputRow<String>("Billing cycle") {
            $0.title = "Options"
            $0.options = ["Weekly","Monthly","6 months","Yearly"]
            $0.value = $0.options[1]
        }
        
        <<< DateRow("dateRow") {
            $0.title = "Next billing date"
            $0.value = Date() // Fecha inicial
            $0.minimumDate = Date().addingTimeInterval(-31556926) // Máximo hace 1 año
            $0.maximumDate = Date().addingTimeInterval(31556926) // Máximo en 1 año
        }
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }
}

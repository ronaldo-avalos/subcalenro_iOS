//
//  SubscriptionViewController.swift
//  subcalenro
//
//  Created by ronaldo avalos on 04/10/24.
//

import Foundation
import UIKit

import Foundation
import UIKit


class SubscriptionViewController: UIViewController {
    
    // Botón para seleccionar el periodo
    private let periodButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Period", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Botón para seleccionar la fecha del próximo pago
    private let dateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Next Payment Date", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var selectedPeriod: SubscriptionPeriod = .monthly {
        didSet {
            // Actualizar el título del botón cuando se selecciona un periodo
            periodButton.setTitle("Period: \(selectedPeriod.rawValue)", for: .normal)
        }
    }
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var selectedDate: Date? {
        didSet {
            guard let date = selectedDate else { return }
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            dateButton.setTitle("Next Payment: \(formatter.string(from: date))", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        setupLayout()
    }
    
    // Configuración de layout
    private func setupLayout() {
        periodButton.addTarget(self, action: #selector(showPeriodMenu), for: .touchUpInside)
        dateButton.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
     
        // TextFields
        let nameTextField = UITextField()
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.placeholder = "Name"
        nameTextField.backgroundColor = .systemGray4
        view.addSubview(nameTextField)
        
        let priceTextField = UITextField()
        priceTextField.translatesAutoresizingMaskIntoConstraints = false
        priceTextField.placeholder = "Price"
        priceTextField.keyboardType = .decimalPad
        priceTextField.backgroundColor = .systemGray4
        view.addSubview(priceTextField)
        
        view.addSubview(periodButton)
        view.addSubview(dateButton)
        view.addSubview(saveButton)
        saveButton.addAction(UIAction(handler: { _ in
            self.saveSubscription(name: nameTextField.text, price: Double(priceTextField.text ?? "0"))
        }), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            nameTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            priceTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 14),
            priceTextField.heightAnchor.constraint(equalToConstant: 40),
            priceTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            priceTextField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            periodButton.topAnchor.constraint(equalTo: priceTextField.bottomAnchor, constant: 14),
            periodButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            periodButton.heightAnchor.constraint(equalToConstant: 40),
            periodButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            dateButton.topAnchor.constraint(equalTo: periodButton.bottomAnchor, constant: 14),
            dateButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            dateButton.heightAnchor.constraint(equalToConstant: 40),
            dateButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            saveButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -24),
            saveButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            saveButton.topAnchor.constraint(equalTo: dateButton.bottomAnchor, constant: 14)
        ])
    }
    
    // Menú para seleccionar el periodo de suscripción
    @objc private func showPeriodMenu() {
        let menuItems = SubscriptionPeriod.allCases.map { period in
            UIAction(title: period.rawValue) { [weak self] _ in
                self?.selectedPeriod = period
            }
        }
        let menu = UIMenu(title: "Select Period", children: menuItems)
        periodButton.menu = menu
        periodButton.showsMenuAsPrimaryAction = true
    }
    
    // Método para mostrar el selector de fecha
    @objc private func showDatePicker() {
        let alertController = UIAlertController(title: "Select Next Payment Date", message: "\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        
        // Configuramos el UIDatePicker
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
        alertController.view.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: alertController.view.centerXAnchor),
            datePicker.heightAnchor.constraint(equalToConstant: 200),
            datePicker.widthAnchor.constraint(equalToConstant: alertController.view.bounds.width),
            datePicker.topAnchor.constraint(equalTo: alertController.view.topAnchor),
        ])
        let selectAction = UIAlertAction(title: "Select", style: .default) { [weak self] _ in
            self?.selectedDate = datePicker.date
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(selectAction)
        alertController.addAction(cancelAction)
        
        // Presentar el controlador de alerta
        present(alertController, animated: true, completion: nil)
    }
    
    // Lógica para guardar la suscripción
    private func saveSubscription(name: String?, price: Double?) {
        guard let name = name, !name.isEmpty,
              let price = price, let date = selectedDate else {
            // Mostrar alerta si los datos no son válidos
            Utility.showSimpleAlert(on: self, title: nil, message: "Please fill in all details.", completion: {})
            return
        }
        
        let subscription = Subscription(id: UUID(), name: name, price: price, nextPaymentDate: date, period: selectedPeriod)
        
        SubscriptionManager.shared.save(subscription)
    }
    
    // Método para mostrar alertas de error
    private func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

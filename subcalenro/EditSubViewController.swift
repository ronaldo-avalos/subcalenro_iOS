//
//  EditSubViewController.swift
//  subcalenro
//
//  Created by Ronaldo Avalos on 28/11/24.
//

import Foundation
import UIKit
import Eureka

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
        view.backgroundColor = ThemeManager.color(for: .editBackgroud)
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
            
            view.addSubview(priceTextField)
            
            
            saveButton.addAction(UIAction(handler: { [weak self] _ in
                //
            }), for: .touchUpInside)
            
            // Configurar restricciones
            NSLayoutConstraint.activate([
                
                nameLabel.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 14),
                nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
                priceLabel.trailingAnchor.constraint(equalTo: priceTextField.leadingAnchor, constant: -6),
                priceLabel.centerYAnchor.constraint(equalTo: priceTextField.centerYAnchor),
                priceLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 12),
            
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
    
    
}

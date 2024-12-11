//
//  PayWallViewController.swift
//  subcalenro
//
//  Created by Ronaldo Avalos on 09/12/24.
//

import Foundation
import UIKit

class PayWallViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupViews()
    }
    
    // Configuración de un gradiente como fondo
    private func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.gray.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setupViews() {
        // Encabezado con una imagen atractiva
        let headerImage = UIImageView(image: .appicon) // Reemplaza con tu imagen
        headerImage.contentMode = .scaleAspectFit
        headerImage.layer.cornerRadius = 12
        headerImage.clipsToBounds = true
        headerImage.translatesAutoresizingMaskIntoConstraints = false
        
        // Título
        let titleLabel = UILabel()
        titleLabel.text = "Subcalenro Pro"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Descripción
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Organiza tus suscripciones como un profesional y ahorra tiempo y dinero."
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Lista de beneficios
        let benefits = [
            "✔️ Seguimiento ilimitado de suscripciones",
            "✔️ Alertas personalizables",
            "✔️ Sin anuncios",
            "✔️ Soporte Premium"
        ]
        let benefitsLabel = UILabel()
        benefitsLabel.text = benefits.joined(separator: "\n")
        benefitsLabel.font = UIFont.systemFont(ofSize: 16)
        benefitsLabel.numberOfLines = 0
        benefitsLabel.textAlignment = .left
        benefitsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Botón de suscripción
        let subscribeButton = UIButton(type: .system)
        subscribeButton.setTitle("Suscribirse por $9.99/mes", for: .normal)
        subscribeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        subscribeButton.setTitleColor(ThemeManager.color(for: .secondaryText), for: .normal)
        subscribeButton.backgroundColor = ThemeManager.color(for: .secondaryBackground)
        subscribeButton.layer.cornerRadius = 10
        subscribeButton.translatesAutoresizingMaskIntoConstraints = false
        subscribeButton.addTarget(self, action: #selector(subscribeTapped), for: .touchUpInside)
        
        // Botón de restaurar compras
        let restoreButton = UIButton(type: .system)
        restoreButton.setTitle("Restaurar compras", for: .normal)
        restoreButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        restoreButton.setTitleColor(.white, for: .normal)
        restoreButton.translatesAutoresizingMaskIntoConstraints = false
        restoreButton.addTarget(self, action: #selector(restoreTapped), for: .touchUpInside)
        
        // Agregar subviews
        view.addSubview(headerImage)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(benefitsLabel)
        view.addSubview(subscribeButton)
        view.addSubview(restoreButton)
        
        // Configurar constraints
        NSLayoutConstraint.activate([
            headerImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            headerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerImage.widthAnchor.constraint(equalToConstant: 150),
            headerImage.heightAnchor.constraint(equalToConstant: 150),
            
            titleLabel.topAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            benefitsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            benefitsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            benefitsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            subscribeButton.topAnchor.constraint(equalTo: benefitsLabel.bottomAnchor, constant: 30),
            subscribeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subscribeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            subscribeButton.heightAnchor.constraint(equalToConstant: 50),
            
            restoreButton.topAnchor.constraint(equalTo: subscribeButton.bottomAnchor, constant: 15),
            restoreButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc func subscribeTapped() {
        print("Usuario quiere suscribirse")
        // Implementar lógica de suscripción
    }
    
    @objc func restoreTapped() {
        print("Usuario quiere restaurar compras")
        // Implementar lógica de restauración de compras
    }
}

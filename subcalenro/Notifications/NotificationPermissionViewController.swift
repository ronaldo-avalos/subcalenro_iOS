//
//  NotificationPermissionViewController.swift
//  subcalenro
//
//  Created by Ronaldo Avalos on 19/10/24.
//

import Foundation
import UIKit

class NotificationPermissionViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isModalInPresentation = true
        view.backgroundColor = ThemeManager.color(for: .primaryBackground)
        
        let imageView = UIImageView(image: UIImage(named: "IllustrationNotification"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        let titleLabel = UILabel()
        titleLabel.text = "Let me remind you of their paid days"
        titleLabel.font = FontManager.sfCompactDisplay(size: 34, weight: .semibold)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Receive notifications for billing reminders, upcoming renewals, and subscription updates to manage your services better."
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        let continueButton = UIButton(type: .system)
        continueButton.setTitle("Continue", for: .normal)
        continueButton.titleLabel?.font = FontManager.sfCompactDisplay(size: 21, weight: .semibold)
        continueButton.backgroundColor = ThemeManager.color(for: .secondaryBackground)
        continueButton.setTitleColor(ThemeManager.color(for: .secondaryText), for: .normal)
        continueButton.layer.cornerRadius = 20
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(continueButton)
        
        let notNowButton = UIButton(type: .system)
        notNowButton.titleLabel?.font = FontManager.sfCompactDisplay(size: 16, weight: .semibold)
        notNowButton.setTitle("Not Now", for: .normal)
        notNowButton.setTitleColor(.gray, for: .normal)
        notNowButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(notNowButton)
        
        continueButton.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
        notNowButton.addAction(UIAction(handler: { _ in
            self.dismiss(animated: true)
            NotificationManager.shared.savePermissionStatus(.notNow)
        }), for: .touchUpInside)
        
        // Constraints
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 304),
            imageView.heightAnchor.constraint(equalToConstant: 416),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            continueButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 28),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.widthAnchor.constraint(equalToConstant: CGFloat(view.frame.width - 64)),
            continueButton.heightAnchor.constraint(equalToConstant: 74),
            
            notNowButton.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 10),
            notNowButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func closeModal() {
        NotificationManager.shared.requestNotificationPermission { [weak self] _ in
            DispatchQueue.main.async {
                self?.dismiss(animated: true)
            }
        }
    }

}


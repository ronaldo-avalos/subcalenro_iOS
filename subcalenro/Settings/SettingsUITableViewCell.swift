//
//  SettingsUITableViewCell.swift
//  subcalenro
//
//  Created by ronaldo avalos on 31/08/24.
//

import Foundation
import UIKit

class SettingsUITableViewCell: UITableViewCell {
    // UI Elements
    var checkImageView = UIImageView()
    let titleLabel = UILabel()
    let switchControl = UISwitch()
    var accessoryButton = UIButton(type: .system)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Configure your UI elements here
        setupCheckImageView()
        setupTitleLabel()
        setupSwitchControl()
        setupAccessoryButton() // Configuración del botón
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCheckImageView() {
        checkImageView.translatesAutoresizingMaskIntoConstraints = false
        checkImageView.contentMode = .scaleAspectFit
        checkImageView.tintColor = .label
        contentView.addSubview(checkImageView)
        
        NSLayoutConstraint.activate([
            checkImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            checkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkImageView.widthAnchor.constraint(equalToConstant: 24),
            checkImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "Title"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = ThemeManager.color(for: .primaryText)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: checkImageView.trailingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func setupSwitchControl() {
        switchControl.isHidden = true // Ocultar por defecto
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(switchControl)
        
        NSLayoutConstraint.activate([
            switchControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            switchControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func setupAccessoryButton() {
        accessoryButton.isHidden = true // Ocultar por defecto
        accessoryButton.translatesAutoresizingMaskIntoConstraints = false
        accessoryButton.setImage(Utility.renderingIcon("chevron.up.chevron.down"), for: .normal)
        accessoryButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        // Alinear imagen a la derecha y texto a la izquierda
        accessoryButton.semanticContentAttribute = .forceRightToLeft
        accessoryButton.showsMenuAsPrimaryAction = true
        
        contentView.addSubview(accessoryButton)
        
        NSLayoutConstraint.activate([
            accessoryButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            accessoryButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with model: SettingsCellModel) {
           titleLabel.text = model.title
           checkImageView.image = model.iconImage
           
           switch model.type {
           case .withSwitch:
               switchControl.isHidden = false
               accessoryButton.isHidden = true
               accessoryType = .none
           case .withAccessory:
               switchControl.isHidden = true
               accessoryButton.isHidden = true
               accessoryType = .disclosureIndicator
           case .withPopUp:
               switchControl.isHidden = true
               accessoryButton.isHidden = false
               accessoryType = .checkmark
           }
       }
}

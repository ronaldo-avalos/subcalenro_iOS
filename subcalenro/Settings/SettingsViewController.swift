//
//  SettingsViewController.swift
//  subcalenro
//
//  Created by ronaldo avalos on 04/08/24.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let tableSettingsView = UITableView(frame: .zero, style: .insetGrouped)
    let sections: [[SettingsCellModel]] = [
        // GENERAL
        [
        SettingsCellModel(type: .withAccessory, title: "Calenro Pro", iconImage: Utility.renderingIcon("sparkles"),options: [], selectedValue: ""),
        SettingsCellModel(type: .withAccessory, title: "Apariencia", iconImage: Utility.renderingIcon("eyeglasses"),options: [], selectedValue: ""),
        SettingsCellModel(type: .withAccessory, title: "Notifications", iconImage: Utility.renderingIcon("bell"),options: [], selectedValue: ""),
        SettingsCellModel(type: .withAccessory, title: "Edit Event", iconImage: Utility.renderingIcon("calendar"),options: [], selectedValue: ""),
        ],
        // ACCOUNT
        [
            SettingsCellModel(type: .withAccessory, title: "Account Settings", iconImage: Utility.renderingIcon("person.circle"),options: [], selectedValue: ""),
            SettingsCellModel(type: .withAccessory, title: "Privacy", iconImage: Utility.renderingIcon("lock.shield"),options: [], selectedValue: ""),
            SettingsCellModel(type: .withAccessory, title: "Help", iconImage: Utility.renderingIcon("questionmark.circle"),options: [], selectedValue: ""),
            SettingsCellModel(type: .withAccessory, title: "About", iconImage: Utility.renderingIcon("info.circle"),options: [], selectedValue: ""),
        ] ]
    

    
    let sectionTitles: [String] = ["General", "Account"]
    var selectedOption: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        tableSettingsView.dataSource = self
        tableSettingsView.delegate = self
    }
    
    func setupViews() {
        self.title = "Settings"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.largeTitleTextAttributes = [
               NSAttributedString.Key.foregroundColor: ThemeManager.color(for: .primaryText)
           ]
        self.navigationController?.navigationBar.tintColor = ThemeManager.color(for: .primaryText)
        
        let closeIcon = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeModal))
        closeIcon.tintColor = .systemGray2
        self.navigationItem.rightBarButtonItem = closeIcon
        
        tableSettingsView.register(SettingsUITableViewCell.self, forCellReuseIdentifier: "cell")
        tableSettingsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableSettingsView)
        
        NSLayoutConstraint.activate([
            tableSettingsView.topAnchor.constraint(equalTo: view.topAnchor),
            tableSettingsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableSettingsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableSettingsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func closeModal() {
        self.dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingsUITableViewCell
        let settingOption = sections[indexPath.section][indexPath.row]

        cell.configure(with: settingOption)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Utility.isIpad ? 60 : 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedOption = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        
        let section = indexPath.section
        let row = indexPath.row
        
        switch (section, row) {
        case (0, 0): // Calenro Pro
            navigateToCalenroPro()
        case (0, 1): // Apariencia
            navigateToAppearanceSettings()
        case (0, 2): // Notifications
            navigateToNotificationSettings()
        case (0, 3): // Edit Event
            navigateToEditEvent()
        case (1, 0): // Account Settings
            navigateToAccountSettings()
        case (1, 1): // Privacy
            navigateToPrivacySettings()
        case (1, 2): // Help
            showHelp()
        case (1, 3): // About
            showAbout()
        default:
            break
        }
    }
    
    func navigateToCalenroPro() {
        // Navega a la vista de Calenro Pro o realiza la acción correspondiente
        print("Navegar a Calenro Pro")
    }

    func navigateToAppearanceSettings() {
        // Navega a la vista de configuración de apariencia
        print("Navegar a Configuración de Apariencia")
    }

    func navigateToNotificationSettings() {
        // Navega a la vista de configuración de notificaciones
        print("Navegar a Configuración de Notificaciones")
    }

    func navigateToEditEvent() {
        // Navega a la vista de edición de eventos
        print("Navegar a Editar Evento")
    }

    func navigateToAccountSettings() {
        // Navega a la vista de configuración de cuenta
        print("Navegar a Configuración de Cuenta")
    }

    func navigateToPrivacySettings() {
        // Navega a la vista de privacidad
        print("Navegar a Configuración de Privacidad")
    }

    func showHelp() {
        // Muestra la vista de ayuda
        print("Mostrar Ayuda")
    }

    func showAbout() {
        // Muestra la vista de información de la app
        print("Mostrar Acerca de")
    }
}

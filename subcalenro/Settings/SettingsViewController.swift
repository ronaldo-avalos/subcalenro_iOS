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
        SettingsCellModel(type: .withAccessory, title: "Calenro Pro", iconImage: Utility.renderingIcon("sparkles")),
        SettingsCellModel(type: .withAccessory, title: "Apariencia", iconImage: Utility.renderingIcon("eyeglasses")),
        SettingsCellModel(type: .withAccessory, title: "Notifications", iconImage: Utility.renderingIcon("bell")),
        SettingsCellModel(type: .withAccessory, title: "App Icon", iconImage: Utility.renderingIcon("app.badge"))
        ],
        // ACCOUNT
        [
            SettingsCellModel(type: .withAccessory, title: "Calificar Calenro", iconImage: Utility.renderingIcon("star")),
            SettingsCellModel(type: .withAccessory, title: "Share App", iconImage: Utility.renderingIcon("square.and.arrow.up")),
            SettingsCellModel(type: .withAccessory, title: "Comments", iconImage: Utility.renderingIcon("tray.and.arrow.down")),
            SettingsCellModel(type: .withAccessory, title: "About", iconImage: Utility.renderingIcon("info.circle")),
        ] ]
    

    
    let sectionTitles: [String] = ["General", "Info"]
    var selectedOption: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        tableSettingsView.dataSource = self
        tableSettingsView.delegate = self
    }
    
    func setupViews() {
        self.title = "Settings"
        self.view.backgroundColor = ThemeManager.color(for: .editBackgroud)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .automatic
        let closeIcon = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeModal))
//        closeIcon.tintColor = .systemGray2
        self.navigationItem.rightBarButtonItem = closeIcon
    
        tableSettingsView.tableFooterView = createFooterView()
        tableSettingsView.backgroundColor = .clear
        tableSettingsView.showsVerticalScrollIndicator = false
        tableSettingsView.contentInset = UIEdgeInsets(top: 0, left: 0,  bottom: 200, right: 0)
        tableSettingsView.scrollIndicatorInsets = tableSettingsView.contentInset
        tableSettingsView.register(SettingsUITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableSettingsView)

        tableSettingsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableSettingsView.topAnchor.constraint(equalTo: view.topAnchor),
            tableSettingsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            tableSettingsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableSettingsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])


     
    }

    
    @objc func closeModal() {
        self.dismiss(animated: true)
    }
    
    func createFooterView() -> UIView {
        // Creamos un footerView con un tamaño flexible
        let footerView = UIView()
        footerView.backgroundColor = .clear

        
        // Icono de la app
        let appIcon = UIImageView()
        appIcon.image = .appicon // Asegúrate de usar el nombre correcto del asset
        appIcon.contentMode = .scaleAspectFit
        appIcon.layer.cornerRadius = 8
        appIcon.clipsToBounds = true
        appIcon.translatesAutoresizingMaskIntoConstraints = false
        
        let nameApp = UILabel()
        nameApp.text = "Subcalenro"
        nameApp.font = UIFont(name: "SFProRounded-Semibold", size: 22)
        nameApp.textAlignment = .center
        nameApp.translatesAutoresizingMaskIntoConstraints = false
        
        // Versión de la app
        let versionLabel = UILabel()
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLabel.text = "Version \(appVersion)"
        } else {
            versionLabel.text = "Version Unknown"
        }
        versionLabel.numberOfLines = 0
        versionLabel.font = UIFont(name: "SFProText-Regular", size: 12)
        versionLabel.textAlignment = .center
        versionLabel.textColor = .secondaryLabel
        versionLabel.translatesAutoresizingMaskIntoConstraints = false

        // Texto adicional
        let disclaimerLabel = UILabel()
        disclaimerLabel.text = """
    Subcalenro is an independent app and is not affiliated
    with or endorsed by any of the listed services.
    All product names, logos, and brands are property of 
    their respective owners.
    """
        disclaimerLabel.numberOfLines = 0
        disclaimerLabel.textAlignment = .center
        disclaimerLabel.textColor = .tertiaryLabel
        disclaimerLabel.font = UIFont.systemFont(ofSize: 9)
        disclaimerLabel.translatesAutoresizingMaskIntoConstraints = false

        // Agregamos los elementos al footerView
        footerView.addSubview(appIcon)
        footerView.addSubview(nameApp)
        footerView.addSubview(versionLabel)
        footerView.addSubview(disclaimerLabel)

        // Configuramos las constraints
        NSLayoutConstraint.activate([
            // Icono
            appIcon.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            appIcon.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 20),
            appIcon.widthAnchor.constraint(equalToConstant: 60),
            appIcon.heightAnchor.constraint(equalToConstant: 60),

            nameApp.topAnchor.constraint(equalTo: appIcon.bottomAnchor,constant: 12),
            nameApp.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            
            // Versión
            versionLabel.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            versionLabel.topAnchor.constraint(equalTo: nameApp.bottomAnchor, constant: 4),

            // Disclaimer
            disclaimerLabel.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            disclaimerLabel.topAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 6),
        ])
        
        return footerView
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
            navigateToChangeAppIcon()
        case (1, 0): // Account Settings
            navigateToRateApp()
        case (1, 1): // Privacy
            navigateToShareApp()
        case (1, 2): // Help
            navigateToComments()
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
        let vc = AppearanceViewController()
        self.show(vc, sender: nil)
    }

    func navigateToNotificationSettings() {
        // Navega a la vista de configuración de notificaciones
        print("Navegar a Configuración de Notificaciones")
    }

    func navigateToChangeAppIcon() {
        // Navega a la vista de edición de eventos
        print("Navegar a Editar Evento")
    }

    func navigateToRateApp() {
        guard let url = URL(string: "itms-apps://itunes.apple.com/app/id[YOUR_APP_ID]?action=write-review") else {
            print("URL inválida para valorar la app")
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("No se pudo abrir la URL para valorar la app")
        }
    }

    func navigateToShareApp() {
        let appURL = "https://apps.apple.com/app/id[YOUR_APP_ID]" // Reemplaza con el enlace de tu app
        let activityViewController = UIActivityViewController(activityItems: [appURL], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // Solo para iPad
        self.present(activityViewController, animated: true, completion: nil)
    }

    func navigateToComments() {
        let email = "ronaldoadan1@icloud.com"
        let subject = "comments and suggestions"
        let body = """
       App version: \(Utility.appVersion)
       iOS version: \(Utility.iOSVersion)
       Device info: \(Utility.deviceModel)
       """
        
        if let emailURL = URL(string: "mailto:\(email)?subject=\(subject)&body=\(body)") {
            UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
        }
    }

    func showAbout() {
        let aboutViewController = UIViewController()
        aboutViewController.view.backgroundColor = .systemBackground
        aboutViewController.modalPresentationStyle = .pageSheet
        
        // Añade contenido
        let titleLabel = UILabel()
        titleLabel.text = "Acerca de Subcalenro"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = """
        Subcalenro es una aplicación independiente diseñada para ayudarte a gestionar tus suscripciones de manera eficiente. No estamos afiliados a ninguna de las marcas o servicios mencionados en la app.
        """
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        aboutViewController.view.addSubview(titleLabel)
        aboutViewController.view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: aboutViewController.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: aboutViewController.view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: aboutViewController.view.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: aboutViewController.view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: aboutViewController.view.trailingAnchor, constant: -16),
        ])
        
        self.show(aboutViewController, sender: nil)
    }

}

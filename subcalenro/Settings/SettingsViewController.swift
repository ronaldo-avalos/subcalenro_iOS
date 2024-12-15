//
//  SettingsViewController.swift
//  subcalenro
//
//  Created by ronaldo avalos on 04/08/24.
//

import UIKit
import Shimmer

class SettingsViewController: UIViewController {
    
    let tableSettingsView = UITableView(frame: .zero, style: .insetGrouped)
    let sections: [[SettingsCellModel]] = [
        // GENERAL
        [
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
        self.navigationController?.navigationBar.isTranslucent = true
        let closeIcon = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeModal))
        self.navigationItem.rightBarButtonItem = closeIcon
        
        tableSettingsView.tableFooterView = createFooterView()
        
        setupTableHeaderView()
        
        
        tableSettingsView.backgroundColor = .clear
        tableSettingsView.showsVerticalScrollIndicator = false
        tableSettingsView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
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
    
    private func setupTableHeaderView() {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        // Contenedor para la imagen
        let containerView = UIView()
        containerView.backgroundColor = ThemeManager.color(for: .secondaryBackground)
        containerView.layer.cornerRadius = 22
        containerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(containerView)
        
        let starIcon = UIImageView(image: UIImage(systemName: "sparkle"))
        starIcon.tintColor = ThemeManager.color(for: .secondaryText)
        starIcon.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(starIcon)
        
        let titleLabel = UILabel()
        titleLabel.text = "Joi Subcalenro Pro"
        titleLabel.font = FontManager.sfCompactDisplay(size: 20, weight: .semibold)
        titleLabel.textColor = ThemeManager.color(for: .secondaryText)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Subscription or one-time purchase"
        descriptionLabel.numberOfLines = 2
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = ThemeManager.color(for: .secondaryText).withAlphaComponent(0.8)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(descriptionLabel)
    
        let gesture = UITapGestureRecognizer(target: self, action: #selector(navigateToCalenroPro))
           containerView.addGestureRecognizer(gesture)
           
        let shimmeringUpgradeButton = createShimmeringUpgradeButton()
        containerView.addSubview(shimmeringUpgradeButton)
        shimmeringUpgradeButton.shimmeringSpeed = 70 // Velocidad de desplazamiento
        shimmeringUpgradeButton.shimmeringPauseDuration = 0.8 // Pausa entre repeticiones

        // Agrega las constraints del shimmeringUpgradeButton
        NSLayoutConstraint.activate([
            shimmeringUpgradeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            shimmeringUpgradeButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            shimmeringUpgradeButton.widthAnchor.constraint(equalToConstant: 100),
            shimmeringUpgradeButton.heightAnchor.constraint(equalToConstant: 32)
        ])

  
        
        // Configurar restricciones
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            containerView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 16),
            containerView.widthAnchor.constraint(equalToConstant: view.bounds.width - 32),
            containerView.heightAnchor.constraint(equalToConstant: 90),
            
            starIcon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            starIcon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            starIcon.widthAnchor.constraint(equalToConstant: 24),
            starIcon.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: starIcon.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: shimmeringUpgradeButton.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            
            shimmeringUpgradeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            shimmeringUpgradeButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            shimmeringUpgradeButton.widthAnchor.constraint(equalToConstant: 100),
            shimmeringUpgradeButton.heightAnchor.constraint(equalToConstant: 32)
            
        ])
        
        // Ajusta el tamaño del header
        let headerHeight: CGFloat = 100
        headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: headerHeight)
        headerView.layoutIfNeeded()
        tableSettingsView.tableHeaderView = headerView

    }
    

    func createShimmeringUpgradeButton() -> FBShimmeringView {
        // Botón Upgrade
        let upgradeButton = UIButton(type: .system)
        upgradeButton.setTitle("Upgrade", for: .normal)
        upgradeButton.setTitleColor(ThemeManager.color(for: .secondaryText), for: .normal)
        upgradeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        upgradeButton.backgroundColor = ThemeManager.color(for: .primaryBackground).withAlphaComponent(0.2)
        upgradeButton.layer.cornerRadius = 16
        upgradeButton.translatesAutoresizingMaskIntoConstraints = false
        
        upgradeButton.addAction(UIAction(handler: { _ in
            self.navigateToCalenroPro()
        }), for: .touchUpInside)
        
        // Vista con Shimmer
        let shimmeringView = FBShimmeringView()
        shimmeringView.translatesAutoresizingMaskIntoConstraints = false
        shimmeringView.contentView = upgradeButton
        shimmeringView.isShimmering = true // Activa el efecto de brillo
        
        return shimmeringView
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
            navigateToAppearanceSettings()
        case (0, 1): // Apariencia
            navigateToNotificationSettings()
        case (0, 2): // Notifications
            navigateToChangeAppIcon()
        case (1, 0): // Edit Event
            navigateToRateApp()
        case (1, 1): // Account Settings
            navigateToShareApp()
        case (1, 2): // Privacy
            navigateToComments()
        case (1, 3): // Help
            showAbout()
        default:
            break
        }
    }
    
   @objc func navigateToCalenroPro() {
       Utility.feedbackGenerator(style: .light)
        let vc = PayWallViewController()
        self.show(vc, sender: nil)
    }
    
    func navigateToAppearanceSettings() {
        let vc = AppearanceViewController()
        self.show(vc, sender: nil)
    }
    
    func navigateToNotificationSettings() {
        let vc = NotificationsSettingsViewController()
        self.show(vc, sender: nil)
    }
    
    func navigateToChangeAppIcon() {
        let vc = AppIconChangeViewController()
        self.show(vc, sender: nil)
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
        Utility.feedbackGenerator(style: .light)
        let appURL = "https://apps.apple.com/app/id[YOUR_APP_ID]" // Reemplaza con el enlace de tu app
        let activityViewController = UIActivityViewController(activityItems: [appURL], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // Solo para iPad
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func navigateToComments() {
        Utility.feedbackGenerator(style: .light)
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
        Utility.feedbackGenerator(style: .light)
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

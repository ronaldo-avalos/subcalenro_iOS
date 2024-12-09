//
//  NottificationsSettingsViewController.swift
//  subcalenro
//
//  Created by Ronaldo Avalos on 09/12/24.
//

import Foundation
import UIKit

class NotificationsSettingsViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private var notificationSettings = [
        ("Reminders", true),
        ("Promotional Offers", false),
        ("Important Alerts", true),
        ("News Updates", false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeManager.color(for: .editBackgroud)
        self.navigationItem.title = "Notifications"
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NotificationCell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension NotificationsSettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath)
        let setting = notificationSettings[indexPath.row]
        
        // Configurar el texto
        cell.textLabel?.text = setting.0
        
        // Agregar un UISwitch
        let switchControl = UISwitch()
        switchControl.isOn = setting.1
        switchControl.tag = indexPath.row
        switchControl.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
        cell.accessoryView = switchControl
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NotificationsSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Puedes agregar funcionalidad adicional si es necesario
    }
}

// MARK: - Actions
extension NotificationsSettingsViewController {
    @objc private func switchToggled(_ sender: UISwitch) {
        let index = sender.tag
        notificationSettings[index].1 = sender.isOn
        print("Changed \(notificationSettings[index].0) to \(sender.isOn ? "ON" : "OFF")")
        
        // Aquí puedes guardar los cambios en UserDefaults o en un manager centralizado.
    }
}

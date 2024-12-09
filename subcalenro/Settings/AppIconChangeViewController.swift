//
//  AppIconChangeViewController.swift
//  subcalenro
//
//  Created by Ronaldo Avalos on 09/12/24.
//

import UIKit

class AppIconChangeViewController: UIViewController {
    
    private let icons = [
        ("Default", "defaultIcon"), // Nombre y nombre del ícono en Assets
        ("Blue", "blueIcon"),
        ("Green", "greenIcon"),
        ("Dark", "darkIcon")
    ]
    
    private var selectedIconName: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        title = "Cambiar Ícono"
        view.backgroundColor = ThemeManager.color(for: .editBackgroud)
        
        // Crear UITableView para mostrar los íconos
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "IconCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func changeAppIcon(to iconName: String?) {
        guard UIApplication.shared.supportsAlternateIcons else {
            let alert = UIAlertController(
                title: "Error",
                message: "Tu dispositivo no soporta cambios de íconos.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
            present(alert, animated: true)
            return
        }
        
        UIApplication.shared.setAlternateIconName(iconName) { error in
            if let error = error {
                let alert = UIAlertController(
                    title: "Error",
                    message: "No se pudo cambiar el ícono: \(error.localizedDescription)",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
                self.present(alert, animated: true)
            } else {
                let successAlert = UIAlertController(
                    title: "Ícono Cambiado",
                    message: "El ícono de la app se cambió exitosamente.",
                    preferredStyle: .alert
                )
                successAlert.addAction(UIAlertAction(title: "Aceptar", style: .default))
                self.present(successAlert, animated: true)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension AppIconChangeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
        let icon = icons[indexPath.row]
        cell.textLabel?.text = icon.0
        cell.imageView?.image = UIImage(named: icon.1)
        cell.accessoryType = (selectedIconName == icon.1) ? .checkmark : .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AppIconChangeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedIcon = icons[indexPath.row]
        selectedIconName = selectedIcon.1 == "defaultIcon" ? nil : selectedIcon.1 // nil para ícono por defecto
        changeAppIcon(to: selectedIconName)
        tableView.reloadData()
    }
}

//
//  AppearanceViewController.swift
//  calenro
//
//  Created by ronaldo avalos on 12/09/24.
//

import Foundation
import UIKit

class AppearanceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let options = ["Light", "Dark", "Automatic"]
    var selectedOption: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Appearance"
        view.backgroundColor = ThemeManager.color(for: .editBackgroud)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        loadSavedAppearancePreference()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func loadSavedAppearancePreference() {
//        if let savedPreference = PreferencesManager.shared.getAppearancePreference() {
//            switch savedPreference {
//            case .light:
//                selectedOption = 0
//            case .dark:
//                selectedOption = 1
//            case .automatic:
//                selectedOption = 2
//            }
//            tableView.reloadData()
//        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        .none
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        if selectedOption == indexPath.row {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedOption = indexPath.row
        tableView.reloadData()
        
        switch indexPath.row {
        case 0: break
           // PreferencesManager.shared.saveAppearancePreference(.light)
        case 1: break
           // PreferencesManager.shared.saveAppearancePreference(.dark)
        case 2: break
          //  PreferencesManager.shared.saveAppearancePreference(.automatic)
        default:
            break
        }
    
        NotificationCenter.default.post(name: .appearanceChanged, object: nil)
    }
}

// MARK: - Notification Extension
extension Notification.Name {
    static let appearanceChanged = Notification.Name("appearanceChanged")
}


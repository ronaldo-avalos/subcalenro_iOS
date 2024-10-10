//
//  bottomEventContainer.swift
//  subcalenro
//
//  Created by ronaldo avalos on 08/09/24.
//

import Foundation
import UIKit

class BottomContainer: UIView {

    let topBorder = UIView()
    let tableView = UITableView()
    var subscriptions: [Subscription] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        backgroundColor = ThemeManager.color(for: .primaryBackground)
        topBorder.backgroundColor = .systemGray4
        topBorder.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(SubscriptionCell.self, forCellReuseIdentifier: "SubscriptionCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
     
        addSubview(topBorder)
        addSubview(tableView)

        NSLayoutConstraint.activate([
            topBorder.topAnchor.constraint(equalTo: topAnchor),
            topBorder.leadingAnchor.constraint(equalTo: leadingAnchor),
            topBorder.trailingAnchor.constraint(equalTo: trailingAnchor),
            topBorder.heightAnchor.constraint(equalToConstant: 0.3),
            
            tableView.topAnchor.constraint(equalTo: topBorder.bottomAnchor, constant: 6),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // Método para cargar las suscripciones
    func loadSubscriptions(_ subscriptions: [Subscription]) {
        self.subscriptions = subscriptions
        tableView.reloadData()
    }
}

extension BottomContainer: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  83
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscriptions.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.cellForRow(at: indexPath)?.selectionStyle  = .none
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionCell", for: indexPath) as? SubscriptionCell else {
            return UITableViewCell()
        }
        
        let subscription = subscriptions[indexPath.row]
        cell.configure(with: subscription)
        
        return cell
    }
}


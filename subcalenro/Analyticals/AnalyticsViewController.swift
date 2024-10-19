//
//  AnalyticalsViewController.swift
//  subcalenro
//
//  Created by Ronaldo Avalos on 18/10/24.
//

import Foundation
import UIKit
import DGCharts

class AnalyticsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeManager.color(for: .primaryBackground)
        self.title = "Analytics"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: ThemeManager.color(for: .primaryText)
        ]
        self.navigationController?.navigationBar.tintColor = ThemeManager.color(for: .primaryText)
        setupDashboard()
    }
    
    private func setupDashboard() {
        // Creación de contenedor principal de la vista
        let mainScrollView = UIScrollView()
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainScrollView)
        
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        mainScrollView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),
            containerView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor)
        ])
        
        // MARK: - Sección de cuentas (Cash, Revolut Main, Subscriptions Card)
        let accountsStack = createAccountsStack()
        containerView.addSubview(accountsStack)
        
        NSLayoutConstraint.activate([
            accountsStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            accountsStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            accountsStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])
        
        // MARK: - Sección de gráfico de gastos
        let expensesChart = createExpensesChart()
        view.addSubview(expensesChart)
        
        NSLayoutConstraint.activate([
            expensesChart.topAnchor.constraint(equalTo: accountsStack.bottomAnchor, constant: 20),
            expensesChart.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            expensesChart.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            expensesChart.heightAnchor.constraint(equalToConstant: 300) // Ajusta la altura según tu preferencia
        ])
        //        NSLayoutConstraint.activate([
        //            expensesChartView.topAnchor.constraint(equalTo: accountsStack.bottomAnchor, constant: 20),
        //            expensesChartView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
        //            expensesChartView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
        //            expensesChartView.heightAnchor.constraint(equalToConstant: 300)
        //        ])
        //
        //        // MARK: - Sección de últimos registros
        //        let lastRecordsView = createLastRecordsView()
        //        containerView.addSubview(lastRecordsView)
        //
        //        NSLayoutConstraint.activate([
        //            lastRecordsView.topAnchor.constraint(equalTo: expensesChartView.bottomAnchor, constant: 20),
        //            lastRecordsView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
        //            lastRecordsView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
        //            lastRecordsView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
        //            lastRecordsView.heightAnchor.constraint(equalToConstant: 100)
        //        ])
    }
    
    private func createAccountsStack() -> UIStackView {
        let cashView = createAccountCard(title: "Subscriptions", amount: String(SubscriptionManager().getSubscriptionTotal()), iconName: "person.crop.rectangle.stack")
        let revolutView = createAccountCard(title: "Total cost", amount: "$800", iconName: "dollarsign.circle")
        
        let accountsStack = UIStackView(arrangedSubviews: [cashView, revolutView])
        accountsStack.axis = .horizontal
        accountsStack.distribution = .fillEqually
        accountsStack.spacing = 6
        accountsStack.translatesAutoresizingMaskIntoConstraints = false
        return accountsStack
    }
    
    private func createAccountCard(title: String, amount: String, iconName: String) -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = ThemeManager.color(for: .tableViewCellColor)
        cardView.layer.cornerRadius = 10
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.heightAnchor.constraint(equalToConstant: 95).isActive = true
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .secondaryLabel
        titleLabel.font = UIFont.boldSystemFont(ofSize: 12)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let amountLabel = UILabel()
        amountLabel.text = amount
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.textColor = ThemeManager.color(for: .primaryText)
        amountLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: iconName)?.withTintColor(.label, renderingMode: .alwaysOriginal)
        iconView.contentMode = .scaleAspectFit
        iconView.layer.cornerRadius = 15
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        let views =  [iconView, titleLabel, amountLabel]
        views.forEach(cardView.addSubview(_:))
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 6),
            iconView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor,constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: iconView.leadingAnchor,constant: 6),
            amountLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 6),
            amountLabel.leadingAnchor.constraint(equalTo: iconView.leadingAnchor,constant: 6),
            
        ])
        
        return cardView
    }
    
    
    private func createExpensesChart() -> PieChartView {
        
        let pieChartView = PieChartView()
        pieChartView.usePercentValuesEnabled = true
        pieChartView.holeColor = .clear
        pieChartView.transparentCircleColor = .clear
        pieChartView.chartDescription.enabled = false
        pieChartView.translatesAutoresizingMaskIntoConstraints = false
        
        let categories = ["Hobby", "Tools", "fitness","Otros"]
        let values = [30.0, 25.0, 20.0, 10.0]
        
        var entries = [PieChartDataEntry]()
        for (index, value) in values.enumerated() {
            entries.append(PieChartDataEntry(value: value, label: categories[index]))
        }
        
        let dataSet = PieChartDataSet(entries: entries, label: "Label")
        
        dataSet.colors = ChartColorTemplates.vordiplom()
        
        let data = PieChartData(dataSet: dataSet)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        data.setValueFont(UIFont.boldSystemFont(ofSize: 12))
        data.setValueTextColor(ThemeManager.color(for: .primaryText))
        
        
        pieChartView.data = data
        
        pieChartView.holeRadiusPercent = 0.5
        pieChartView.legend.enabled = false
        return pieChartView
    }
    
    
    private func createLastRecordsView() -> UIView {
        let recordsView = UIView()
        recordsView.backgroundColor = .darkGray
        recordsView.layer.cornerRadius = 10
        recordsView.translatesAutoresizingMaskIntoConstraints = false
        
        let recordsLabel = UILabel()
        recordsLabel.text = "Last Records"
        recordsLabel.textColor = .white
        recordsLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        recordsView.addSubview(recordsLabel)
        recordsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recordsLabel.topAnchor.constraint(equalTo: recordsView.topAnchor, constant: 10),
            recordsLabel.leadingAnchor.constraint(equalTo: recordsView.leadingAnchor, constant: 10)
        ])
        
        // Implementar la tabla o lista para los registros.
        
        return recordsView
    }
}




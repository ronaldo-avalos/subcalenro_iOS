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
        
        // MARK: - Sección de gráfico de gastos (ahora dentro de un contenedor con estilo)
        let chartCardView = createChartCard()
        containerView.addSubview(chartCardView)
        
        NSLayoutConstraint.activate([
            chartCardView.topAnchor.constraint(equalTo: accountsStack.bottomAnchor, constant: 20),
            chartCardView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            chartCardView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            chartCardView.heightAnchor.constraint(equalToConstant: 320) // Ajusta la altura según tu preferencia
        ])
    }

    private func createChartCard() -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = ThemeManager.color(for: .tableViewCellColor)
        cardView.layer.cornerRadius = 10
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.heightAnchor.constraint(equalToConstant: 320).isActive = true
        cardView.isUserInteractionEnabled = true  // Asegurar que el contenedor pueda recibir toques
        
        let titleLabel = UILabel()
        titleLabel.text = " "
        titleLabel.textColor = .secondaryLabel
        titleLabel.font = UIFont.boldSystemFont(ofSize: 12)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Crear el gráfico de gastos
        let expensesChart = createExpensesChart()
        expensesChart.isUserInteractionEnabled = true // Asegurar que el gráfico reciba toques
        expensesChart.highlightPerTapEnabled = true   // Permitir destacar las secciones con tap
        
        cardView.addSubview(expensesChart)
        
        // Constraints para el gráfico dentro del contenedor
        NSLayoutConstraint.activate([
            expensesChart.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10),
            expensesChart.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            expensesChart.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
            expensesChart.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -10)
        ])
        
        return cardView
    }

    
    private func createAccountsStack() -> UIStackView {
        let cashView = createAccountCard(title: "Subscriptions", amount: String(SubscriptionManager().getSubscriptionTotal()), iconName: "person.crop.rectangle.stack")
        let revolutView = createAccountCard(title: "Total cost", amount: "$800", iconName: "dollarsign.circle")
        
        let accountsStack = UIStackView(arrangedSubviews: [cashView, revolutView])
        accountsStack.axis = .horizontal
        accountsStack.distribution = .fillEqually
        accountsStack.spacing = 6
        accountsStack.translatesAutoresizingMaskIntoConstraints = false
        accountsStack.isUserInteractionEnabled = true
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
        pieChartView.highlightPerTapEnabled = true // Permite resaltar la sección al hacer tap


        // Crear un diccionario para acumular los montos por categoría
        let categoryTotals = SubscriptionManager().getSubscriptionTotalsByCategory()

        // Crear las entradas para el gráfico
        var entries = [PieChartDataEntry]()
        for (category, total) in categoryTotals {
            entries.append(PieChartDataEntry(value: total, label: category))
        }

        let dataSet = PieChartDataSet(entries: entries, label: "Suscripciones por Categoría")
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




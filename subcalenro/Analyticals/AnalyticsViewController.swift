//
//  AnalyticalsViewController.swift
//  subcalenro
//
//  Created by Ronaldo Avalos on 18/10/24.
//
import Foundation
import UIKit
import DGCharts

class AnalyticsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,ChartViewDelegate {
    
    private var selectedCategory: String?
    private var subscriptions: [Subscription] = []
    
    // MARK: - UI Elements
    private lazy var tableViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeManager.color(for: .tableViewCellColor)
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.isHidden = true // Oculto por defecto
        return view
    }()
    
    private lazy var tableViewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Suscripciones por Categoría"
        label.textColor = .secondaryLabel
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SubscriptionCell.self, forCellReuseIdentifier: "SubscriptionCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Ciclo de Vida
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupLayout()
    }
    
    // MARK: - Configuraciones de UI
    private func setupViewController() {
        view.backgroundColor = ThemeManager.color(for: .primaryBackground)
        self.title = "Analytics"
        let closeIcon = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeModal))
        closeIcon.tintColor = .systemGray2
        self.navigationItem.rightBarButtonItem = closeIcon        
        navigationController?.navigationBar.tintColor = ThemeManager.color(for: .primaryText)
    }
    
    @objc func closeModal() {
        self.dismiss(animated: true)
    }
    
    private func setupLayout() {
        // Crear UIScrollView y containerView
        let scrollView = UIScrollView()
        let containerView = UIView()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        // Agregar cardsStack y expensesChart al containerView
        let expensesChart = createExpensesChart()
        let cardsStack = createAccountsStack()
        
        containerView.addSubview(cardsStack)
        containerView.addSubview(expensesChart)
        containerView.addSubview(tableViewContainer)
        
        
        // Desactivar la traducción de AutoresizingMask a restricciones
        cardsStack.translatesAutoresizingMaskIntoConstraints = false
        expensesChart.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints para el scrollView y containerView
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Constraints para las tarjetas y el gráfico dentro del containerView
        NSLayoutConstraint.activate([
            cardsStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            cardsStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            cardsStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            cardsStack.heightAnchor.constraint(equalToConstant: 95),
            
            expensesChart.topAnchor.constraint(equalTo: cardsStack.bottomAnchor, constant: 16),
            expensesChart.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            expensesChart.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            expensesChart.heightAnchor.constraint(equalToConstant: 320),
            expensesChart.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            
            tableViewContainer.topAnchor.constraint(equalTo: expensesChart.bottomAnchor, constant: 20),
            tableViewContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            tableViewContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            tableViewContainer.heightAnchor.constraint(equalToConstant: 500)
            
        ])
        
        // Agregar titleLabel y tableView al tableViewContainer
      
        tableViewContainer.addSubview(tableViewTitleLabel)
        tableViewContainer.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableViewTitleLabel.topAnchor.constraint(equalTo: tableViewContainer.topAnchor, constant: 12),
            tableViewTitleLabel.leadingAnchor.constraint(equalTo: tableViewContainer.leadingAnchor, constant: 16),
            tableViewTitleLabel.trailingAnchor.constraint(equalTo: tableViewContainer.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: tableViewTitleLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: tableViewContainer.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: tableViewContainer.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: tableViewContainer.bottomAnchor)
        ])
        
    }
    
    private func createAccountsStack() -> UIStackView {
        let subscriptionsView = createAccountCard(title: "Subscriptions", amount: String(SubscriptionManager().getSubscriptionTotal()), iconName: "person.crop.rectangle.stack")
        let totalCostView = createAccountCard(title: "Total cost", amount:String(SubscriptionManager().getConstTotal()), iconName: "dollarsign.circle")
        
        let accountsStack = UIStackView(arrangedSubviews: [subscriptionsView, totalCostView])
        accountsStack.axis = .horizontal
        accountsStack.distribution = .fillEqually
        accountsStack.spacing = 8
        
        // Añadir tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(subscriptionViewTapped))
        subscriptionsView.addGestureRecognizer(tapGesture)
        
        return accountsStack
    }
    
    // MARK: - Funciones de Eventos
    @objc private func subscriptionViewTapped() {
        let vc = SubListViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Método para Crear la Tarjeta (Account Card)
    private func createAccountCard(title: String, amount: String, iconName: String) -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = ThemeManager.color(for: .tableViewCellColor)
        cardView.layer.cornerRadius = 16
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .secondaryLabel
        titleLabel.font = UIFont.boldSystemFont(ofSize: 12)
        
        let amountLabel = UILabel()
        amountLabel.text = amount
        amountLabel.textColor = ThemeManager.color(for: .primaryText)
        amountLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: iconName)?.withTintColor(.label, renderingMode: .alwaysOriginal)
        iconView.contentMode = .scaleAspectFill
        
        // Agregar sub-vistas
        let stackView = UIStackView(arrangedSubviews: [iconView, titleLabel, amountLabel])
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(stackView)
        
        // Constraints
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12)
        ])
        
        return cardView
    }
    
    // MARK: - Creación del Gráfico
    private func createExpensesChart() -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = ThemeManager.color(for: .tableViewCellColor)
        cardView.layer.cornerRadius = 16
        
        let titleLabel = UILabel()
        titleLabel.text = "Distribución de gastos por categoría"
        titleLabel.textColor = .secondaryLabel
        titleLabel.font =  UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: "circle.dashed")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        iconView.contentMode = .scaleAspectFill
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        let pieChartView = PieChartView()
        pieChartView.usePercentValuesEnabled = true
        pieChartView.holeColor = .clear
        pieChartView.transparentCircleColor = .clear
        pieChartView.chartDescription.enabled = false
        pieChartView.highlightPerTapEnabled = true
        pieChartView.delegate = self
        
        
        // Obtener el total de suscripciones por categoría
        let categoryTotals = SubscriptionManager().getSubscriptionCountByCategory()
        let totalSubscriptions = categoryTotals.values.reduce(0, +) // Total de suscripciones

        var entries = [PieChartDataEntry]()
        // Calcular el porcentaje de suscripciones por categoría
        for (category, count) in categoryTotals {
            let percentage = (Double(count) / Double(totalSubscriptions)) * 100
            entries.append(PieChartDataEntry(value: percentage, label: category))
        }


        let dataSet = PieChartDataSet(entries: entries, label: "Subscriptions")
        dataSet.colors = ChartColorTemplates.material()
        
        let data = PieChartData(dataSet: dataSet)
        
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        data.setValueFont(UIFont.systemFont(ofSize: 14, weight: .medium))
        data.setValueTextColor(.black)
        
        pieChartView.data = data
        pieChartView.holeRadiusPercent = 0.5
        pieChartView.legend.enabled = false
        pieChartView.translatesAutoresizingMaskIntoConstraints = false
        pieChartView.animate(xAxisDuration: 1.5, easingOption: .easeInOutQuad)
        
        cardView.addSubview(iconView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(pieChartView)
        
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: cardView.topAnchor,constant: 10),
            iconView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor,constant: 10),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -10),
            
            pieChartView.topAnchor.constraint(equalTo: iconView.bottomAnchor),
            pieChartView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor,constant: 10),
            pieChartView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor,constant: -10),
            pieChartView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor,constant: -10),
            
        ])
        
        return cardView
    }
    // MARK: - Mostrar y Ocultar la Tabla
    private func showTableView(for category: String) {
        selectedCategory = category
        tableViewTitleLabel.text = category
        
        subscriptions = SubscriptionManager().getSubscriptions(for: category)
        tableView.reloadData()
        
        if tableViewContainer.isHidden {
            tableViewContainer.alpha = 0
            tableViewContainer.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.tableViewContainer.alpha = 1
            }
        }
    }
    
    // MARK: - Métodos de UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscriptions.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        83
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionCell", for: indexPath) as! SubscriptionCell
        let subscription = subscriptions[indexPath.row]
        cell.configure(with: subscription)
        return cell
    }
    
    
    // MARK: - Método para cuando se seleccione una categoría en el gráfico
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let pieEntry = entry as? PieChartDataEntry,
              let category = pieEntry.label else { return }
        
        showTableView(for: category)
    }
    
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        //
    }
    
    
}


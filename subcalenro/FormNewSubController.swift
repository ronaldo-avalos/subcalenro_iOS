//
//  FormNewSubController.swift
//  subcalenro
//
//  Created by Ronaldo Avalos on 02/12/24.
//

import Foundation
import Eureka
import ToastViewSwift

class FormNewSubController: FormViewController {
    
    var imgURL: String?
    var companyName: String?
    private var saveButton: UIBarButtonItem!
    
    
    init(imgURL: String?, companyName: String?) {
        self.imgURL = imgURL
        self.companyName = companyName
        super.init(style: .insetGrouped) // Configurar el estilo aquí
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeManager.color(for: .editBackgroud)
        saveButton = UIBarButtonItem(systemItem: .save)
        saveButton.isEnabled = false
        saveButton.target = self
        saveButton.action = #selector(saveSubscription)
        navigationItem.rightBarButtonItem = saveButton
        
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        setupTableHeaderView()
        
    form +++
        Section()
        
        <<< SegmentedRow<String>() { row in
            row.options = ["Trial", "Recurring", "Lifetime"]
            row.value = "Recurring"
            row.tag = "SubscriptionType"
        }.onChange { [weak self] row in
            self?.updateFormBasedOnSubscriptionType(row.value)
        }
        
        <<< IntRow() {
            $0.title = "SubscriptionCost"
            $0.placeholder = "$129.00"
            $0.useFormatterDuringInput = false
            $0.useFormatterOnDidBeginEditing = true
            $0.tag = "SubscriptionCost"
        }.cellSetup { cell, _ in
            cell.textField.keyboardType = .decimalPad
            cell.imageView?.image = UIImage(systemName: "dollarsign.circle")
        }.onChange { [weak self] row in
            // Habilitar/deshabilitar el botón de guardar basado en si hay un valor
            self?.saveButton.isEnabled = (row.value != nil && row.value! > 0)
        }
        
        <<< PickerInputRow<String>() {
            $0.title = "Period"
            $0.options = SubscriptionPeriod.allCases.map { $0.name }
            $0.value = $0.options.first
            $0.tag = "BillingCycle"
        }.cellSetup { cell, _ in
            cell.imageView?.image = UIImage(systemName: "arrow.clockwise")
        }.onChange { _ in
            // Comentado: lógica de custom days
            /*
             guard let self = self else { return }
             if let periodRow = form.rowBy(tag: "BillingCycle") as? PickerInputRow<String>,
             let customDaysRow = form.rowBy(tag: "CustomDays") {
             customDaysRow.hidden = Condition(booleanLiteral: periodRow.value != "Custom")
             customDaysRow.evaluateHidden()
             }
             */
        }
        // <<< IntRow para periodo custom (comentado)
        /*
         <<< IntRow() {
         $0.hidden = Condition(booleanLiteral: true) // Inicialmente oculta
         $0.title = "Custom period (days)"
         $0.placeholder = "days"
         $0.value = nil
         $0.tag = "CustomDays"
         }.cellSetup { cell, _ in
         cell.imageView?.image = UIImage(systemName: "calendar.badge.plus")
         }
         */
        
        <<< DateRow() {
            $0.title = "Next billing date"
            $0.value = Date() // Fecha inicial
            $0.minimumDate = Calendar.current.date(byAdding: .year, value: -2, to: Date())
            $0.maximumDate = Calendar.current.date(byAdding: .year, value: 20, to: Date())
            $0.tag = "DateRow"
        }.cellSetup { cell, _ in
            cell.imageView?.image = UIImage(systemName: "calendar")
        }
        
        
        +++ Section()
        
        <<< PickerInputRow<String>() {
            $0.title = "Reminder"
            $0.tag = "PickerInputRow"
            $0.options = ReminderOption.allCases.map { $0.name}
            $0.value = $0.options[1]
        }.cellSetup { cell, _ in
            cell.imageView?.image = UIImage(systemName: "bell")
            
        }
        
        <<< DoublePickerInputRow<String, String>() {
            $0.title = "Duration"
            $0.tag = "SubDuration"
            $0.firstOptions = {return ["Forever"] + (1...180).map { "\($0)" }} // Crear array con "Forever" y números del 1 al 180
            $0.secondOptions = { _ in
                return ["", "Day(s)", "Week(s)", "Month(s)", "Year(s)"] // Opciones para la segunda columna
            }
            $0.value = Tuple(a: "2", b: "Years(s)") // Valor por defecto
        }.cellSetup { cell, _ in
            cell.imageView?.image = UIImage(systemName: "calendar.badge.clock")
            
        }.onChange { row in
            guard let value = row.value else { return }
            
            if value.a == "Forever" && !value.b.isEmpty {
                row.value = Tuple(a: "Forever", b: "")
            } else if value.a != "Forever" && value.b == "" {
                row.value = Tuple(a:value.a, b: "Day(s)")
            }
        }
        
        <<< PickerInputRow<String>() {
            $0.title = "Categorie"
            $0.tag = "PlanDetail"
            $0.options = SubscriptionCategory.allCases.map { $0.displayName() }
            $0.value = $0.options[1]
        }.cellSetup { cell, _ in
            cell.imageView?.image = UIImage(systemName: "square.3.layers.3d.down.backward")
        }
        
    }
    
    private func setupTableHeaderView() {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        // Contenedor para la imagen
        let imageContainer = UIView()
        imageContainer.backgroundColor = .white
        imageContainer.layer.cornerRadius = 20
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(editImageTapped)))
        headerView.addSubview(imageContainer)
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: imgURL ?? "icon2") // Imagen inicial
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.addSubview(imageView)
        
        // Botón de editar
        let editImageButton = UIButton(type: .system)
        editImageButton.setTitle("Edit", for: .normal)
        editImageButton.tintColor = .systemBlue
        editImageButton.translatesAutoresizingMaskIntoConstraints = false
        editImageButton.addTarget(self, action: #selector(editImageTapped), for: .touchUpInside)
        headerView.addSubview(editImageButton)
        
        // Campo de texto para el nombre de la empresa
        let companyNameTextField = UITextField()
        companyNameTextField.placeholder = "Enter subcription name"
        companyNameTextField.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        companyNameTextField.textAlignment = .center
        companyNameTextField.borderStyle = .none
        companyNameTextField.text = companyName // Texto inicial
        companyNameTextField.addTarget(self, action: #selector(companyNameChanged(_:)), for: .editingChanged)
        companyNameTextField.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(companyNameTextField)
        
        // Configurar restricciones
        NSLayoutConstraint.activate([
            imageContainer.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            imageContainer.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 16),
            imageContainer.widthAnchor.constraint(equalToConstant: 120),
            imageContainer.heightAnchor.constraint(equalToConstant: 120),
            
            imageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: imageContainer.widthAnchor, multiplier: 0.8),
            imageView.heightAnchor.constraint(equalTo: imageContainer.heightAnchor, multiplier: 0.8),
            
            editImageButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            editImageButton.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 2),
            editImageButton.widthAnchor.constraint(equalToConstant: 32),
            editImageButton.heightAnchor.constraint(equalToConstant: 32),
            
            companyNameTextField.topAnchor.constraint(equalTo: editImageButton.bottomAnchor, constant: 12),
            companyNameTextField.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            companyNameTextField.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            companyNameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Ajusta el tamaño del header
        let headerHeight: CGFloat = 224
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: headerHeight)
        
        tableView.tableHeaderView = headerView
    }

    @objc private func editImageTapped() {
        let iconSelector = IconSelectionViewController()
        iconSelector.onIconSelected = { [weak self] selectedIcon in
            guard let self = self else { return }
            self.imgURL = selectedIcon
            if let headerView = self.tableView.tableHeaderView,
               let imageView = headerView.subviews.compactMap({$0}).first?.subviews.compactMap({ $0 as? UIImageView }).first {
                imageView.image = UIImage(named: selectedIcon)
            }
        }
        
        let navController = UINavigationController(rootViewController: iconSelector)
        self.present(navController, animated: true)
    }

    @objc private func companyNameChanged(_ textField: UITextField) {
        companyName = textField.text
    }

    // Función para actualizar el formulario según el tipo de suscripción seleccionado
    private func updateFormBasedOnSubscriptionType(_ type: String?) {
        // Recuperar filas por tag
        let periodRow: BaseRow? = form.rowBy(tag: "BillingCycle")
        let durationRow: BaseRow? = form.rowBy(tag: "SubDuration")
        // let customDaysRow: BaseRow? = form.rowBy(tag: "CustomDays") // Comentado

        switch type {
        case "Lifetime":
            // Ocultar periodo y duración para Lifetime
            durationRow?.hidden = true
            
        case "Trial":
            // Ocultar periodo y duración para Trial
            periodRow?.hidden = true
            durationRow?.hidden = true
//            customDaysRow?.hidden = true
            
            // Agregar un mensaje de advertencia para Trial
            if let footer = tableView.tableFooterView {
                footer.isHidden = false
            } else {
                let footerLabel = UILabel()
                footerLabel.text = "Se te notificará antes de que termine el periodo de prueba."
                footerLabel.textAlignment = .center
                footerLabel.numberOfLines = 0
                footerLabel.textColor = .secondaryLabel
                footerLabel.font = UIFont.systemFont(ofSize: 12)
                
                let footerView = UIView()
                footerView.addSubview(footerLabel)
                footerLabel.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    footerLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
                    footerLabel.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
                    footerLabel.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 8),
                    footerLabel.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -8),
                ])
                
                footerView.frame.size = CGSize(width: tableView.frame.width, height: 60)
                tableView.tableFooterView = footerView
            }
            
        default:
            // Mostrar periodo y duración para otros tipos
            periodRow?.hidden = false
            durationRow?.hidden = false
            tableView.tableFooterView?.isHidden = true
//            if (form.rowBy(tag: "BillingCycle") as? PickerInputRow<String>)?.value == SubscriptionPeriod.custom.name {
//                customDaysRow?.hidden = false
//            }
        }
        
        // Evaluar condiciones de visibilidad
        periodRow?.evaluateHidden()
        durationRow?.evaluateHidden()
//        customDaysRow?.evaluateHidden()
    }
    
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text ?? ""
        saveButton.isEnabled = !text.isEmpty // Habilitar botón si el texto no está vacío
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    
    @objc private func saveSubscription() {
        // Validar que todos los datos requeridos estén presentes
        guard let subscription = createSubscription() else {
            showAlert(title: "Error", message: "Please complete all required fields.")
            return
        }
        
        // Guardar la suscripción
        let manager = SubscriptionManager()
        manager.save(subscription)
        NotificationManager.shared.scheduleNotifications(for: subscription)
        NotificationCenter.default.post(name: Notification.Name("SaveNewSubObserver"), object: nil)
        
        // Mostrar mensaje de éxito
        let icon = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        let toast = Toast.default(
            image: icon!,
            title: "Subscription saved",
            subtitle: nil
        )
        toast.show(haptic: .success)
        
        navigationController?.popViewController(animated: true)
    }

    
    
    private func createSubscription() -> Subscription? {
        // Validar nombre de la empresa
        guard let name = companyName, !name.isEmpty else {
            showAlert(title: "Error", message: "Please enter a company name.")
            return nil
        }
        
        // Validar imagen de la empresa
        guard let logoUrl = imgURL, !logoUrl.isEmpty else {
            showAlert(title: "Error", message: "Please select an icon for the subscription.")
            return nil
        }
        
        // Validar campos del formulario
        guard let amount = (form.rowBy(tag: "SubscriptionCost") as? IntRow)?.value,
              let nextPaymentDate = (form.rowBy(tag: "DateRow") as? DateRow)?.value,
              let reminderName = (form.rowBy(tag: "PickerInputRow") as? PickerInputRow<String>)?.value,
              let reminder = ReminderOption.allCases.first(where: { $0.name == reminderName }),
              let categoryName = (form.rowBy(tag: "PlanDetail") as? PickerInputRow<String>)?.value,
              let category = SubscriptionCategory.allCases.first(where: { $0.displayName() == categoryName }),
              let subscriptionTypeName = (form.rowBy(tag: "SubscriptionType") as? SegmentedRow<String>)?.value,
              let subscriptionType = SubscriptionType.allCases.first(where: { $0.displayName() == subscriptionTypeName })
        else {
            showAlert(title: "Error", message: "Please complete all required fields.")
            return nil
        }
        
        // Determinar el periodo de la suscripción (opcional para ciertos tipos)
        let period: SubscriptionPeriod? = subscriptionType != .trial && subscriptionType != .lifeTime
            ? SubscriptionPeriod.allCases.first(where: { $0.name == (form.rowBy(tag: "BillingCycle") as? PickerInputRow<String>)?.value })
            : nil

        // Crear la suscripción
        return Subscription(
            id: UUID(),
            name: name,
            amount: Double(amount),
            logoUrl: logoUrl,
            nextPaymentDate: nextPaymentDate,
            period: period ?? .monthly,
            reminderTime: reminder,
            category: category,
            subscriptionType: subscriptionType
        )
    }


}

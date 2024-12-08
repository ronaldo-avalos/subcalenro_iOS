//
//  FormNewSubController.swift
//  subcalenro
//
//  Created by Ronaldo Avalos on 02/12/24.
//

import Foundation
import Eureka


class FormNewSubController: FormViewController {
    
    var imgURL: String?
    var companyName: String?
    private var saveButton: UIBarButtonItem!
    
    
    init(imgURL: String, companyName: String) {
        self.imgURL = imgURL
        self.companyName = companyName
        super.init(style: .insetGrouped) // Configurar el estilo aquí
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Asegúrate de que el índice 0 corresponde a la celda de la imagen
        if indexPath.section == 0 && indexPath.row == 0 {
            return 136 // Altura para la celda de la imagen
        } else if indexPath.section == 7 && indexPath.row == 7 {
            
        }
        return 54 // Altura para las demás celdas
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeManager.color(for: .editBackgroud)
        self.navigationController?.navigationBar.tintColor = .label
        
        //        view.addSubview(saveButton)
        saveButton = UIBarButtonItem(systemItem: .save)
        saveButton.isEnabled = false
        saveButton.target = self
        saveButton.action = #selector(saveSubscription)
        navigationItem.rightBarButtonItem = saveButton
        
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        
        
        form +++
        Section()
        <<< CompanyRow() { row in
            row.cell.imageV.image = UIImage(named: imgURL ?? "") // Cargar la imagen
            row.title = ""
            row.cell.backgroundColor = .clear
        }.onCellSelection { [weak self] _, _ in
            guard let self = self else { return }
            let detailVC = IconSelectionViewController()
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        
        <<< CenteredTextFieldRow() { row in
            row.cell.textField.placeholder = "Name"
            row.cell.textField.text = companyName
            row.cell.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            row.cell.backgroundColor = .clear
            row.tag = "Name" // Asignar un tag único
        }

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
            cell.imageView?.image = UIImage(systemName: "dollarsign.circle")?.withTintColor(.label, renderingMode: .alwaysOriginal)
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
            cell.imageView?.image = UIImage(systemName: "arrow.clockwise")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        }.onChange { [weak self] row in
            guard let self = self else { return }
            if let customDaysRow = self.form.rowBy(tag: "CustomDays") {
                customDaysRow.hidden = Condition(booleanLiteral: row.value != "Custom")
                customDaysRow.evaluateHidden()
            }
        }

        <<< IntRow() {
            $0.hidden = Condition(booleanLiteral: true) // Inicialmente oculta
            $0.title = "Custom period (days)"
            $0.placeholder = "days"
            $0.value = nil
            $0.tag = "CustomDays"
        }.cellSetup { cell, _ in
            cell.imageView?.image = UIImage(systemName: "calendar.badge.plus")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        }

        
        
        <<< DateRow() {
            $0.title = "Next billing date"
            $0.value = Date() // Fecha inicial
            $0.minimumDate = Calendar.current.date(byAdding: .year, value: -2, to: Date())
            $0.maximumDate = Calendar.current.date(byAdding: .year, value: 20, to: Date())
            $0.tag = "DateRow"
        }.cellSetup { cell, _ in
            cell.imageView?.image = UIImage(systemName: "calendar")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        }

        
        +++ Section()
        
        <<< PickerInputRow<String>() {
            $0.title = "Reminder"
            $0.tag = "PickerInputRow"
            $0.options = ReminderOption.allCases.map { $0.name}
            $0.value = $0.options[1]
        }.cellSetup { cell, _ in
            cell.imageView?.image = UIImage(systemName: "bell")?.withTintColor(.label, renderingMode: .alwaysOriginal)
            
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
            cell.imageView?.image = UIImage(systemName: "calendar.badge.clock")?.withTintColor(.label, renderingMode: .alwaysOriginal)
            
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
            cell.imageView?.image = UIImage(systemName: "square.3.layers.3d.down.backward")?.withTintColor(.label, renderingMode: .alwaysOriginal)
            
        }
        
    }
    
    // Función para actualizar el formulario según el tipo de suscripción seleccionado
    private func updateFormBasedOnSubscriptionType(_ type: String?) {
        let periodRow: BaseRow? = form.rowBy(tag: "BillingCycle")
        let durationRow: BaseRow? = form.rowBy(tag: "SubDuration")
        let customDaysRow: BaseRow? = form.rowBy(tag: "CustomDays")
       
        if type == "Lifetime" {
            durationRow?.hidden = true
        } else if type == "Trial" {
            periodRow?.hidden = true
            durationRow?.hidden = true
            customDaysRow?.hidden = true
            
            // Agregar footerView
            if let footer = tableView.tableFooterView {
                footer.isHidden = false
            } else {
                let footerLabel = UILabel()
                footerLabel.text = "We will let you know before the trial period of this subscription ends."
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
        } else {
            periodRow?.hidden = false
            durationRow?.hidden = false
            tableView.tableFooterView?.isHidden = true
        }
        
        periodRow?.evaluateHidden()
        durationRow?.evaluateHidden()
    }

    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text ?? ""
        saveButton.isEnabled = !text.isEmpty // Habilitar el botón si el campo no está vacío
    }
    
    @objc private func saveSubscription() {
          guard let subscription = createSubscription() else {
              showAlert(title: "Error", message: "Please complete all fields.")
              return
          }
          
        print("Subscription saved: \(subscription)")
      }

    private func createSubscription() -> Subscription? {
        
        //Validamos que el nombre no este vacio
        guard let name = (form.rowBy(tag: "Name") as? CenteredTextFieldRow)?.cell.textField.text, !name.isEmpty,
              let amount = (form.rowBy(tag: "SubscriptionCost") as? IntRow)?.value,
              let periodName = (form.rowBy(tag: "BillingCycle") as? PickerInputRow<String>)?.value,
              let period = SubscriptionPeriod.allCases.first(where: { $0.name == periodName }),
              let nextPaymentDate = (form.rowBy(tag: "DateRow") as? DateRow)?.value,
              let reminderName = (form.rowBy(tag: "PickerInputRow") as? PickerInputRow<String>)?.value,
              let reminder = ReminderOption.allCases.first(where: { $0.name == reminderName }),
              let categoryName = (form.rowBy(tag: "PlanDetail") as? PickerInputRow<String>)?.value,
              let category = SubscriptionCategory.allCases.first(where: { $0.displayName() == categoryName })
//             let subscriptionTypeName = (form.rowBy(tag: "subscriptionType") as? SegmentedRow<String>)?.value,
//              let subscriptionType = SubscriptionType.allCases.first(where: { $0.displayName() == subscriptionTypeName })
                
        else {
            return nil
        }
        
        return Subscription(
            id: UUID(),
            name: name,
            amount: Double(amount),
            logoUrl: imgURL ?? "",
            nextPaymentDate: nextPaymentDate,
            period: period,
            reminderTime: reminder,
            category: category,
            subscriptionType: .trial
        )
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}


final class CompanyRow: Row<CompanyRowCell>, RowType {
    required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<CompanyRowCell>()
    }
}



class CompanyRowCell: Cell<String>, CellType {
    
    let imageContainer = UIView()
    let imageV = UIImageView()
    
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        // Configurar imagen
        imageContainer.backgroundColor = .white
        imageContainer.layer.cornerRadius = 20  // Radio del borde del contenedor
        imageContainer.layer.cornerCurve = .continuous
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageContainer)
        
        imageV.contentMode = .scaleAspectFit
        imageV.layer.cornerRadius = 12
        imageV.layer.masksToBounds = true  
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.addSubview(imageV)
  
        NSLayoutConstraint.activate([
            imageContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageContainer.widthAnchor.constraint(equalToConstant: 120),  // Ancho del contenedor
            imageContainer.heightAnchor.constraint(equalToConstant: 120),  // Altura del contenedor
            
            imageV.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
            imageV.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor),
            imageV.widthAnchor.constraint(equalTo: imageContainer.widthAnchor, multiplier: 0.8),
            imageV.heightAnchor.constraint(equalTo: imageContainer.heightAnchor, multiplier: 0.8),
        ])
    }
}


final class CenteredTextFieldRow: Row<CenteredTextFieldCell>, RowType {
    required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<CenteredTextFieldCell>()
    }
}

class CenteredTextFieldCell: Cell<String>, CellType {
    let textField = UITextField()
    
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        // Configurar el textField
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 32)
        textField.textAlignment = .center
        textField.placeholder = "Enter text"
        contentView.addSubview(textField)
        
        // Configurar las restricciones
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textField.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}

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
    
    init(imgURL: String, companyName: String) {
        self.imgURL = imgURL
        self.companyName = companyName
        super.init(style: .insetGrouped) // Configurar el estilo aquí
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.layer.cornerRadius = 12
        button.tintColor = ThemeManager.color(for: .secondaryText)
        button.clipsToBounds = true
        button.backgroundColor = ThemeManager.color(for: .secondaryBackground)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Asegúrate de que el índice 0 corresponde a la celda de la imagen
        if indexPath.section == 0 && indexPath.row == 0 {
            return 136 // Altura para la celda de la imagen
        }
        return 54 // Altura para las demás celdas
    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeManager.color(for: .editBackgroud)
        self.navigationController?.navigationBar.tintColor = .label
        
        //        view.addSubview(saveButton)
        
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        form +++
        Section()
        <<< CompanyRow() { row in
            row.cell.imageV.image = UIImage(named: imgURL ?? "") // Cargar la imagen
            row.title = ""
            row.cell.backgroundColor = .clear
        }
        
        form +++
        Section()
        <<< SegmentedRow<String>() {
            $0.options = ["Trial", "Recurring", "Lifetime"]
            $0.cell.backgroundColor = .clear
            $0.value = $0.options?[1]
        }
        
        +++ Section()
        <<< IntRow() {
            $0.title = "Subscription cost"
            $0.placeholder = "$129.00"
            $0.useFormatterDuringInput = false
            $0.useFormatterOnDidBeginEditing = true
        }.cellSetup { cell, _ in
            cell.textField.keyboardType = .decimalPad
            cell.imageView?.image = UIImage(systemName: "dollarsign.circle")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        }
        
        <<< PickerInputRow<String>("Billing cycle") {
            $0.title = "Period"
            $0.options = ["Weekly","Monthly","6 months","Yearly"]
            $0.value = $0.options[1]
        }.cellSetup { cell, _ in
            cell.imageView?.image = UIImage(systemName: "arrow.clockwise")?.withTintColor(.label, renderingMode: .alwaysOriginal)
            
        }
        
        <<< PickerInputRow<String>("Picker Input Row") {
            $0.title = "Reminder"
            $0.options = ["Never", "Same day"]
            for i in 1...7{
                $0.options.append("\(i) day(s) before")
            }
            $0.value = $0.options[2]
        }.cellSetup { cell, _ in
            cell.imageView?.image = UIImage(systemName: "bell")?.withTintColor(.label, renderingMode: .alwaysOriginal)
            
        }
        
        <<< DateRow("dateRow") {
            $0.title = "Next billing date"
            $0.value = Date() // Fecha inicial
            $0.minimumDate = Date().addingTimeInterval(-31556926) // Máximo hace 1 año
            $0.maximumDate = Date().addingTimeInterval(31556926) // Máximo en 1 año
        }.cellSetup { cell, _ in
            cell.imageView?.image = UIImage(systemName: "calendar")?.withTintColor(.label, renderingMode: .alwaysOriginal)
            
        }
        +++ Section("")
        <<< PickerInputRow<String>("Billing cycle") {
            $0.title = "Period"
            $0.options = ["Weekly","Monthly","6 months","Yearly"]
            $0.value = $0.options[1]
        }.cellSetup { cell, _ in
            cell.imageView?.image = UIImage(systemName: "arrow.clockwise")?.withTintColor(.label, renderingMode: .alwaysOriginal)
            
        }
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
        imageV.layer.masksToBounds = true  // Para que los bordes redondeados se apliquen correctamente
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.addSubview(imageV)
        
        //        // Configurar etiqueta
        //        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        //        nameLabel.backgroundColor = .clear
        //        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        //        contentView.addSubview(nameLabel)
        
        // Añadir restricciones
        NSLayoutConstraint.activate([
            imageContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageContainer.widthAnchor.constraint(equalToConstant: 120),  // Ancho del contenedor
            imageContainer.heightAnchor.constraint(equalToConstant: 120),  // Altura del contenedor
            
            imageV.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
            imageV.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor),
            imageV.widthAnchor.constraint(equalTo: imageContainer.widthAnchor, multiplier: 0.8),
            imageV.heightAnchor.constraint(equalTo: imageContainer.heightAnchor, multiplier: 0.8),
            
            
            //            nameLabel.topAnchor.constraint(equalTo: imageV.bottomAnchor, constant: 8),
            //            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            //            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: 8)
        ])
    }
}

//
//  FormNewSubController.swift
//  subcalenro
//
//  Created by Ronaldo Avalos on 02/12/24.
//

import Foundation
import Eureka
import ToastViewSwift
import Kingfisher

class FormNewSubController: FormViewController {

  var company: Company?
  var companyName: String = ""
  var companyIcon: String =  "icon2"
  var subEdit : Subscription?
  private var saveButton: UIBarButtonItem!


  init(company: Company?, sub: Subscription?) {
    self.company = company
    self.companyName = company?.name ?? ""
    self.subEdit = sub
    super.init(style: .insetGrouped)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }


  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 54
  }


  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = subEdit == nil ? "New Subscription" : "Edit Subscription"

    view.backgroundColor = ThemeManager.color(for: .editBackgroud)
    saveButton = UIBarButtonItem(title: "Save")
    saveButton.isEnabled = false
    saveButton.target = self
    saveButton.action = #selector(saveSubscription)
    navigationItem.rightBarButtonItem = saveButton

    let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelEdit))
    navigationItem.leftBarButtonItem = subEdit != nil ? cancelButton : nil

//    tableView.backgroundColor = .clear
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.separatorStyle = .none

    setupTableHeaderView()
    setupForm()
  }



  private func setupForm() {
    form +++
    Section()

    <<< SegmentedRow<String>() { row in
      row.options = ["Trial", "Recurring", "Lifetime"]
      row.value = "Recurring"
      row.tag = "SubscriptionType"
    }.onChange { [weak self] row in
      self?.updateFormBasedOnSubscriptionType(row.value)
    }

    <<< DecimalRow() {
      $0.title = "SubscriptionCost"
      $0.placeholder = "$129.00"
      $0.useFormatterDuringInput = false
      $0.useFormatterOnDidBeginEditing = true
      $0.tag = "SubscriptionCost"
    }.cellSetup { cell, _ in
      cell.textField.keyboardType = .decimalPad
      cell.imageView?.image = UIImage(systemName: "dollarsign.circle")
    }.onChange { [weak self] row in
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

    }

    <<< DateRow() {
      $0.title = "Next billing date"
      $0.value = Date()
      $0.minimumDate = Date()
      $0.maximumDate = Calendar.current.date(byAdding: .year, value: 20, to: Date())
      $0.tag = "DateRow"
    }.cellSetup { cell, _ in
      cell.imageView?.image = UIImage(systemName: "calendar")
    }.onChange { row in
      if let selectedDate = row.value, selectedDate < Date() {
        row.value = Date()
        row.updateCell()
      }
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
      $0.firstOptions = {return ["Forever"] + (1...180).map { "\($0)" }}
      $0.secondOptions = { _ in
        return ["", "Day(s)", "Week(s)", "Month(s)", "Year(s)"]
      }
      $0.value = Tuple(a: "2", b: "Years(s)")
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

    if let subscription = subEdit {
      companyName = subscription.name
      form.rowBy(tag: "SubscriptionCost")?.baseValue = subscription.amount
      form.rowBy(tag: "DateRow")?.baseValue = subscription.nextPaymentDate
      form.rowBy(tag: "PickerInputRow")?.baseValue = subscription.reminderTime.name
      form.rowBy(tag: "PlanDetail")?.baseValue = subscription.category.displayName()
      form.rowBy(tag: "SubscriptionType")?.baseValue = subscription.subscriptionType.displayName()
      form.rowBy(tag: "BillingCycle")?.baseValue = subscription.period.name
    }
  }

  private func setupTableHeaderView() {
    let headerView = UIView()
    headerView.backgroundColor = .clear

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
    if let imageUrl = company?.imageUrl {
      imageView.kf.setImage(with: URL(string: imageUrl))
    } else {
      imageView.image = UIImage(named:companyIcon)
    }
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageContainer.addSubview(imageView)

    // Botón de editar
    let editImageButton = UIButton(type: .system)
    editImageButton.setTitle("Edit", for: .normal)
    editImageButton.tintColor = .systemBlue
    editImageButton.translatesAutoresizingMaskIntoConstraints = false
    editImageButton.addTarget(self, action: #selector(editImageTapped), for: .touchUpInside)
    headerView.addSubview(editImageButton)

    let companyNameTextField = UITextField()
    companyNameTextField.placeholder = "Enter subcription name"
    companyNameTextField.font = UIFont.systemFont(ofSize: 26, weight: .bold)
    companyNameTextField.textAlignment = .center
    companyNameTextField.borderStyle = .none
    companyNameTextField.text = company?.name ?? companyName// Texto inicial
    companyNameTextField.addTarget(self, action: #selector(companyNameChanged(_:)), for: .editingChanged)
    companyNameTextField.translatesAutoresizingMaskIntoConstraints = false
    headerView.addSubview(companyNameTextField)

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

    let headerHeight: CGFloat = 224
    headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: headerHeight)

    if let subscription = subEdit {
      if subscription.logoUrl.isEmpty {
        imageView.image = UIImage(named: subscription.iconName)
      } else {
        imageView.kf.setImage(with: URL(string: subscription.logoUrl))
      }
      companyNameTextField.text = subscription.name
    }

    tableView.tableHeaderView = headerView
  }

  @objc private func editImageTapped() {
    let iconSelector = IconSelectionViewController()
    iconSelector.onIconSelected = { [weak self] selectedIcon in
      guard let self = self else { return }
      if let headerView = self.tableView.tableHeaderView,
         let imageView = headerView.subviews.compactMap({$0}).first?.subviews.compactMap({ $0 as? UIImageView }).first {
        imageView.image = UIImage(named: selectedIcon)
        companyIcon = selectedIcon
      }
    }

    let navController = UINavigationController(rootViewController: iconSelector)
    self.present(navController, animated: true)
  }

  @objc private func companyNameChanged(_ textField: UITextField) {
    companyName = textField.text ?? ""
  }

  private func updateFormBasedOnSubscriptionType(_ type: String?) {
    let periodRow: BaseRow? = form.rowBy(tag: "BillingCycle")
    let durationRow: BaseRow? = form.rowBy(tag: "SubDuration")

    switch type {
    case "Lifetime":
      durationRow?.hidden = true

    case "Trial":
      periodRow?.hidden = true
      durationRow?.hidden = true

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
      periodRow?.hidden = false
      durationRow?.hidden = false
      tableView.tableFooterView?.isHidden = true
    }
    periodRow?.evaluateHidden()
    durationRow?.evaluateHidden()
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
    guard let subscription = createSubscription() else {
      showAlert(title: "Error", message: "Please complete all required fields.")
      return
    }

    if var existingSub = subEdit {
      existingSub.name = subscription.name
      existingSub.amount = subscription.amount
      existingSub.nextPaymentDate = subscription.nextPaymentDate
      existingSub.reminderTime = subscription.reminderTime
      existingSub.category = subscription.category
      existingSub.subscriptionType = subscription.subscriptionType
      existingSub.period = subscription.period

      SubscriptionManager().update(existingSub)
      NotificationManager.shared.scheduleNotifications(for: existingSub)
      NotificationCenter.default.post(name: Notification.Name("updateSub"), object: nil)
      NotificationCenter.default.post(name: Notification.Name("updateSub2"), object: nil)

    } else {
      SubscriptionManager().save(subscription)
      NotificationManager.shared.scheduleNotifications(for: subscription)
    }

    NotificationCenter.default.post(name: Notification.Name("SaveNewSubObserver"), object: nil)

  

    self.dismiss(animated: true)
  }




  private func createSubscription() -> Subscription? {
    if companyName.isEmpty {
      showAlert(title: "Error", message: "Please enter a company name.")
      return nil
    }

    guard let amount = (form.rowBy(tag: "SubscriptionCost") as? DecimalRow)?.value,
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

    let period: SubscriptionPeriod? = subscriptionType != .trial && subscriptionType != .lifeTime
    ? SubscriptionPeriod.allCases.first(where: { $0.name == (form.rowBy(tag: "BillingCycle") as? PickerInputRow<String>)?.value })
    : nil

    return Subscription(
      id: UUID(),
      name: companyName,
      amount: Double(amount),
      logoUrl: company?.imageUrl ?? "",
      iconName: companyIcon,
      nextPaymentDate: nextPaymentDate,
      period: period ?? .monthly,
      reminderTime: reminder,
      category: category,
      subscriptionType: subscriptionType
    )
  }

  @objc func cancelEdit() {
      let alertController = UIAlertController(
          title: "Cancel Editing?",
          message: "If you cancel, your changes will not be saved. Are you sure you want to continue?",
          preferredStyle: .alert
      )

      let cancelAction = UIAlertAction(title: "Cancel Editing", style: .destructive) { _ in
          self.dismiss(animated: true) // Close the current view
      }

      let continueAction = UIAlertAction(title: "Keep Editing", style: .default)

      alertController.addAction(cancelAction)
      alertController.addAction(continueAction)

      present(alertController, animated: true)
  }

}

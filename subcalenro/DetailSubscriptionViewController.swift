//
//  SubPreviewViewController.swift
//  subcalenro
//
//  Created by ronaldo avalos on 12/10/24.
//
import UIKit
import ToastViewSwift

class DetailSubscriptionViewController: UIViewController {

    var subId: UUID?
    var imgURL: String?
    var companyName: String?
    var subEdit: Subscription?

    private var nameLabel: UILabel!
    private var priceLabel: UILabel!
    private var imageView: UIImageView!
    private var subscriptionStatusSwitch: UISwitch!
    private var subscriptionStatusLabel: UILabel!
    private var statusIndicatorView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeManager.color(for: .primaryBackground)
        self.navigationItem.title = "Preview"
        setupView()

        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditMode))
        navigationItem.rightBarButtonItem = editButton
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleUpdateSub),
            name: Notification.Name("updateSub"),
            object: nil
        )
    }
  private func setupView() {
      let imageContainer = UIView()
      imageContainer.backgroundColor = .white
      imageContainer.layer.cornerRadius = 20
      imageContainer.layer.cornerCurve = .continuous
      imageContainer.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(imageContainer)

      imageView = UIImageView()
      imageView.contentMode = .scaleAspectFit
      imageView.layer.cornerRadius = 12
      imageView.layer.masksToBounds = true
      imageView.translatesAutoresizingMaskIntoConstraints = false
      imageContainer.addSubview(imageView)

      nameLabel = UILabel()
      nameLabel.font = UIFont.boldSystemFont(ofSize: 32)
      nameLabel.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(nameLabel)

      priceLabel = UILabel()
      priceLabel.font = UIFont.systemFont(ofSize: 24)
      priceLabel.textColor = .systemBlue
      priceLabel.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(priceLabel)

      // Vista contenedora para el estado de suscripción
      let subscriptionStatusView = UIView()
      subscriptionStatusView.backgroundColor = .secondarySystemBackground
      subscriptionStatusView.layer.cornerRadius = 12
      subscriptionStatusView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(subscriptionStatusView)

      // Indicador de estado (círculo)
      statusIndicatorView = UIView()
      statusIndicatorView.layer.cornerRadius = 8 // Radio para hacerla circular
      statusIndicatorView.translatesAutoresizingMaskIntoConstraints = false
      subscriptionStatusView.addSubview(statusIndicatorView)

      // Etiqueta de estado
      subscriptionStatusLabel = UILabel()
      subscriptionStatusLabel.font = UIFont.systemFont(ofSize: 18)
      subscriptionStatusLabel.translatesAutoresizingMaskIntoConstraints = false
      subscriptionStatusView.addSubview(subscriptionStatusLabel)

      // Switch para cambiar estado
      subscriptionStatusSwitch = UISwitch()
      subscriptionStatusSwitch.addTarget(self, action: #selector(toggleSubscriptionStatus(_:)), for: .valueChanged)
      subscriptionStatusSwitch.translatesAutoresizingMaskIntoConstraints = false
      subscriptionStatusView.addSubview(subscriptionStatusSwitch)

      loadSubscriptionData()

      NSLayoutConstraint.activate([
          imageContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
          imageContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
          imageContainer.widthAnchor.constraint(equalToConstant: 120),
          imageContainer.heightAnchor.constraint(equalToConstant: 120),

          imageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
          imageView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor),
          imageView.widthAnchor.constraint(equalTo: imageContainer.widthAnchor, multiplier: 0.8),
          imageView.heightAnchor.constraint(equalTo: imageContainer.heightAnchor, multiplier: 0.8),

          nameLabel.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 14),
          nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

          priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
          priceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

          subscriptionStatusView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 24),
          subscriptionStatusView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26),
          subscriptionStatusView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26),
          subscriptionStatusView.heightAnchor.constraint(equalToConstant: 60),

          statusIndicatorView.centerYAnchor.constraint(equalTo: subscriptionStatusView.centerYAnchor),
          statusIndicatorView.leadingAnchor.constraint(equalTo: subscriptionStatusView.leadingAnchor, constant: 16),
          statusIndicatorView.widthAnchor.constraint(equalToConstant: 16),
          statusIndicatorView.heightAnchor.constraint(equalToConstant: 16),

          subscriptionStatusLabel.centerYAnchor.constraint(equalTo: subscriptionStatusView.centerYAnchor),
          subscriptionStatusLabel.leadingAnchor.constraint(equalTo: statusIndicatorView.trailingAnchor, constant: 8),

          subscriptionStatusSwitch.centerYAnchor.constraint(equalTo: subscriptionStatusView.centerYAnchor),
          subscriptionStatusSwitch.trailingAnchor.constraint(equalTo: subscriptionStatusView.trailingAnchor, constant: -16)
      ])
  }
  private func loadSubscriptionData() {
      guard let id = subId,
            let sub = SubscriptionManager().readById(id) else { return }

      subEdit = sub
      nameLabel.text = sub.name
      priceLabel.text = "$\(String(format: "%.2f", sub.amount))"
      subscriptionStatusSwitch.isOn = sub.isActive
      subscriptionStatusLabel.text = sub.isActive ? "Subscription is Active" : "Subscription is Inactive"
      statusIndicatorView.backgroundColor = sub.isActive ? .systemGreen : .systemOrange

      if sub.logoUrl.isEmpty {
          imageView.image = UIImage(named: sub.iconName)
      } else {
          imageView.kf.setImage(with: URL(string: sub.logoUrl))
      }
  }
  @objc func toggleSubscriptionStatus(_ sender: UISwitch) {
      subscriptionStatusLabel.text = sender.isOn ? "Subscription is Active" : "Subscription is Inactive"
      statusIndicatorView.backgroundColor = sender.isOn ? .systemGreen : .systemOrange

      guard var updatedSub = subEdit else { return }
      updatedSub.isActive = sender.isOn
      subEdit = updatedSub
      SubscriptionManager().update(updatedSub)

      if !sender.isOn {
          NotificationManager.shared.cancelNotifications(for: updatedSub)
      } else {
        NotificationManager.shared.scheduleNotifications(for: updatedSub)
      }

      NotificationCenter.default.post(name: Notification.Name("changeActive"), object: nil)
  }

    @objc func handleUpdateSub() {
//        let icon = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.label, renderingMode: .alwaysOriginal)
//        let toast = Toast.default(
//            image: icon!,
//            title: "Subscription updated",
//            subtitle: nil
//        )
//        toast.show(haptic: .success)
        loadSubscriptionData()
    }

    @objc func toggleEditMode() {
        let vc = FormNewSubController(company: nil, sub: subEdit)
        let nv = UINavigationController(rootViewController: vc)
        nv.modalPresentationStyle = .fullScreen
        self.present(nv, animated: true)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func closeModal() {
        self.dismiss(animated: true)
    }
}

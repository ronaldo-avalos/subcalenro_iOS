//
//  PayWallViewController.swift
//  subcalenro
//
//  Created by Ronaldo Avalos on 09/12/24.
//

import Foundation
import UIKit

class PayWallViewController: UIViewController, UIScrollViewDelegate {

  private let headerImageView = UIImageView()
  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
  private let subscibeButton = UIButton(type: .system)
  private let headerHeight: CGFloat = 220.0

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  private func setupUI() {
    view.backgroundColor = ThemeManager.color(for: .primaryBackground)


    // Header Image View
    headerImageView.image = UIImage(named: "paywall_img_bg")
    headerImageView.contentMode = .scaleAspectFit
    headerImageView.clipsToBounds = true
    view.addSubview(headerImageView)
    headerImageView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      headerImageView.topAnchor.constraint(equalTo: view.topAnchor),
      headerImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      headerImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      headerImageView.heightAnchor.constraint(equalToConstant: headerHeight)
    ])

    // Gradient Overlay
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [
      UIColor.clear.cgColor,
      ThemeManager.color(for: .primaryBackground).withAlphaComponent(0.5).cgColor
    ]
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
    gradientLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: headerHeight)
    headerImageView.layer.addSublayer(gradientLayer)

    // Title Label
    titleLabel.text = "Try our premium features \nfor free"
    titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
    titleLabel.textColor = ThemeManager.color(for: .primaryText)
    titleLabel.numberOfLines = 2
    titleLabel.textAlignment = .center
    view.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false

    let appIcon = UIImageView()
    appIcon.image = .appicon // Asegúrate de usar el nombre correcto del asset
    appIcon.contentMode = .scaleAspectFit
    appIcon.layer.cornerRadius = 40
    appIcon.backgroundColor = ThemeManager.color(for: .primaryBackground)
    appIcon.clipsToBounds = true
    appIcon.layer.shadowColor = ThemeManager.color(for: .secondaryBackground).cgColor
    appIcon.layer.shadowOpacity = 0.15
    appIcon.layer.shadowOffset = CGSize(width: 0, height: 0)
    appIcon.layer.shadowRadius = 2
    appIcon.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(appIcon)

    NSLayoutConstraint.activate([
      appIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      appIcon.bottomAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 40),
      appIcon.widthAnchor.constraint(equalToConstant: 80),
      appIcon.heightAnchor.constraint(equalToConstant: 80),

      titleLabel.topAnchor.constraint(equalTo: appIcon.bottomAnchor, constant: 8),
      titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
    ])

    // Subtitle Label
    subtitleLabel.text = "Join thousands of happy Pro users"
    subtitleLabel.font = UIFont.systemFont(ofSize: 16)
    subtitleLabel.textColor = .gray
    subtitleLabel.textAlignment = .center
    view.addSubview(subtitleLabel)
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
      subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    ])



    // Beneficios
//    let benefits = [
//      "Unlimited access to premium features",
//      "Priority support",
//      "Ad-free experience",
//      "Exclusive content updates",
//      "Unlimited access to premium features"
//    ]
//
//    var lastBenefitLabel: UILabel? = nil
//
//    for benefit in benefits {
//      let label = UILabel()
//      label.text = benefit
//      label.font = UIFont.systemFont(ofSize: 16)
//      label.textColor = ThemeManager.color(for: .primaryText)
//      label.numberOfLines = 0
//      view.addSubview(label)
//      label.translatesAutoresizingMaskIntoConstraints = false
//
//      NSLayoutConstraint.activate([
//        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
//      ])
//
//      if let last = lastBenefitLabel {
//        label.topAnchor.constraint(equalTo: last.bottomAnchor, constant: 12).isActive = true
//      } else {
//        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
//      }
//
//      lastBenefitLabel = label
//    }

    // Botones de suscripción
    let monthlyButton = createSubscriptionButton(title: "Subscribe")

    view.addSubview(monthlyButton)

    monthlyButton.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      //              monthlyButton.topAnchor.constraint(equalTo: lastBenefitLabel!.bottomAnchor, constant: 20),
      monthlyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      monthlyButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
      monthlyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -94)
    ])
  }

  private func createSubscriptionButton(title: String) -> UIButton {
    let button = UIButton(type: .system)
    button.setTitle(title, for: .normal)
    button.titleLabel?.font = FontManager.sfCompactDisplay(size: 18, weight: .semibold)
    button.backgroundColor = ThemeManager.color(for: .secondaryBackground)
    button.setTitleColor(ThemeManager.color(for: .secondaryText), for: .normal)
    button.layer.cornerRadius = 18
    button.translatesAutoresizingMaskIntoConstraints = false
    button.heightAnchor.constraint(equalToConstant: 64).isActive = true
    return button
  }
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    // Verifica si el cambio de apariencia fue lo que cambió
    if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
      updateGradient()
    }
  }

  private func updateGradient() {
    // Elimina el gradiente existente
    if let sublayers = headerImageView.layer.sublayers {
      for layer in sublayers where layer is CAGradientLayer {
        layer.removeFromSuperlayer()
      }
    }

    // Crea un nuevo gradiente
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [
      UIColor.clear.cgColor,
      ThemeManager.color(for: .primaryBackground).withAlphaComponent(0.5).cgColor
    ]
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
    gradientLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: headerHeight)

    // Añade el gradiente al headerImageView
    headerImageView.layer.addSublayer(gradientLayer)
  }


  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetY = scrollView.contentOffset.y

    if offsetY < 0 {
      headerImageView.frame = CGRect(
        x: 0,
        y: offsetY,
        width: view.bounds.width,
        height: headerHeight - offsetY
      )
    } else {
      headerImageView.frame = CGRect(
        x: 0,
        y: offsetY * 0.5,
        width: view.bounds.width,
        height: headerHeight
      )
    }
  }

}


// MARK: - Fetch Subscription Product
//    func fetchSubscriptionProduct() {
//            IAPManager.shared.startObserving()
//            IAPManager.shared.getProducts { [weak self] (result) in
//                switch result {
//                case .success(let products):
//                    if let subscriptionProduct = products.first(where: { $0.productIdentifier == self?.subscriptionProductID }) {
//                        self?.product = subscriptionProduct
//                        DispatchQueue.main.async {
//                            let priceString = IAPManager.shared.getPriceFormatted(for: subscriptionProduct) ?? "**"
//                            self?.priceLabel.text =  String(format: PRICE_AUTORENEW, priceString)
//
//                            self?.productNameLabel.text = subscriptionProduct.localizedDescription
//                        }
//                    }
//                case .failure(let error):
//                    print("Error al obtener productos: \(error.localizedDescription)")
//                }
//            }
//    }

// MARK: - Purchase Subscription
//    @objc func subscribeButtonTapped() {
//        subscribeButton.setTitle("", for: .normal)
//        activityIndicator.startAnimating()
//        subscribeButton.isUserInteractionEnabled = false
//        guard let product = product else {
//            print("Producto de suscripción no disponible")
//            return
//        }
//
//        IAPManager.shared.buy(product: product) { result in
//            switch result {
//            case .success:
//                self.restoreButtonState()
//                self.handleSubscriptionSuccess()
//            case .failure(let error):
//                self.restoreButtonState()
//                print("Error al comprar suscripción: \(error.localizedDescription)")
//            }
//        }
//    }

//    func restoreButtonState() {
//        self.activityIndicator.stopAnimating()
//        self.subscribeButton.setTitle(SUBSCRIBE_NOW, for: .normal)
//        self.subscribeButton.isUserInteractionEnabled = true
//    }
//
//    // MARK: - Handle Subscription Success
//    func handleSubscriptionSuccess() {
//        PreferencesManager.shared.isSubscribed = true
//        delegate?.isSubscribedSuccess()
//        self.dismiss(animated: true)
//        print("Suscripción comprada exitosamente")
//    }
//
//    // MARK: - Restore Purchases
//    @objc func restoreButtonTapped() {
//        IAPManager.shared.restorePurchases { result in
//            switch result {
//            case .success (let success):
//                if success {
//                    self.handleRestoreSuccess()
//                } else {
//                    DispatchQueue.main.async {
//                        Utility.showSimpleAlert(on: self, title:"", message: NO_IN_APP_PURCHASES_MESSAGE, completion: {
//                        })
//                    }
//                }
//                break
//            case .failure(let error):
//                print("Error al restaurar compras: \(error.localizedDescription)")
//            }
//        }
//    }

// MARK: - Handle Restore Success
//    func handleRestoreSuccess() {
//        PreferencesManager.shared.isSubscribed = true
//        UserDefaults.standard.synchronize()
//        print("Compras restauradas exitosamente")
//    }


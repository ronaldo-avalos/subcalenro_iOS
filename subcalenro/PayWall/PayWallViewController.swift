//
//  PayWallViewController.swift
//  subcalenro
//
//  Created by Ronaldo Avalos on 09/12/24.
//

import Foundation
import UIKit

class PaywallViewController: UIViewController {

  private let headerImageView = UIImageView()
  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
  private let subscibeButton = UIButton(type: .system)
  private let headerHeight: CGFloat = 160.0

  override func viewDidLoad() {
    super.viewDidLoad()
//    setupUI()
  }

//  private func setupUI() {
//    view.backgroundColor = ThemeManager.color(for: .primaryBackground)
//
//
//    // Header Image View
//    headerImageView.image = UIImage(named: "paywall_img_bg")
//    headerImageView.contentMode = .scaleAspectFill
//    headerImageView.clipsToBounds = true
//    view.addSubview(headerImageView)
//    headerImageView.translatesAutoresizingMaskIntoConstraints = false
//
//    NSLayoutConstraint.activate([
//      headerImageView.topAnchor.constraint(equalTo: view.topAnchor),
//      headerImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//      headerImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//      headerImageView.heightAnchor.constraint(equalToConstant: headerHeight)
//    ])
//
//    // Gradient Overlay
//    let gradientLayer = CAGradientLayer()
//
//    // Ajusta los colores para un gradiente más marcado
//    gradientLayer.colors = [
//        ThemeManager.color(for: .primaryBackground).withAlphaComponent(1.0).cgColor, // Más opaco
//        ThemeManager.color(for: .primaryBackground).withAlphaComponent(0.8).cgColor // Menos opaco
//    ]
//
//    // Configura los puntos para intensificar el efecto
//    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.2) // Empieza el gradiente un poco más abajo
//    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)  // Fin del gradiente sigue abajo
//
//    // Ajusta el marco según la vista donde aplicarás el gradiente
//    gradientLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
//
//    // Aplica la capa gradiente a tu vista
//    view.layer.insertSublayer(gradientLayer, at: 0)
//
//    headerImageView.layer.addSublayer(gradientLayer)
//
//    // Title Label
//    titleLabel.text = "Try our premium features \nfor free"
//    titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
//    titleLabel.textColor = ThemeManager.color(for: .primaryText)
//    titleLabel.numberOfLines = 2
//    titleLabel.textAlignment = .center
//    view.addSubview(titleLabel)
//    titleLabel.translatesAutoresizingMaskIntoConstraints = false
//
////    let appIcon = UIImageView()
////    appIcon.image = .appicon // Asegúrate de usar el nombre correcto del asset
////    appIcon.contentMode = .scaleAspectFit
////    appIcon.layer.cornerRadius = 40
////    appIcon.backgroundColor = ThemeManager.color(for: .primaryBackground)
////    appIcon.clipsToBounds = true
////    appIcon.layer.shadowColor = ThemeManager.color(for: .secondaryBackground).cgColor
////    appIcon.layer.shadowOpacity = 0.15
////    appIcon.layer.shadowOffset = CGSize(width: 0, height: 0)
////    appIcon.layer.shadowRadius = 2
////    appIcon.translatesAutoresizingMaskIntoConstraints = false
////    view.addSubview(appIcon)
//
//    NSLayoutConstraint.activate([
////      appIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
////      appIcon.bottomAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 40),
////      appIcon.widthAnchor.constraint(equalToConstant: 80),
////      appIcon.heightAnchor.constraint(equalToConstant: 80),
//
//      titleLabel.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 8),
//      titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//      titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//      titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
//    ])
//
//    // Subtitle Label
//    subtitleLabel.text = "Join thousands of happy Pro users"
//    subtitleLabel.font = UIFont.systemFont(ofSize: 16)
//    subtitleLabel.textColor = .gray
//    subtitleLabel.textAlignment = .center
//    view.addSubview(subtitleLabel)
//    subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
//
//    NSLayoutConstraint.activate([
//      subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
//      subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//    ])
//
//
//
//    // Beneficios
////    let benefits = [
////      "Unlimited access to premium features",
////      "Priority support",
////      "Ad-free experience",
////      "Exclusive content updates",
////      "Unlimited access to premium features"
////    ]
////
////    var lastBenefitLabel: UILabel? = nil
////
////    for benefit in benefits {
////      let label = UILabel()
////      label.text = benefit
////      label.font = UIFont.systemFont(ofSize: 16)
////      label.textColor = ThemeManager.color(for: .primaryText)
////      label.numberOfLines = 0
////      view.addSubview(label)
////      label.translatesAutoresizingMaskIntoConstraints = false
////
////      NSLayoutConstraint.activate([
////        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
////        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
////      ])
////
////      if let last = lastBenefitLabel {
////        label.topAnchor.constraint(equalTo: last.bottomAnchor, constant: 12).isActive = true
////      } else {
////        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
////      }
////
////      lastBenefitLabel = label
////    }
//
//    // Botones de suscripción
//    let monthlyButton = createSubscriptionButton(title: "Subscribe")
//    let footerStackView = createFooterStackView()
//    footerStackView.translatesAutoresizingMaskIntoConstraints = false
//    let pricingView = PricingOptionsView()
//    pricingView.translatesAutoresizingMaskIntoConstraints = false
//
//
//    view.addSubview(footerStackView)
//    view.addSubview(monthlyButton)
//    view.addSubview(pricingView)
//
//    monthlyButton.translatesAutoresizingMaskIntoConstraints = false
//
//    NSLayoutConstraint.activate([
//      pricingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//      pricingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//      pricingView.bottomAnchor.constraint(equalTo: monthlyButton.topAnchor, constant: -12),
//
//      //              monthlyButton.topAnchor.constraint(equalTo: lastBenefitLabel!.bottomAnchor, constant: 20),
//      monthlyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//      monthlyButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
//      monthlyButton.bottomAnchor.constraint(equalTo: footerStackView.topAnchor, constant: -14),
//
//      footerStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//      footerStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
//    ])
//  }
//
//  private func createSubscriptionButton(title: String) -> UIButton {
//    let button = UIButton(type: .system)
//    button.setTitle(title, for: .normal)
//    button.titleLabel?.font = FontManager.sfCompactDisplay(size: 18, weight: .semibold)
//    button.backgroundColor = ThemeManager.color(for: .secondaryBackground)
//    button.setTitleColor(ThemeManager.color(for: .secondaryText), for: .normal)
//    button.layer.cornerRadius = 18
//    button.translatesAutoresizingMaskIntoConstraints = false
//    button.heightAnchor.constraint(equalToConstant: 64).isActive = true
//    return button
//  }
//  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//    super.traitCollectionDidChange(previousTraitCollection)
//
//    // Verifica si el cambio de apariencia fue lo que cambió
//    if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
//      updateGradient()
//    }
//  }
//
//  private func updateGradient() {
//    // Elimina el gradiente existente
//    if let sublayers = headerImageView.layer.sublayers {
//      for layer in sublayers where layer is CAGradientLayer {
//        layer.removeFromSuperlayer()
//      }
//    }
//
//    // Crea un nuevo gradiente
//    let gradientLayer = CAGradientLayer()
//    gradientLayer.colors = [
//      UIColor.clear.cgColor,
//      ThemeManager.color(for: .primaryBackground).withAlphaComponent(0.5).cgColor
//    ]
//    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
//    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
//    gradientLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: headerHeight)
//
//    // Añade el gradiente al headerImageView
//    headerImageView.layer.addSublayer(gradientLayer)
//  }
//
//
//  func scrollViewDidScroll(_ scrollView: UIScrollView) {
//    let offsetY = scrollView.contentOffset.y
//
//    if offsetY < 0 {
//      headerImageView.frame = CGRect(
//        x: 0,
//        y: offsetY,
//        width: view.bounds.width,
//        height: headerHeight - offsetY
//      )
//    } else {
//      headerImageView.frame = CGRect(
//        x: 0,
//        y: offsetY * 0.5,
//        width: view.bounds.width,
//        height: headerHeight
//      )
//    }
//  }
//
//
//  func createFooterStackView() -> UIView {
//      // Crear el botón "Not now"
//      let notNowButton = UIButton(type: .system)
//      notNowButton.setTitle("Not now", for: .normal)
//    notNowButton.setTitleColor(.gray, for: .normal)
//      notNowButton.addTarget(nil, action: #selector(notNowTapped), for: .touchUpInside)
//
//      // Crear el label con el símbolo "|"
//      let separatorLabel = UILabel()
//      separatorLabel.text = "|"
//      separatorLabel.textColor = .gray
//      separatorLabel.textAlignment = .center
//
//      // Crear el botón "Restore purchase"
//      let restoreButton = UIButton(type: .system)
//      restoreButton.setTitle("Restore purchase", for: .normal)
//      restoreButton.setTitleColor(.gray, for: .normal)
//      restoreButton.addTarget(nil, action: #selector(restoreTapped), for: .touchUpInside)
//
//      // Crear el UIStackView
//      let stackView = UIStackView(arrangedSubviews: [notNowButton, separatorLabel, restoreButton])
//      stackView.axis = .horizontal
//      stackView.distribution = .equalSpacing
//      stackView.alignment = .center
//      stackView.spacing = 8
//
//      // Crear una vista contenedora para mayor flexibilidad
//      let containerView = UIView()
//      containerView.addSubview(stackView)
//
//      // Configurar las restricciones del stackView
//      stackView.translatesAutoresizingMaskIntoConstraints = false
//      NSLayoutConstraint.activate([
//          stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
//          stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
//          stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
//          stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
//      ])
//
//      return containerView
//  }
//
//  // Métodos de acciones para los botones
//  @objc func notNowTapped() {
//      print("Not now button tapped")
//  }
//
//  @objc func restoreTapped() {
//      print("Restore purchase button tapped")
//  }

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





struct PricingOption {
    let title: String
    let description: String
    let price: String
    let discount: String?
}

class PricingOptionsView: UIView {
    // Subvistas principales
    private let stackView = UIStackView()
    private var isExpanded = false
    private var pricingOptions: [PricingOption] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // Configurar la vista principal
    private func setupUI() {
        // Configuración del stackView
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        // Configuración de las restricciones
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // Cargar las opciones de precios iniciales
        loadPricingOptions()
        updateStackView()
    }

    private func loadPricingOptions() {
        // Datos iniciales de las opciones de precios
        pricingOptions = [
            PricingOption(
                title: "Monthly",
                description: "Monthly subscription to Joi",
                price: "$99.00",
                discount: nil
            ),
            PricingOption(
                title: "Annual",
                description: "Annual subscription to Joi",
                price: "$999.00",
                discount: "-60%"
            ),
            PricingOption(
                title: "Lifetime",
                description: "Pay once, use forever",
                price: "$1,999.00",
                discount: nil
            )
        ]
    }

    private func updateStackView() {
        // Limpiar el stackView
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // Mostrar las opciones según el estado de expansión
        let optionsToDisplay = isExpanded ? pricingOptions : [pricingOptions[1]]

        for option in optionsToDisplay {
            stackView.addArrangedSubview(createOptionView(for: option))
        }

        // Botón para expandir o colapsar
        let arrowButton = UIButton(type: .system)
        arrowButton.setTitle(isExpanded ? "▲ Collapse" : "▼ Expand", for: .normal)
        arrowButton.setTitleColor(.systemBlue, for: .normal)
        arrowButton.addTarget(self, action: #selector(toggleExpand), for: .touchUpInside)
        stackView.addArrangedSubview(arrowButton)
    }

    @objc private func toggleExpand() {
        isExpanded.toggle()
        updateStackView()
    }

    private func createOptionView(for option: PricingOption) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        container.layer.cornerRadius = 12
        container.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = option.title
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .black

        let descriptionLabel = UILabel()
        descriptionLabel.text = option.description
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .gray

        let priceLabel = UILabel()
        priceLabel.text = option.price
        priceLabel.font = .boldSystemFont(ofSize: 16)
        priceLabel.textColor = .black

        let discountBadge = UILabel()
        if let discount = option.discount {
            discountBadge.text = discount
            discountBadge.font = .boldSystemFont(ofSize: 12)
            discountBadge.textColor = .white
            discountBadge.backgroundColor = .systemBlue
            discountBadge.textAlignment = .center
            discountBadge.layer.cornerRadius = 8
            discountBadge.clipsToBounds = true
            discountBadge.translatesAutoresizingMaskIntoConstraints = false
        }

        // Stack para los textos
        let textStack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        textStack.axis = .vertical
        textStack.spacing = 4

        // Stack horizontal para contenido
        let horizontalStack = UIStackView(arrangedSubviews: [textStack, priceLabel])
        if let discount = discountBadge.superview {
            horizontalStack.addArrangedSubview(discount)
        }
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 8
        horizontalStack.alignment = .center

        container.addSubview(horizontalStack)
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false

        // Restricciones del stack horizontal
        NSLayoutConstraint.activate([
            horizontalStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            horizontalStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            horizontalStack.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            horizontalStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12)
        ])

        return container
    }
}

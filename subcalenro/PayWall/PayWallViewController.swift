//
//  PayWallViewController.swift
//  subcalenro
//
//  Created by Ronaldo Avalos on 09/12/24.
//

import Foundation
import UIKit

class PayWallViewController: UIViewController {
    
    let subscriptionProductID = "0004"
    //var product: SKProduct?
    
    private let logoView: UIImageView = {
          let imageView = UIImageView()
        imageView.image = .appicon
          imageView.contentMode = .scaleAspectFit
          imageView.translatesAutoresizingMaskIntoConstraints = false
          return imageView
      }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Desbloquear todas las funciones"
        label.font = UIFont.systemFont(ofSize: 24,weight: .semibold)
        label.textAlignment = .center
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subscribeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Subscribe", for: .normal)
        button.titleLabel?.font = FontManager.sfCompactDisplay(size: 21, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = ThemeManager.color(for: .secondaryBackground)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let restoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Restore Purchase", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
       }()
    
    let contenViewFeatures: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupView()
      //  fetchSubscriptionProduct()
    }

    private func setupView() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeView))
        
        let features = [
            "Alternative icons",
            "FEATURE_NO_ADS",
            "FEATURE_UNLIMITED_ONCALLS",
            "FEATURE_PREMIUM_ACCESS",
            "FEATURE_PRIORITY_SUPPORT",
        ]


        let featureStack = UIStackView()
        featureStack.axis = .vertical
        featureStack.spacing = 16
        featureStack.translatesAutoresizingMaskIntoConstraints = false
        
        features.forEach { feature in
            let featureLabel = UILabel()
            featureLabel.text = feature
            featureLabel.textAlignment = .center
            featureStack.addArrangedSubview(featureLabel)
        }
     //   subscribeButton.addTarget(self, action: #selector(subscribeButtonTapped), for: .touchUpInside)
      //  restoreButton.addTarget(self, action: #selector(restoreButtonTapped), for: .touchUpInside)
        
      
        contenViewFeatures.addSubview(featureStack)
        view.addSubview(descriptionLabel)
        view.addSubview(subscribeButton)
        view.addSubview(priceLabel)
        view.addSubview(restoreButton)
        view.addSubview(activityIndicator)
        view.addSubview(logoView)
        view.addSubview(contenViewFeatures)

        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 36),
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoView.widthAnchor.constraint(equalToConstant: 258),
            logoView.heightAnchor.constraint(equalToConstant: 120),
            
     
            descriptionLabel.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 26),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
            contenViewFeatures.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 14),
            contenViewFeatures.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contenViewFeatures.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant: -14),
            
            
            featureStack.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 36),
            featureStack.leadingAnchor.constraint(equalTo: contenViewFeatures.leadingAnchor, constant: 12),
            featureStack.trailingAnchor.constraint(equalTo: contenViewFeatures.trailingAnchor, constant: -12),
        
            subscribeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            subscribeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            subscribeButton.heightAnchor.constraint(equalToConstant: 74),
            
            subscribeButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 12),
            
            priceLabel.bottomAnchor.constraint(equalTo: subscribeButton.topAnchor, constant: -14),
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
            restoreButton.topAnchor.constraint(equalTo: subscribeButton.bottomAnchor, constant: 8),
            restoreButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            restoreButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
            restoreButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -36),
            
            activityIndicator.centerXAnchor.constraint(equalTo: subscribeButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: subscribeButton.centerYAnchor),
        ])
        view.setNeedsLayout()
        view.layoutIfNeeded()
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

    @objc func closeView() {
        self.dismiss(animated: true)
    }
}

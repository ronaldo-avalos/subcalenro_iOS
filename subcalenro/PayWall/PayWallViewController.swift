//
//  PayWallViewController.swift
//  subcalenro
//
//  Created by Ronaldo Avalos on 09/12/24.
//

import Foundation
import UIKit

class PayWallViewController: UIViewController, UIScrollViewDelegate  {

  private let scrollView = UIScrollView()
  private let headerImageView = UIImageView()
  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
  private let contentView = UIView()

  private let headerHeight: CGFloat = 400.0

  override func viewDidLoad() {
      super.viewDidLoad()
      setupUI()
  }

  private func setupUI() {
    view.backgroundColor = ThemeManager.color(for: .primaryBackground)

      // Configurar ScrollView
      scrollView.delegate = self
      scrollView.showsVerticalScrollIndicator = false
      scrollView.contentInsetAdjustmentBehavior = .never
      view.addSubview(scrollView)
      scrollView.translatesAutoresizingMaskIntoConstraints = false

      NSLayoutConstraint.activate([
          scrollView.topAnchor.constraint(equalTo: view.topAnchor),
          scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
          scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
      ])

      // Header Image View
      headerImageView.image = UIImage(named: "paywall_img_bg") // Cambia "album_image" por tu imagen
    headerImageView.contentMode = .scaleAspectFit
      headerImageView.clipsToBounds = true
      scrollView.addSubview(headerImageView)
      headerImageView.translatesAutoresizingMaskIntoConstraints = false

      NSLayoutConstraint.activate([
          headerImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
          headerImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          headerImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
          headerImageView.heightAnchor.constraint(equalToConstant: headerHeight)
      ])

      // Gradient Overlay
      let gradientLayer = CAGradientLayer()
      gradientLayer.colors = [
          UIColor.clear.cgColor,
          ThemeManager.color(for: .primaryBackground).withAlphaComponent(0.8).cgColor
      ]
      gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
      gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
      gradientLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: headerHeight)
      headerImageView.layer.addSublayer(gradientLayer)

      // Title Label
      titleLabel.text = "Try our premium features \nfor free"
      titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
     titleLabel.textColor = ThemeManager.color(for: .primaryText)
      titleLabel.numberOfLines = 2
      titleLabel.textAlignment = .center
      scrollView.addSubview(titleLabel)
      titleLabel.translatesAutoresizingMaskIntoConstraints = false

      NSLayoutConstraint.activate([
          titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
          titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
          titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
          titleLabel.bottomAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: -40)
      ])

      // Subtitle Label
      subtitleLabel.text = "509,333 Monthly Listeners"
      subtitleLabel.font = UIFont.systemFont(ofSize: 14)
      subtitleLabel.textColor = .gray
      subtitleLabel.textAlignment = .center
      scrollView.addSubview(subtitleLabel)
      subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

      NSLayoutConstraint.activate([
          subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
          subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10)
      ])

      // Content View
      contentView.backgroundColor = ThemeManager.color(for: .primaryBackground)
      scrollView.addSubview(contentView)
      contentView.translatesAutoresizingMaskIntoConstraints = false

      NSLayoutConstraint.activate([
          contentView.topAnchor.constraint(equalTo: headerImageView.bottomAnchor),
          contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
          contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
          contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
          contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
      ])
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
      let offsetY = scrollView.contentOffset.y

      if offsetY < 0 {
          // Parallax hacia abajo (expansión)
          headerImageView.frame = CGRect(
              x: 0,
              y: offsetY,
              width: view.bounds.width,
              height: headerHeight - offsetY
          )
      } else {
          // Parallax hacia arriba (desplazamiento más lento)
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


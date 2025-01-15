//
//  SubscriptionCell.swift
//  subcalenro
//
//  Created by ronaldo avalos on 09/10/24.
//

import UIKit
import Kingfisher

class SubscriptionCell: UITableViewCell {

  let logoImageView = UIImageView()
  let logoContentView = UIView()
  let titleLabel = UILabel()
  let priceLabel = UILabel()
  let periodLabel = UILabel()
  let reminderLabel = UILabel()
  let statusIndicatorView = UIView()
  let contentCellView = UIView()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupCell() {
    contentView.backgroundColor = ThemeManager.color(for: .primaryBackground)
    // Configuración del logo
    logoContentView.translatesAutoresizingMaskIntoConstraints = false
    logoContentView.layer.cornerRadius = 8
    logoContentView.backgroundColor = .white
    logoContentView.clipsToBounds = true

    logoImageView.translatesAutoresizingMaskIntoConstraints = false
    logoImageView.contentMode = .scaleAspectFit
    logoContentView.addSubview(logoImageView)
    NSLayoutConstraint.activate([
      logoImageView.centerXAnchor.constraint(equalTo: logoContentView.centerXAnchor),
      logoImageView.centerYAnchor.constraint(equalTo: logoContentView.centerYAnchor),
      logoImageView.widthAnchor.constraint(equalToConstant: 50),
      logoImageView.heightAnchor.constraint(equalToConstant: 50)
    ])


    // Configuración del título
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
    titleLabel.textColor = .label

    // Configuración del precio
    priceLabel.translatesAutoresizingMaskIntoConstraints = false
    priceLabel.font = UIFont.systemFont(ofSize: 14)
    priceLabel.textColor = .systemGray

    // Configuración del periodo
    periodLabel.translatesAutoresizingMaskIntoConstraints = false
    periodLabel.font = UIFont.systemFont(ofSize: 14)
    periodLabel.textColor = .systemGray

    // Configuración del recordatorio
    reminderLabel.translatesAutoresizingMaskIntoConstraints = false
    reminderLabel.font = UIFont.systemFont(ofSize: 14)
    reminderLabel.textColor = .systemGray

    // Indicador de estado
    statusIndicatorView.translatesAutoresizingMaskIntoConstraints = false
    statusIndicatorView.layer.cornerRadius = 4
    statusIndicatorView.clipsToBounds = true

    let subViews = [logoContentView,titleLabel,priceLabel,periodLabel,reminderLabel,statusIndicatorView]
    subViews.forEach(contentCellView.addSubview(_:))

    contentCellView.translatesAutoresizingMaskIntoConstraints = false
    contentCellView.clipsToBounds = true
    contentCellView.layer.cornerRadius = 12
    contentCellView.backgroundColor = ThemeManager.color(for: .tableViewCellColor)
    contentView.addSubview(contentCellView)

    NSLayoutConstraint.activate([
      contentCellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
      contentCellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      contentCellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      contentCellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),

      logoContentView.leadingAnchor.constraint(equalTo: contentCellView.leadingAnchor, constant: 16),
      logoContentView.centerYAnchor.constraint(equalTo: contentCellView.centerYAnchor),
      logoContentView.widthAnchor.constraint(equalToConstant: 56),
      logoContentView.heightAnchor.constraint(equalToConstant: 56),

      titleLabel.topAnchor.constraint(equalTo: contentCellView.topAnchor, constant: 16),
      titleLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 12),

      priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
      priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

      periodLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 8),
      periodLabel.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),

      reminderLabel.trailingAnchor.constraint(equalTo: contentCellView.trailingAnchor, constant: -16),
      reminderLabel.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),

      statusIndicatorView.topAnchor.constraint(equalTo: contentCellView.topAnchor, constant: 10),
      statusIndicatorView.trailingAnchor.constraint(equalTo: contentCellView.trailingAnchor, constant: -16),
      statusIndicatorView.widthAnchor.constraint(equalToConstant: 8),
      statusIndicatorView.heightAnchor.constraint(equalToConstant: 8),
    ])
  }

  func configure(with subscription: Subscription) {
    if  subscription.logoUrl.isEmpty {
      logoImageView.image = UIImage(named: subscription.iconName)
    } else {
      logoImageView.kf.setImage(with: URL(string: subscription.logoUrl))
    }
    titleLabel.text = subscription.name
    priceLabel.text = String(format: "$%.2f", subscription.amount)
    periodLabel.text = subscription.period.name

    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    reminderLabel.text = subscription.reminderTime.name

    statusIndicatorView.backgroundColor = subscription.isActive ? .systemGreen : .systemOrange

    contentView.alpha = subscription.isActive ? 1 : 0.5

  }
}

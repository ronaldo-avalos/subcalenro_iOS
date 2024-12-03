//
//  OptionsFloatingBarView.swift
//  subcalenro
//
//  Created by ronaldo avalos on 06/09/24.
//

import Foundation
import UIKit

protocol OptionsFloatingBarViewDelegate: AnyObject {
    func analyticsButtonTapped()
//    func subListButtonTapped()
    func newEventButtonTapped()
    func settingsButtonTapped()
}

class OptionsFloatingBarView : UIView {
  
    weak var delegate: OptionsFloatingBarViewDelegate?
    
    let analyticsButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 0)
        button.configuration = configuration
        let symbolName = "chart.pie.fill"
        let boldConfig = UIImage.SymbolConfiguration(weight: .regular)
        let boldImage = UIImage(systemName: symbolName)?.withConfiguration(boldConfig)
        button.setImage(boldImage, for: .normal)
        button.tintColor = ThemeManager.color(for: .primaryBackground)
        return button
    }()

    let settingsButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 6, bottom: 12, trailing: 12)
        button.configuration = configuration
        let symbolName = "gearshape.fill"
        let boldConfig = UIImage.SymbolConfiguration(weight: .regular)
        let boldImage = UIImage(systemName: symbolName)?.withConfiguration(boldConfig)
        button.setImage(boldImage, for: .normal)
        button.tintColor = ThemeManager.color(for: .primaryBackground)
        return button
    }()

    let subListButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        button.configuration = configuration
        let symbolName = "list.dash"
        let boldConfig = UIImage.SymbolConfiguration(weight: .semibold)
        let boldImage = UIImage(systemName: symbolName)?.withConfiguration(boldConfig)
        button.setImage(boldImage, for: .normal)
        button.tintColor = ThemeManager.color(for: .primaryBackground)
        return button
    }()

    let addButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 6)
        button.configuration = configuration
        let symbolName = "plus"
        let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
        let boldImage = UIImage(systemName: symbolName)?.withConfiguration(boldConfig)
        button.setImage(boldImage, for: .normal)
        button.tintColor = ThemeManager.color(for: .primaryBackground)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.layer.cornerRadius = Utility.isIpad ? 65/2 :  27.5
        self.layer.shadowColor = ThemeManager.color(for: .secondaryBackground).cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 10
        self.backgroundColor = ThemeManager.color(for: .secondaryBackground)

        let stackView = UIStackView(arrangedSubviews: [settingsButton,analyticsButton,addButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        
        self.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true

        analyticsButton.addAction(UIAction(handler: { _ in
            self.delegate?.analyticsButtonTapped()
        }), for: .touchUpInside)
        
        settingsButton.addAction(UIAction(handler: { _ in
            self.delegate?.settingsButtonTapped()
        }), for: .touchUpInside)
        
        subListButton.addAction(UIAction(handler: { _ in
//            self.delegate?.subListButtonTapped()
        }), for: .touchUpInside)
        
        addButton.addAction(UIAction(handler: { _ in
            self.delegate?.newEventButtonTapped()
        }), for: .touchUpInside)
        
        
    }
    
}

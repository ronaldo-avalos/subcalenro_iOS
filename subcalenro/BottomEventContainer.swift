//
//  bottomEventContainer.swift
//  subcalenro
//
//  Created by ronaldo avalos on 08/09/24.
//

import Foundation
import UIKit

class BottomContainer: UIView {
    
    let topBorder = UIView()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = ThemeManager.color(for: .primaryBackground)
        topBorder.backgroundColor = .systemGray4
        topBorder.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topBorder)

        NSLayoutConstraint.activate([
            topBorder.topAnchor.constraint(equalTo: topAnchor),
            topBorder.leadingAnchor.constraint(equalTo: leadingAnchor),
            topBorder.trailingAnchor.constraint(equalTo: trailingAnchor),
            topBorder.heightAnchor.constraint(equalToConstant: 0.3),
         
        ])
    }
    
}

//
//  SubViewBuilder.swift
//  subcalenro
//
//  Created by ronaldo avalos on 06/10/24.
//

import Foundation
import UIKit
import Kingfisher

class SubViewBuilder {
    
    static func build(for subs: [(Date,Subscription)], on date: Date) -> UIStackView? {
        let view = UIStackView(frame: CGRect(x: 0, y: 0, width: 60, height: 10))
        view.axis = .horizontal
        view.spacing = 2
        view.alignment = .center
        view.distribution = .equalCentering
        view.spacing = 4

        let maxEventsToShow = 2
        let eventsToShow = subs.filter { Calendar.current.isDate($0.0, inSameDayAs: date) }.prefix(maxEventsToShow)
        
        eventsToShow.forEach { event in
            let imageView = UIImageView()
            DispatchQueue.main.async {
                imageView.kf.setImage(with: URL(string: event.1.logoUrl))
            }
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.layer.masksToBounds = true
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            view.addArrangedSubview(imageView)
        }

        
        if eventsToShow.count < subs.filter({ Calendar.current.isDate($0.0, inSameDayAs: date) }).count {
            let plusImageView = UIImageView(image: UIImage(systemName: "plus"))
            plusImageView.translatesAutoresizingMaskIntoConstraints = false
            plusImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
            plusImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
            plusImageView.tintColor = .label
            view.addArrangedSubview(plusImageView)
        }

        let totalWidth = 12 * eventsToShow.count + 10 * (eventsToShow.count < subs.filter({ $0.0 == date }).count ? 1 : 0)
        view.frame = CGRect(x: 0, y: -8, width: totalWidth, height: 30)
        return view
    }

    
}

//
//  FSCalendarDelegate.swift
//  subcalenro
//
//  Created by ronaldo avalos on 03/10/24.
//

import Foundation
import UIKit
import FSCalendar

final class CalendarDelegate : NSObject, FSCalendarDelegate {
    var didSelectDate: ((Date, CalendarViewCell) -> Void)?
    var didDeselectDate: ((Date, CalendarViewCell) -> Void)?
    var didDeselect: (() -> Void)?
    var test: ((CGRect, FSCalendar) -> Void)?
    var currentPageDidChange: ((FSCalendar) -> Void)?
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if !PreferencesManager.shared.vibrationEnabled {
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        }
        
        if let cell = calendar.cell(for: date, at: monthPosition) as? CalendarViewCell {
            didDeselectDate?(date,cell)
            didSelectDate?(date, cell)
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if let cell = calendar.cell(for: date, at: monthPosition) as? CalendarViewCell {
            didDeselectDate?(date, cell)
            didDeselect?()
        }
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
//        if cell.viewWithTag(100) == nil {
//            let interaction = UIContextMenuInteraction(delegate: self)
//            cell.addInteraction(interaction)
//            cell.tag = 100
//        }
    }
    

    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        Utility.feedbackGenerator(style: .light)
        currentPageDidChange?(calendar)
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        guard let cell = calendar.cell(for: date, at: monthPosition) else { return true }
        if PreferencesManager.shared.animationSelectDay {return true}
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            cell.transform = CGAffineTransform.identity
        }, completion: nil)
        
        return true
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
          calendar.frame = CGRect(origin: calendar.frame.origin, size: bounds.size)
          test?(bounds, calendar)
      }
}

extension CalendarDelegate: UIContextMenuInteractionDelegate {
    
    // Proveer el menú contextual
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
    
            let action1 = UIAction(title: "Agregar Evento", image: UIImage(systemName: "calendar.badge.plus")) { action in
                print("Agregar evento seleccionado")
            }
            
            let action2 = UIAction(title: "Eliminar Evento", image: UIImage(systemName: "trash")) { action in
                print("Eliminar evento seleccionado")
            }
            
            // Crear el menú
            return UIMenu(title: "", children: [action1, action2])
        }
    }
    
    // Opcional: Esto te permite previsualizar contenido si lo deseas
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, previewForHighlightingMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return nil
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, previewForDismissingMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return nil
    }
}

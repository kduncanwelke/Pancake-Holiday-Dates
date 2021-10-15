//
//  UIView-Extension.swift
//  Holiday Calendar
//
//  Created by Kate Duncan-Welke on 10/13/21.
//

import Foundation
import UIKit

extension UIView {

    // popup for notice
    func popUp() {
        UIView.animate(withDuration: 2.0, animations: {
            self.isHidden = false
            self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: { [unowned self] _ in
            self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.isHidden = true
        })
    }

    // display for holiday details
    func display() {
        UIView.animate(withDuration: 1.0, animations: {
            self.isHidden = false
            self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
    }

    // hide for holiday details
    func hide() {
        UIView.animate(withDuration: 1.0, animations: {
            self.isHidden = false
            self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.isHidden = true
        }, completion: nil)
    }

    // sqoosh animation for pancake kitty
    func sqoosh() {
        UIView.animate(withDuration: 1.5, animations: {
            self.transform = CGAffineTransform(scaleX: 1.1, y: 0.9)
            self.transform = CGAffineTransform(scaleX: 1.2, y: 0.8)
        }, completion: nil)
    }

    // remove sqoosh for pancake kitty
    func unsqoosh() {
        UIView.animate(withDuration: 1.5, animations: {
            self.transform = CGAffineTransform(scaleX: 1.1, y: 0.9)
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
    }
}

extension UIViewController {
    // add reusable alert functionality
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

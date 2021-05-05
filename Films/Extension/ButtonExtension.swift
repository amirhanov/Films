//
//  ButtonExtension.swift
//  Films
//
//  Created by Амирханов Рустам Аждарович on 05.05.2021.
//

import UIKit
import Foundation

extension UIButton {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.1) {
            self.transform = .init(scaleX: 0.98, y: 0.98)
        }
        super.touchesBegan(touches, with: event)
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
        }
        super.touchesEnded(touches, with: event)
    }

    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
        }
        super.touchesCancelled(touches, with: event)
    }
}

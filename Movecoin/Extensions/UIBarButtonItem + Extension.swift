//
//  UIBarButtonItem + Extension.swift
//  Movecoins
//
//  Created by eww090 on 21/01/20.
//  Copyright © 2020 eww090. All rights reserved.
//

import Foundation
import UIKit

public class BadgeBarButtonItem: UIBarButtonItem
{
    @IBInspectable
    public var numberOfBages: Int = 0 {
        didSet {
            self.updateBadge()
        }
    }

    private var label: InsetLabel

    required public init?(coder aDecoder: NSCoder)
    {
        let label = InsetLabel()
        label.backgroundColor = .darkGray
        label.alpha = 0.9
        label.layer.cornerRadius = 9
        label.clipsToBounds = true
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13)
        label.layer.zPosition = 1
        self.label = label

        super.init(coder: aDecoder)

        self.addObserver(self, forKeyPath: "view", options: [], context: nil)
    }
    
    override init(){
//        super.init()
        let label = InsetLabel()
        label.backgroundColor = ThemeBlueColor
        label.alpha = 0.9
        label.layer.cornerRadius = 9
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.regular(ofSize: 13)
        label.layer.zPosition = 1
        self.label = label
        self.label.isUserInteractionEnabled = false
        super.init()
        self.addObserver(self, forKeyPath: "view", options: [], context: nil)
    }

    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        self.updateBadge()
    }

    private func updateBadge()
    {
        guard let view = self.value(forKey: "view") as? UIView else { return }

        self.label.text = "\(numberOfBages)"

        if self.numberOfBages > 0 && self.label.superview == nil
        {
            view.addSubview(self.label)
            let size = ((label.text?.count ?? 0) <= 2) ? 18 : 33

            self.label.widthAnchor.constraint(equalToConstant: CGFloat(size)).isActive = true
            self.label.heightAnchor.constraint(equalToConstant: 18).isActive = true
            self.label.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 9).isActive = true
            self.label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -9).isActive = true
        }
        else if self.numberOfBages == 0 && self.label.superview != nil
        {
            self.label.removeFromSuperview()
        }
    }

    deinit {
        self.removeObserver(self, forKeyPath: "view")
    }
}
class InsetLabel: UILabel {
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 3, right: 0)))
    }
}

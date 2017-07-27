//
//  FLSwitcher.swift
//  FLSwitcher
//
//  Created by Antonia Chekrakchieva on 7/27/17.
//  Copyright © 2017 Futurist Labs. All rights reserved.
//

import Foundation
import UIKit

protocol CustomSwitchDelegate {
    func switchShouldChange(shouldBecameOn: Bool)
}

@IBDesignable
open class FLSwitcher: UIView {
    
    @IBInspectable open var onLabelText: String = "Disable now" {
        didSet {
            onLabel.text = onLabelText
        }
    }
    
    @IBInspectable open var offLabelText: String = "Go Online" {
        didSet {
            offLabel.text = offLabelText
        }
    }
    
    @IBInspectable open var buttonBackgroundColor: UIColor = .gray {
        didSet {
            switchButton.backgroundColor = buttonBackgroundColor
        }
    }
    @IBInspectable open var isOn: Bool = false {
        didSet {

            changeSliderButtonPosition()
        }
    }
    
    @IBAction func panGestureStart(_ sender: UIPanGestureRecognizer) {
        
        guard sender.state != .ended else {
            
            checkPositio()
            return
        }

    }
    
    @IBOutlet private var onLabel: UILabel! = UILabel()
    @IBOutlet private var offLabel: UILabel! = UILabel()

    @IBOutlet private var switchButton: UIView! = UIView()

    
    private var buttonOffset: CGFloat = 10
    
    private var width: NSLayoutConstraint = NSLayoutConstraint()
    private var height: NSLayoutConstraint = NSLayoutConstraint()
    private var centerY: NSLayoutConstraint = NSLayoutConstraint()
    private var leading: NSLayoutConstraint = NSLayoutConstraint()
    private var trailing: NSLayoutConstraint = NSLayoutConstraint()
    
    var delegate: CustomSwitchDelegate?
    
    private func checkPositio() {
        if switchButton.center.x < center.x {

            if !isOn {
                delegate?.switchShouldChange(shouldBecameOn: !isOn)
                isOn = !isOn
            }
            

            changeSliderButtonPosition()

            
        } else {

            if isOn {
                delegate?.switchShouldChange(shouldBecameOn: !isOn)
                isOn = !isOn
            }
            
            
            changeSliderButtonPosition()

        }
    }
    
    private func changeSliderButtonPosition() {
        
        leading.isActive = !isOn
        trailing.isActive = isOn
        
        onLabel.isHidden = isOn
        offLabel.isHidden = !isOn

    }
    
    private func configCornerRadius() {
        layer.cornerRadius = frame.height * 0.5
        switchButton.layer.cornerRadius = frame.height * 0.5 - 8
    }
    
    private func config() {
        
        switchButton = UIView(frame: CGRect(x: 0, y: 0, width: frame.width / 2 - frame.height * 0.1, height: frame.height - frame.height * 0.1))
        switchButton.backgroundColor = .purple
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        configCornerRadius()
        
        addSubview(switchButton)
        
        
        onLabel = UILabel(frame: CGRect(x: frame.width / 2, y: 0, width: frame.width / 2, height: frame.height))
        onLabel.text = onLabelText
        onLabel.textAlignment = .center
        addSubview(onLabel)
        
        
        offLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width / 2, height: frame.height))
        offLabel.text = offLabelText
        offLabel.textAlignment = .center
        
        addSubview(offLabel)
        
        centerY = NSLayoutConstraint(item: switchButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        width = NSLayoutConstraint(item: switchButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.5, constant: 1.0)

        height = NSLayoutConstraint(item: switchButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.8, constant: 1.0)
                
        leading = NSLayoutConstraint(item: switchButton, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: frame.height * 0.1)

        trailing = NSLayoutConstraint(item: switchButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -frame.height * 0.1)
        
        addConstraints([centerY, width, height, trailing, leading])

        leading.isActive = false
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(FLSwitcher.panGestureStart(_:)))
        addGestureRecognizer(gesture)

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        config()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        config()
    }
}

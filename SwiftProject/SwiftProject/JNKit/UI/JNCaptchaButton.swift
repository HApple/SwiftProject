//
//  JNCaptchaButton.swift
//  SwiftProject
//
//  Created by hjn on 2021/3/17.
//

import UIKit

public class JNCaptchaButton: UIButton {
    
    // MARK: - Properties
    
    public var maxSecond = 60
    public var countDown = false {
        didSet {
            if oldValue != countDown {
                countDown ? startCountdown() : stopCountdown()
            }
        }
    }
    
    private var second = 0
    private var timer: Timer?
    
    private var timeLabel = UILabel()
    private var normalText: String!
    private var normalTextColor: UIColor!
    private var disabledText: String!
    private var disabledTextColor: UIColor!
    
    
    // MARK: - Life Cycle
    deinit {
        countDown = false
    }
    
    // MARK: - Setups
    
    private func setupLabel() {
        guard timeLabel.superview == nil else {
            return
        }
        
        normalText = title(for: .normal) ?? ""
        disabledText = title(for: .disabled) ?? ""
        normalTextColor = titleColor(for: .normal) ?? .white
        disabledTextColor = titleColor(for: .disabled) ?? .white
        setTitle("", for: .normal)
        setTitle("", for: .disabled)
        timeLabel.frame = bounds
        timeLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        timeLabel.font = titleLabel?.font
        timeLabel.textColor = normalTextColor
        timeLabel.text = normalText
        addSubview(timeLabel)
    }
    
    // MARK: - Private
    
    private func startCountdown() {
        setupLabel()
        second = maxSecond
        
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
        
    }
    
    
    private func stopCountdown() {
        timer?.invalidate()
        timer = nil
        updateNoraml()
    }

    
    private func updateNoraml() {
        isEnabled = true
        timeLabel.textColor = normalTextColor
        timeLabel.text = normalText
    }
    
    private func updateDisabled() {
        isEnabled = false
        timeLabel.textColor = disabledTextColor
        timeLabel.text = disabledText.replacingOccurrences(of: "second", with: "\(second)")
    }
    
    @objc private func updateCountdown() {
        second -= 1
        if second <= 0 {
            countDown = false
        }else {
            updateDisabled()
        }
    }
}

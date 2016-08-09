//
//  WalletViewController.swift
//  Tangle
//
//  Created by Jake on 7/30/16.
//  Copyright © 2016 Jake. All rights reserved.
//

import UIKit

enum Mode: Int {
    case normal
    case mix
}

class WalletViewController: UIViewController {
    // MARK: - Properties
    var mode = Mode(rawValue: 0)
    
    var bitcoinLogoImageViewShakeAnimation: CustomAnimation!
    var refreshRotateAnimation: CustomAnimation!
    
    // MARK: - IBOutlets
    @IBOutlet weak var bitcoinLogoImageView: UIImageView!
    @IBOutlet weak var accountTitleBalanceLabel: UILabel!
    @IBOutlet weak var accountBalanceLabel: UILabel!
    
    // Stack View
    @IBOutlet weak var actionStackView: UIStackView!
    
    // Buttons to change view
    @IBOutlet weak var receiveButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var actionView: UIView!
    
    // Receive
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var publicKeyLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
    // Send
    @IBOutlet weak var sendAmountTextField: UITextField!
    @IBOutlet weak var forwardAddressTextField: UITextField!
    @IBOutlet weak var sendBitcoinButton: UIButton!
    
    // MARK: - IBActions
    @IBAction func receiveButtonTapped(sender: AnyObject) {
        hideSendFunctionality()
        unhideReceiveFunctionality()
    }
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
        hideReceiveFunctionality()
        unhideSendFunctionality()
    }
    
    @IBAction func refreshButtonTapped(sender: AnyObject) {
        refreshRotateAnimation.rotateAnimation()
    }
    
    // MARK: - View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareAccountBalanceTitleLabel()
        prepareBitcoinImageViewTapGestureRecognizer()
        prepareBitcoinLogoImageViewShakeAnimation()
        prepareStackViewShadow()
        preparePublicKeyTapGestureRecognizer()
        prepareRefreshShakeAnimation()
        prepareSendBitcoinButton()
        prepareForwardAddressTextField()
        prepareNSNotificationCenterObserversForKeyboard()
        
        let network = BTCNetwork(name: "testnet")
    }
    
    // MARK: - Preparations
    func prepareAccountBalanceTitleLabel() {
        let attributedString = accountTitleBalanceLabel.attributedText as! NSMutableAttributedString
        attributedString.addAttribute(NSKernAttributeName, value: 1.0, range: NSMakeRange(0, attributedString.length))
    }
    
    func prepareBitcoinImageViewTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(shakeAnimation))
        bitcoinLogoImageView.addGestureRecognizer(tap)
    }
    
    func prepareBitcoinLogoImageViewShakeAnimation() {
        bitcoinLogoImageViewShakeAnimation = CustomAnimation(view: bitcoinLogoImageView, afterDelay: 0, startDirection: .Left, repetitions: 6, maxRotation: 0.15, maxPosition: 20, duration: 0.15)
    }
    
    func prepareStackViewShadow() {
        actionView.layer.masksToBounds = false
        actionView.layer.shadowOffset = CGSizeMake(3, 3)
        actionView.layer.shadowRadius = 10
        actionView.layer.shadowOpacity = 0.2
    }
    
    func preparePublicKeyTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(copyPublicKey))
        publicKeyLabel.userInteractionEnabled = true
        publicKeyLabel.addGestureRecognizer(tap)
    }
    
    func prepareRefreshShakeAnimation() {
        refreshRotateAnimation = CustomAnimation(view: refreshButton, afterDelay: 0, startDirection: .Right, repetitions: 1, maxRotation: 1, maxPosition: 0, duration: 0.2)
    }
    
    func prepareSendBitcoinButton() {
        sendBitcoinButton.layer.cornerRadius = 5.0
    }
    
    func prepareForwardAddressTextField() {
        forwardAddressTextField.delegate = self
    }
    
    func prepareNSNotificationCenterObserversForKeyboard() {
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(keyboardWillShow),
                                                         name: UIKeyboardWillShowNotification,
                                                         object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(keyboardWillHide),
                                                         name: UIKeyboardWillHideNotification,
                                                         object: nil)
    }
    
    // MARK: - Helper Methods
    // Receive Button Tapped
    func hideSendFunctionality() {
        sendAmountTextField.hidden = true
        forwardAddressTextField.hidden = true
        sendBitcoinButton.hidden = true
    }
    
    func unhideReceiveFunctionality() {
        qrCodeImageView.hidden = false
        publicKeyLabel.hidden = false
        refreshButton.hidden = false
    }
    
    // Send Button Tapped
    func hideReceiveFunctionality() {
        qrCodeImageView.hidden = true
        publicKeyLabel.hidden = true
        refreshButton.hidden = true
    }
    
    func unhideSendFunctionality() {
        sendAmountTextField.hidden = false
        forwardAddressTextField.hidden = false
        sendBitcoinButton.hidden = false
    }
    
    func copyPublicKey() {
        print("Public Key Copied")
        UIPasteboard.generalPasteboard().string = publicKeyLabel.text
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.bounds.origin.y == 0 {
                view.bounds.origin.y += keyboardSize.height
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.bounds.origin.y = 0
    }
    
    
}

extension WalletViewController {
    // MARK: - Animations
    // Shake Animation
    func shakeAnimation() {
        bitcoinLogoImageViewShakeAnimation.shakeAnimation()
    }
    
    // Shake Phone Gesture
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        
        mode = Mode(rawValue: abs(mode!.rawValue - 1))!
        
        switch mode! as Mode {
        case .normal:
            actionView.backgroundColor = UIColor.whiteColor()
            break
        case .mix:
            actionView.backgroundColor = UIColor.offWhiteColor()
            break
        }
        
        //        guard bitcoinLogoImageViewShakeAnimation.running == false else { return }
        
        bitcoinLogoImageViewShakeAnimation.shakeAnimation()
        
    }
}

// MARK: - Text Field Delegates
extension WalletViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        if textField == sendAmountTextField {
            forwardAddressTextField.becomeFirstResponder()
        }
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        actionView.endEditing(true)
    }
    
}


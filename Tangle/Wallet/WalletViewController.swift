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

final class WalletViewController: UIViewController {
    // MARK: - Properties
    var mode = Mode(rawValue: 0)
    
    var bitcoinLogoImageViewShakeAnimation: CustomAnimation!
    var indicatorButtonAnimation: CustomAnimation!
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
    @IBOutlet weak var indicatorButton: UIButton!
    
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
    /**
     @name  receiveButtonTapped
     
     - parameter sender: AnyObject
     */
    @IBAction func receiveButtonTapped(_ sender: AnyObject) {
        hideSendFunctionality()
        unhideReceiveFunctionality()
        indicatorButtonAnimation.animateIndicatorToReceive()
    }
    
    /**
     @name  sendButtonTapped
     
     - parameter sender: AnyObject
     */
    @IBAction func sendButtonTapped(_ sender: AnyObject) {
        hideReceiveFunctionality()
        unhideSendFunctionality()
        indicatorButtonAnimation.animateIndicatorToSend()
    }
    
    /**
     @name  refreshButtonTapped
     
     - parameter sender: AnyObject
     */
    @IBAction func refreshButtonTapped(_ sender: AnyObject) {
        // TODO: Generate and display new public key
        refreshRotateAnimation.rotateAnimation()
    }
    
    /**
     @name  sendBitcoinButtonTapped
     
     - parameter sender: AnyObject
     */
    @IBAction func sendBitcoinButtonTapped(_ sender: AnyObject) {
        
        forwardAddressTextField.resignFirstResponder()
        sendAmountTextField.resignFirstResponder()
        
        view.bounds.origin.y = 0
    }
    
    // MARK: - View Lifecycles
    /**
     @name  viewDidLoad
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareStatusBar()
        prepareAccountBalanceTitleLabel()
        prepareBitcoinImageViewTapGestureRecognizer()
        prepareBitcoinLogoImageViewShakeAnimation()
        prepareIndicatorAnimation()
        prepareStackViewShadow()
        preparePublicKeyTapGestureRecognizer()
        prepareRefreshShakeAnimation()
        prepareSendBitcoinButton()
        prepareForwardAddressTextField()
        prepareNSNotificationCenterObserversForKeyboard()
        
        getKeychainData()
    }
    
}

private extension WalletViewController {
    
    // MARK: - Preparations
    /**
     @name  prepareStatusBar
     */
    func prepareStatusBar() {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    /**
     @name  prepareAccountBalanceTitleLabel
     */
    func prepareAccountBalanceTitleLabel() {
        let attributedString = accountTitleBalanceLabel.attributedText as! NSMutableAttributedString
        attributedString.addAttribute(NSKernAttributeName, value: 1.0, range: NSMakeRange(0, attributedString.length))
    }
    
    /**
     @name  prepareBitcoinImageViewTapGestureRecognizer
     */
    func prepareBitcoinImageViewTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(shakeAnimation))
        bitcoinLogoImageView.addGestureRecognizer(tap)
    }
    
    /**
     @name  prepareBitcoinLogoImageViewShakeAnimation
     */
    func prepareBitcoinLogoImageViewShakeAnimation() {
        bitcoinLogoImageViewShakeAnimation = CustomAnimation(view: bitcoinLogoImageView, afterDelay: 0, startDirection: .left, repetitions: 6, maxRotation: 0.15, maxPosition: 20, duration: 0.15)
    }
    
    /**
     @name  prepareIndicatorAnimation
     */
    func prepareIndicatorAnimation() {
        indicatorButtonAnimation = CustomAnimation(view: indicatorButton, withDuration: 0.2)
    }
    
    /**
     @name  prepareStackViewShadow
     */
    func prepareStackViewShadow() {
        actionView.layer.masksToBounds = false
        actionView.layer.shadowOffset = CGSize(width: 3, height: 3)
        actionView.layer.shadowRadius = 10
        actionView.layer.shadowOpacity = 0.2
    }
    
    /**
     @name  preparePublicKeyTapGestureRecognizer
     */
    func preparePublicKeyTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(copyPublicKey))
        publicKeyLabel.isUserInteractionEnabled = true
        publicKeyLabel.addGestureRecognizer(tap)
    }
    
    /**
     @name  prepareRefreshShakeAnimation
     */
    func prepareRefreshShakeAnimation() {
        refreshRotateAnimation = CustomAnimation(view: refreshButton, afterDelay: 0, startDirection: .right, repetitions: 1, maxRotation: 1, maxPosition: 0, duration: 0.2)
    }
    
    /**
     @name  prepareSendBitcoinButton
     */
    func prepareSendBitcoinButton() {
        sendBitcoinButton.layer.cornerRadius = 5.0
    }
    
    /**
     @name  prepareForwardAddressTextField
     */
    func prepareForwardAddressTextField() {
        forwardAddressTextField.delegate = self
    }
    
    /**
     @name  getKeychainData
     */
    func getKeychainData() {
        var error: NSError?
        let data = WalletHelper.sharedInstance.getKeychainData(key: WalletHelperConstants.SeedCreationTime, error: &error)
        
        guard error == nil else {
            print(error)
            return
        }
        
        if let data = data {
            
            var mutableData = data
            
            let result: Int = mutableData.scanValue(start: 0, length: mutableData.count)
            let stringResult = String(result)
            
            
            print("Convert Data to Int: \(result)")
            print("Convert Int to String: \(stringResult)")

        }
    }
    
}
// MARK: - Helper Methods
extension WalletViewController {
    // Receive Button Tapped
    /**
     @name  hideSendFunctionality
     */
    func hideSendFunctionality() {
        sendAmountTextField.isHidden = true
        forwardAddressTextField.isHidden = true
        sendBitcoinButton.isHidden = true
    }
    
    /**
     @name  unhideReceiveFunctionality
     */
    func unhideReceiveFunctionality() {
        qrCodeImageView.isHidden = false
        publicKeyLabel.isHidden = false
        refreshButton.isHidden = false
    }
    
    // Send Button Tapped
    /**
     @name  hideReceiveFunctionality
     */
    func hideReceiveFunctionality() {
        qrCodeImageView.isHidden = true
        publicKeyLabel.isHidden = true
        refreshButton.isHidden = true
    }
    
    /**
     @name  unhideSendFunctionality
     */
    func unhideSendFunctionality() {
        sendAmountTextField.isHidden = false
        forwardAddressTextField.isHidden = false
        sendBitcoinButton.isHidden = false
    }
    
    /**
     @name  copyPublicKey
     */
    func copyPublicKey() {
        UIPasteboard.general.string = publicKeyLabel.text
        print("Public Key Copied")
    }
    
    /**
     @name  shakeAnimation
     */
    func shakeAnimation() {
        bitcoinLogoImageViewShakeAnimation.shakeAnimation()
    }
}

// MARK: - NSNotification Helper Methods
extension WalletViewController {
    /**
     @name  prepareNSNotificationCenterObserversForKeyboard
     */
    func prepareNSNotificationCenterObserversForKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    /**
     @name  keyboardWillShow
     
     - parameter notification: NSNotification
     */
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.bounds.origin.y == 0 {
                view.bounds.origin.y += keyboardSize.height
            }
        }
    }
    
    /**
     @name  keyboardWillHide
     
     - parameter notification: NSNotification
     */
    @objc func keyboardWillHide(_ notification: Notification) {
        view.bounds.origin.y = 0
    }
}

// MARK: - Shake Phone Animations
extension WalletViewController {
    /**
     @name  canBecomeFirstResponder
     
     - returns: Bool
     */
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    /**
     @name  motionEnded:withEvent
     
     - parameter motion: UIEventSubtype
     - parameter event:  UIEvent?
     */
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        
        mode = Mode(rawValue: abs(mode!.rawValue - 1))!
        
        switch mode! {
        case .normal:
            actionView.backgroundColor = UIColor.white
            break
        case .mix:
            actionView.backgroundColor = UIColor.offWhiteColor()
            break
        }
        
        bitcoinLogoImageViewShakeAnimation.shakeAnimation()
    }
}

// MARK: - Text Field Delegate Methods
extension WalletViewController: UITextFieldDelegate {
    /**
     @name  textFieldShouldReturn
     
     - parameter textField: UITextField
     
     - returns: Bool
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        if textField == sendAmountTextField {
            forwardAddressTextField.becomeFirstResponder()
        }
        return true
    }
    
    /**
     @name  touchesBegan:withEvent
     
     - parameter touches: Set<UITouch>
     - parameter event:   UIEvent?
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        actionView.endEditing(true)
    }
    
}


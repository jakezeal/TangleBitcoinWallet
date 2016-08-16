//
//  DisplayMasterKeyViewController.swift
//  Tangle
//
//  Created by Jake on 8/1/16.
//  Copyright © 2016 Jake. All rights reserved.
//

import UIKit

class GenerateMasterKeyViewController: UIViewController {
    
    // MARK: - Properties
    private weak var appDelegate: AppDelegate! = UIApplication.sharedApplication().delegate as! AppDelegate
    
    // MARK: - IBOutlets
    // TODO: Create a secure version of UILabel and use it for seedLabel, but make sure there's an accessibility work around
    @IBOutlet weak var mnemonicWordsLabel: UILabel!
    @IBOutlet weak var createWalletButton: UIButton!
    
    // MARK: - IBActions
    @IBAction func createWalletButtonTapped(sender: AnyObject) {
        print("Create Wallet Button Tapped -> Wallet View Controller \n")
        transitionToWalletViewController()
        createWalletButton.enabled = false
    }
    
    // MARK: - View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: Block screenshots and / or send alert to user in regards to risk
        prepareCreateWalletButton()
        prepareMnemonicWordsLabel()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // Don't leave the seed phrase laying around in memory any longer than necessary
        mnemonicWordsLabel.text = ""
    }
    
    // MARK: - Preparations
    func prepareCreateWalletButton() {
        createWalletButton.layer.cornerRadius = 5.0
    }
    
    func prepareMnemonicWordsLabel() {        
        mnemonicWordsLabel.text = WalletHelper.sharedInstance.generateRandomSeed()
    }
    
    
    // MARK: - Helper Methods
    func transitionToWalletViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let walletViewController = storyboard.instantiateViewControllerWithIdentifier("WalletViewController") as! WalletViewController
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.changeRootViewController(walletViewController)
    }
    
}

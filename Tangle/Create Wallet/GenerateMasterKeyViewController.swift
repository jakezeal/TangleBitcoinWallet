//
//  DisplayMasterKeyViewController.swift
//  Tangle
//
//  Created by Jake on 8/1/16.
//  Copyright © 2016 Jake. All rights reserved.
//

import UIKit

class GenerateMasterKeyViewController: UIViewController {
    
    private weak var appDelegate: AppDelegate! = UIApplication.sharedApplication().delegate as! AppDelegate
    
    // MARK: - IBOutlets
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
        prepareCreateWalletButton()
        createWallet()
    }
    
    // MARK: - Preparations
    func prepareCreateWalletButton() {
        createWalletButton.layer.cornerRadius = 5.0
    }
    
    func createWallet() {
        
        guard appDelegate.wallet == nil else { return }
        
        let seed = BTCRandomDataWithLength(32)
        appDelegate.wallet = Wallet(generateKeyInWalletWithEntropySeed: seed, andPassword: "")
    }
    
    // MARK: - Helper Methods
    func transitionToWalletViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let walletViewController = storyboard.instantiateViewControllerWithIdentifier("WalletViewController") as! WalletViewController
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.changeRootViewController(walletViewController)
    }
    
}

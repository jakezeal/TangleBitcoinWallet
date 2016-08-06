//
//  MasterKeyWarningViewController.swift
//  Tangle
//
//  Created by Jake on 8/3/16.
//  Copyright © 2016 Jake. All rights reserved.
//

import UIKit

class MasterKeyWarningViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var displayMasterKeyButton: UIButton!
    
    // MARK: - IBActions
    @IBAction func displayMasterKeyButtonTapped(sender: AnyObject) {
        print("Display Master Key Button Tapped -> Generate Master Key View Controller \n")
        transitionToGenerateMasterKeyViewController()
        displayMasterKeyButton.enabled = false
    }
    
    // MARK: - View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareDisplayMasterKeyButton()
    }
    
    // MARK: - Preparations
    func prepareDisplayMasterKeyButton() {
        displayMasterKeyButton.layer.cornerRadius = 5.0
    }
    
    // MARK: - Helper Methods
    func transitionToGenerateMasterKeyViewController() {
        let storyboard = UIStoryboard(name: "CreateWallet", bundle: nil)
        let generateMasterKeyViewController = storyboard.instantiateViewControllerWithIdentifier("GenerateMasterKeyViewController") as! GenerateMasterKeyViewController
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.changeRootViewController(generateMasterKeyViewController)
    }
}

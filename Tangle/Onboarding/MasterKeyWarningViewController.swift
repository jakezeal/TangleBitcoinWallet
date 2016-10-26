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
    /**
     @name  displayMasterKeyButtonTapped
     
     - parameter sender: AnyObject
     */
    @IBAction func displayMasterKeyButtonTapped(_ sender: AnyObject) {
        print("Display Master Key Button Tapped -> Generate Master Key View Controller \n")
        transitionToGenerateMasterKeyViewController()
        displayMasterKeyButton.isEnabled = false
    }
    
    // MARK: - View Lifecycles
    /**
     @name  viewDidLoad
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareDisplayMasterKeyButton()
    }
    
    // MARK: - Preparations
    /**
     @name  prepareDisplayMasterKeyButton
     */
    func prepareDisplayMasterKeyButton() {
        displayMasterKeyButton.layer.cornerRadius = 5.0
    }
    
    // MARK: - Helper Methods
    /**
     @name  transitionToGenerateMasterKeyViewController
     */
    func transitionToGenerateMasterKeyViewController() {
        let storyboard = UIStoryboard(name: "CreateWallet", bundle: nil)
        let generateMasterKeyViewController = storyboard.instantiateViewController(withIdentifier: "GenerateMasterKeyViewController") as! GenerateMasterKeyViewController
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.changeRootViewController(generateMasterKeyViewController)
    }
}

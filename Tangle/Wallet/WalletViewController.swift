//
//  WalletViewController.swift
//  Tangle
//
//  Created by Jake on 7/30/16.
//  Copyright © 2016 Jake. All rights reserved.
//

import UIKit

class WalletViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var accountTitleBalanceLabel: UILabel!

    // MARK: - View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareAccountBalanceTitleLabel()
        
    }
    
    // MARK: - Preparations
    func prepareAccountBalanceTitleLabel() {
        let attributedString = accountTitleBalanceLabel.attributedText as! NSMutableAttributedString
        attributedString.addAttribute(NSKernAttributeName, value: 1.0, range: NSMakeRange(0, attributedString.length))
    }

}


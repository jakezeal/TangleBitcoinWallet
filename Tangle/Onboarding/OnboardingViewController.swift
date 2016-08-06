//
//  OnboardingViewController.swift
//  Tangle
//
//  Created by Jake on 7/28/16.
//  Copyright © 2016 Jake. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    // MARK: - Properties
    var titleText: String = ""
    var summary: String = ""
    var imageName: String = ""
    var isButtonHidden: Bool = true
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var generateKeysButton: UIButton!
    
    // MARK: - IBActions
    @IBAction func generateKeysButtonTapped(sender: AnyObject) {
        print("Generate Keys Button Tapped -> Master Key Warning View Controller \n")
        generateKeysButton.enabled = false
    }
    
    // MARK: - View Lifecycles
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        prepareTitleLabel()
        prepareDescriptionLabel()
        prepareImageView()
        prepareGenerateKeysButton()
    }
    
    // MARK: - Preparations
    func prepareTitleLabel() {
        titleLabel.text = titleText
    }
    
    func prepareDescriptionLabel() {
        descriptionLabel.text = summary
    }
    
    func prepareImageView() {
        imageView.image = UIImage(named: imageName)
    }
    
    func prepareGenerateKeysButton() {
        generateKeysButton.layer.cornerRadius = 5.0
        generateKeysButton.hidden = isButtonHidden
    }
}

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
    /**
     @name  generateKeysButtonTapped
     
     - parameter sender: AnyObject
     */
    @IBAction func generateKeysButtonTapped(_ sender: AnyObject) {
        print("Generate Keys Button Tapped -> Master Key Warning View Controller \n")
        generateKeysButton.isEnabled = false
    }
    
    // MARK: - View Lifecycles
    /**
     @name  viewWillAppear
     
     - parameter animated: Bool
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareTitleLabel()
        prepareDescriptionLabel()
        prepareImageView()
        prepareGenerateKeysButton()
    }
    
    // MARK: - Preparations
    /**
     @name  prepareTitleLabel
     */
    func prepareTitleLabel() {
        titleLabel.text = titleText
    }
    
    /**
     @name  prepareDescriptionLabel
     */
    func prepareDescriptionLabel() {
        descriptionLabel.text = summary
    }
    
    /**
     @name  prepareImageView
     */
    func prepareImageView() {
        imageView.image = UIImage(named: imageName)
    }
    
    /**
     @name  prepareGenerateKeysButton
     */
    func prepareGenerateKeysButton() {
        generateKeysButton.layer.cornerRadius = 5.0
        generateKeysButton.isHidden = isButtonHidden
    }
}

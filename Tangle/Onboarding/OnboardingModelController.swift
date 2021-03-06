//
//  OnboardingModelController.swift
//  Tangle
//
//  Created by Jake on 7/28/16.
//  Copyright © 2016 Jake. All rights reserved.
//

import UIKit


class OnboardingModelController: NSObject {
    
    // MARK: - Properties
    var titles: [String]
    var summaries: [String]
    var imageNames: [String]
    
    // MARK: - Initializers
    override init() {
        titles = ["Welcome",
                  "Receive",
                  "Send",
                  "Tangle"]
        
        summaries = ["Welcome to Tangle!",
                     "Receive Bitcoins.",
                     "Send Bitcoins.",
                     "Tangle it up!"]
        
        imageNames = ["bitcoin",
                      "money",
                      "lock",
                      "keyring"]
        super.init()
    }
}

extension OnboardingModelController {
    // MARK: - Helper Methods
    /**
     @name  viewControllerAtIndex
     
     - parameter index:      Int
     - parameter storyboard: UIStoryboard
     
     - returns: OnboardingViewController?
     */
    func viewControllerAtIndex(_ index: Int, storyboard: UIStoryboard) -> OnboardingViewController? {
        // Return the data view controller for the given index.
        if (titles.count == 0) || (index >= titles.count) {
            return nil
        }
        
        // Create a new view controller and pass suitable data.
        let onboardingViewController = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
        onboardingViewController.titleText = titles[index]
        onboardingViewController.summary = summaries[index]
        onboardingViewController.imageName = imageNames[index]
        
        // If user is on the last onboarding view controller
        if index == titles.count - 1 {
            onboardingViewController.isButtonHidden = false
        }
        
        return onboardingViewController
    }
    
    /**
     @name  indexOfViewController
     
     - parameter viewController: OnboardingViewController
     
     - returns: Int
     */
    func indexOfViewController(_ viewController: OnboardingViewController) -> Int {
        // Return the index of the given onboarding view controller.
        return titles.index(of: viewController.titleText) ?? NSNotFound
    }
}

extension OnboardingModelController: UIPageViewControllerDataSource {
    // MARK: - Page View Controller Data Source
    /**
     @name  pageViewController:viewControllerBeforeViewController
     
     - parameter pageViewController: UIPageViewController
     - parameter viewController:     UIViewController
     
     - returns: UIViewController?
     */
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! OnboardingViewController)
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }
    
    /**
     @name  pageViewController:viewControllerAfterViewController
     
     - parameter pageViewController: UIPageViewController
     - parameter viewController:     UIViewController
     
     - returns: UIViewController?
     */
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        // TODO: Animate Logo Image View to center and hide Skip Button
        
        var index = self.indexOfViewController(viewController as! OnboardingViewController)
        
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        
        if index == self.titles.count {
            return nil
        }
        
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }

}


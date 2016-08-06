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
    func viewControllerAtIndex(index: Int, storyboard: UIStoryboard) -> OnboardingViewController? {
        // Return the data view controller for the given index.
        if (titles.count == 0) || (index >= titles.count) {
            return nil
        }
        
        // Create a new view controller and pass suitable data.
        let onboardingViewController = storyboard.instantiateViewControllerWithIdentifier("OnboardingViewController") as! OnboardingViewController
        onboardingViewController.titleText = titles[index]
        onboardingViewController.summary = summaries[index]
        onboardingViewController.imageName = imageNames[index]
        
        // If user is on the last onboarding view controller
        if index == titles.count - 1 {
            onboardingViewController.isButtonHidden = false
        }
        
        return onboardingViewController
    }
    
    func indexOfViewController(viewController: OnboardingViewController) -> Int {
        // Return the index of the given onboarding view controller.
        return titles.indexOf(viewController.titleText) ?? NSNotFound
    }
}

extension OnboardingModelController: UIPageViewControllerDataSource {
    // MARK: - Page View Controller Data Source
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! OnboardingViewController)
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
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


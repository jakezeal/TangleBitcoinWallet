//
//  RootOnboardingViewController.swift
//  Tangle
//
//  Created by Jake on 7/28/16.
//  Copyright © 2016 Jake. All rights reserved.
//

import UIKit

class RootOnboardingViewController: UIViewController {
    
    // MARK: - Properties
    lazy var onboardingModelController = OnboardingModelController()
    
    var pageViewController: UIPageViewController?
    
    // MARK: - IBOutlets
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var skipButton: UIButton!
    
    // MARK: - IBActions
    /**
     @name  skipButtonTapped
     
     - parameter sender: AnyObject
     */
    @IBAction func skipButtonTapped(_ sender: AnyObject) {
        //TODO: Skip Onboarding
        print("Skip Button Tapped")
    }
    
    // MARK: - View Lifecycles
    /**
     @name  viewDidLoad
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        preparePageViewController()
        prepareLogoImageView()
        prepareSkipButton()
    }
}

extension RootOnboardingViewController {
    // MARK: - Preparations
    /**
     @name  prepareLogoImageView
     */
    func prepareLogoImageView() {
        logoImageView.layer.zPosition = 100
    }
    
    /**
     @name  prepareSkipButton
     */
    func prepareSkipButton() {
        skipButton.layer.zPosition = 100
        view.bringSubview(toFront: skipButton)
        
    }
    
    /**
     @name  preparePageViewController
     */
    func preparePageViewController() {
        // Configure the page view controller and add it as a child view controller.
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController!.delegate = self
        
        let startViewController: OnboardingViewController = onboardingModelController.viewControllerAtIndex(0, storyboard: storyboard!)!
        let viewControllers = [startViewController]
        
        pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
        
        pageViewController!.dataSource = onboardingModelController
        
        addChildViewController(self.pageViewController!)
        view.addSubview(self.pageViewController!.view)
        
        // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
        var pageViewRect = self.view.bounds
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            pageViewRect = pageViewRect.insetBy(dx: 40.0, dy: 40.0)
        }
        
        self.pageViewController!.view.frame = pageViewRect
        
        self.pageViewController!.didMove(toParentViewController: self)
    }
}

extension RootOnboardingViewController: UIPageViewControllerDelegate {
    // MARK: - Page View Controller Delegate Methods
    /**
     @name  pageViewController:spineLocationForInterfaceOrientation
     
     - parameter pageViewController: UIPageViewController
     - parameter orientation:        UIInterfaceOrientation
     
     - returns: UIPageViewControllerSpineLocation
     */
    func pageViewController(_ pageViewController: UIPageViewController, spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {
        
        // Portrait Orientation
        if (orientation == .portrait) || (orientation == .portraitUpsideDown) || (UIDevice.current.userInterfaceIdiom == .phone) {
            // In portrait orientation or on iPhone: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to true, so set it to false here.
            let currentViewController = self.pageViewController!.viewControllers![0]
            let viewControllers = [currentViewController]
            self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: true, completion: {done in })
            
            self.pageViewController!.isDoubleSided = false
            return .min
        }
        
        // In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.
        let currentViewController = self.pageViewController!.viewControllers![0] as! OnboardingViewController
        var viewControllers: [UIViewController]
        
        let indexOfCurrentViewController = onboardingModelController.indexOfViewController(currentViewController)
        
        if (indexOfCurrentViewController == 0) || (indexOfCurrentViewController % 2 == 0) {
            let nextViewController = onboardingModelController.pageViewController(self.pageViewController!, viewControllerAfter: currentViewController)
            viewControllers = [currentViewController, nextViewController!]
        } else {
            let previousViewController = onboardingModelController.pageViewController(self.pageViewController!, viewControllerBefore: currentViewController)
            viewControllers = [previousViewController!, currentViewController]
        }
        
        self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
        
        return .mid
    }
    
}



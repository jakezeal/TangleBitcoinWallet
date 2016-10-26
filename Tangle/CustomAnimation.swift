//
//  CustomAnimation.swift
//  Inverse
//
//  Created by Jake on 7/23/16.
//  Copyright © 2016 BitInverse. All rights reserved.
//

import UIKit

// MARK: - Enumerations
enum Direction: Int {
    case left
    case right
}

enum State {
    case first
    case middle
    case final
}

final class CustomAnimation {
    
    // MARK: - Properties
    var view: UIView!
    var delay: Double!
    var repetitions: Int!
    var maxRotation: CGFloat!
    var maxPosition: CGFloat!
    var duration: Double!
    
    var running = false
    
    var direction: Direction = .left
    
    var state: State = .first
    
    var counter = 0
    
    // MARK: - Initializers
    /**
     @name view:afterDelay:startDirection:
     
     - parameter view:        UIView
     - parameter delay:       Double
     - parameter direction:   Direction
     - parameter repetitions: Int
     - parameter maxRotation: CGFloat
     - parameter maxPosition: CGFloat
     - parameter duration:    Double
     
     - returns: CustomAnimation
     */
    init(view: UIView, afterDelay delay: Double, startDirection direction: Direction, repetitions: Int, maxRotation: CGFloat, maxPosition: CGFloat, duration: Double) {
        self.view = view
        self.delay = delay
        self.direction = direction
        self.repetitions = repetitions
        self.maxRotation = maxRotation
        self.maxPosition = maxPosition
        self.duration = duration
    }
    
    /**
     @name  view:withDuration
     
     - parameter view:     UIView
     - parameter duration: Double
     
     - returns: CustomAnimation
     */
    init(view: UIView, withDuration duration: Double) {
        self.view = view
        self.duration = duration
    }
    
    // MARK: - Animation Methods
    /**
     @name  animateIndicatorToReceive
     */
    func animateIndicatorToReceive() {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: {
            
            // Set Position
            if self.view.frame.origin.x == self.view.frame.width {
                self.view.frame.origin.x -= self.view.frame.width
            }
            
            }, completion: nil)
    }
    
    /**
     @name  animateIndicatorToSend
     */
    func animateIndicatorToSend() {
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: {
            
            // Set Position
            self.view.frame.origin.x = self.view.frame.width
            
            }, completion: nil)
    }
    
    /**
     @name  shakeAnimation
     */
    func shakeAnimation() {
        
        guard !running else { return }
        
        running = true
        
        let factor = CGFloat(direction.rawValue * 2 - 1)
        
        var position = maxPosition
        var rotation = maxRotation
        
        switch self.state {
        case .first:
            position = maxPosition / 2
            break
        case .middle:
            break
        case .final:
            rotation = 0
            position = maxPosition / 2
            break
        }
        
        UIView.animate(withDuration: self.duration,
                                   delay: self.delay,
                                   options: UIViewAnimationOptions(),
                                   animations: {
                                    
                                    // Position
                                    let x = self.view.center.x + position! * factor
                                    self.view.center.x = x
                                    
                                    // Rotation
                                    self.view.transform = CGAffineTransform(rotationAngle: rotation! * factor)
                                    
        }) { (completed: Bool) in
            self.finishShakeAnimation()
        }
        
    }
    
    /**
     @name  finishShakeAnimation
     */
    func finishShakeAnimation() {
        running = false
        
        direction = Direction(rawValue: abs(self.direction.rawValue - 1))!
        
        if counter < self.repetitions {
            state = .middle
            shakeAnimation()
            counter += 1
            
        } else if counter == repetitions {
            state = .final
            shakeAnimation()
            counter += 1
            
        } else {
            state = .first
            counter = 0
            
            if repetitions % 2 == 0 {
                direction = Direction(rawValue: abs(self.direction.rawValue - 1))!
            }
        }
        
    }
    
    /**
     @name  rotateAnimation
     */
    func rotateAnimation() {
        let factor = CGFloat(direction.rawValue * 2 - 1)
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        
        // Rotate to the Right
        rotateAnimation.toValue = CGFloat(M_PI * Double(maxRotation) * 2.0)
        
        // Rotate to the Left
        //        rotateAnimation.toValue = CGFloat(M_PI * 4.0 * Double(factor))
        
        rotateAnimation.duration = self.duration
        self.view.layer.add(rotateAnimation, forKey: nil)
        
        self.maxRotation = self.maxRotation * factor
    }
}

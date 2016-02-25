//
//  ViewController.swift
//  SmileyFaces
//
//  Created by Andre Oriani on 2/24/16.
//  Copyright © 2016 Orion. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var parentView: UIView!
    @IBOutlet weak var trayView: UIView!
    
    var startingPoint: CGPoint?
    private var openTrayPos:CGPoint?
    private var closedTrayPos:CGPoint?
    private var open = true
    
    var targetView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        openTrayPos = trayView.center
        closedTrayPos = CGPointMake(trayView.center.x, openTrayPos!.y + CGRectGetHeight(trayView.bounds) - 40)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTrayPanGesture(gesture: UIPanGestureRecognizer) {
        // Absolute (x,y) coordinates in parent view (parentView should be
        // the parent view of the tray)
        let point = gesture.locationInView(parentView)
        let translation = gesture.translationInView(parentView)
        let velocity = gesture.velocityInView(parentView)
        
        if gesture.state == UIGestureRecognizerState.Began {
            print("Gesture began at: \(point)")
            startingPoint = trayView.center
        } else if gesture.state == UIGestureRecognizerState.Changed {
            print("Gesture changed at: \(point)")
            trayView.center = CGPoint(x: startingPoint!.x, y: startingPoint!.y + translation.y)
        } else if gesture.state == UIGestureRecognizerState.Ended {
            toggleTray(velocity.y > 0)
        }
    }

    func toggleTray(willClose: Bool) {
        if willClose {
            UIView.animateWithDuration(0.300, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.5, options: [], animations: {
                    self.trayView.center = self.closedTrayPos!
                    self.open = false
                }, completion: nil)
        } else {
            UIView.animateWithDuration(0.300, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.5, options: [], animations: {
                    self.trayView.center = self.openTrayPos!
                    self.open = true
                }, completion: nil)
        }
    }
    @IBAction func onDownArrow(sender: AnyObject) {
        toggleTray(open)
    }
    
    @IBAction func onFacePanRecognizer(gesture: UIPanGestureRecognizer) {
        commonFacePan(gesture, original: true)
    }
    
    func onCopyFacePanRecognizer(gesture: UIPanGestureRecognizer) {
        commonFacePan(gesture, original: false)
    }
    
    func commonFacePan(gesture: UIPanGestureRecognizer, original: Bool) {
        let location = gesture.locationInView(parentView)
        
        if gesture.state == UIGestureRecognizerState.Began {
            
            if original {
                // Gesture recognizers know the view they are attached to
                let imageView = gesture.view as! UIImageView
                
                // Create a new image view that has the same image as the one currently panning
                targetView = UIImageView(image: imageView.image)
                targetView.center = imageView.center
                
                // Add the new face to the tray's parent view.
                view.addSubview(targetView)
                
                targetView.center.y += trayView.frame.origin.y
            } else {
                targetView = gesture.view as! UIImageView
            }
                
        } else if gesture.state == UIGestureRecognizerState.Changed {
            // Move it
            targetView.center = location
        } else if gesture.state == UIGestureRecognizerState.Ended {
            if original {
                let panGesture = UIPanGestureRecognizer(target: self, action: "onCopyFacePanRecognizer:")
                targetView.addGestureRecognizer(panGesture)
                targetView.userInteractionEnabled = true
            }
        }

    }
}


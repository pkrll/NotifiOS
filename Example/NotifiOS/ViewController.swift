//
//  ViewController.swift
//  NotifiOS
//
//  Created by Ardalan Samimi on 05/22/2016.
//  Copyright (c) 2016 Ardalan Samimi. All rights reserved.
//
import UIKit
import NotifiOS

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = UIColor.groupTableViewBackgroundColor()
    
    let buttonText = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 44))
    buttonText.backgroundColor = UIColor.whiteColor()
    buttonText.setTitle("Notification Demo: Text", forState: .Normal)
    buttonText.setTitleColor(UIColor.blackColor(), forState: .Normal)
    buttonText.layer.cornerRadius = 5
    buttonText.addTarget(self, action: #selector(self.buttonTapped(_:)), forControlEvents: .TouchUpInside)

    let buttonImage = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 44))
    buttonImage.backgroundColor = UIColor.whiteColor()
    buttonImage.setTitle("Notification Demo: Image & Text", forState: .Normal)
    buttonImage.setTitleColor(UIColor.blackColor(), forState: .Normal)
    buttonImage.layer.cornerRadius = 5
    buttonImage.addTarget(self, action: #selector(self.buttonWithImageTapped(_:)), forControlEvents: .TouchUpInside)

    let buttonLoading = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 44))
    buttonLoading.backgroundColor = UIColor.whiteColor()
    buttonLoading.setTitle("Notification Demo: Spinner", forState: .Normal)
    buttonLoading.setTitleColor(UIColor.blackColor(), forState: .Normal)
    buttonLoading.layer.cornerRadius = 5
    buttonLoading.addTarget(self, action: #selector(self.buttonWithActivityIndicator(_:)), forControlEvents: .TouchUpInside)
    
    self.view.addSubview(buttonText)
    self.view.addSubview(buttonImage)
    self.view.addSubview(buttonLoading)
    
    buttonText.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint(item: buttonText, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0).active = true
    NSLayoutConstraint(item: buttonText, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 100).active = true
    
    buttonImage.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint(item: buttonImage, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0).active = true
    NSLayoutConstraint(item: buttonImage, attribute: .Top, relatedBy: .Equal, toItem: buttonText, attribute: .Bottom, multiplier: 1, constant: 10).active = true
    
    buttonLoading.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint(item: buttonLoading, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0).active = true
    NSLayoutConstraint(item: buttonLoading, attribute: .Top, relatedBy: .Equal, toItem: buttonImage, attribute: .Bottom, multiplier: 1, constant: 10).active = true
  }
  
  func buttonTapped(sender: AnyObject?) {
    let view = NotifiOS(withMaxDimensions: CGSize(width: 250, height: 250))
    view.removeOnTouch = true
    view.delayFadeOut = 1.5
    view.afterFadeOut = {
      print("Text Demo Done!")
    }

    view.setTitle("Pure Text Notification!")
    self.view.addSubview(view)
    
    view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint(item: view, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0).active = true
    NSLayoutConstraint(item: view, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0).active = true
  }
  
  func buttonWithImageTapped(sender: AnyObject?) {
    let view = NotifiOS(withMaxDimensions: CGSize(width: 250, height: 250))
    view.removeOnTouch = true
    view.delayFadeOut = 1.5
    view.afterFadeOut = {
      print("Image & Text Done!")
    }
    
    view.setImage(UIImage(named: "Checkbox")!, withSize: CGSize(width: 65, height: 70))
    view.imageView?.tintColor = UIColor.whiteColor()
    view.setTitle("Text And Image Notifications Are The Best!")
    self.view.addSubview(view)
    
    view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint(item: view, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0).active = true
    NSLayoutConstraint(item: view, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0).active = true
  }

  func buttonWithActivityIndicator(sender: AnyObject?) {
    let view = NotifiOS(withMaxDimensions: CGSize(width: 250, height: 250))
    view.removeOnTouch = true
    view.delayFadeOut = 0
    view.afterFadeOut = {
      print("Spinner Demo Done!")
    }
    
    view.setImage(UIImage(named: "Checkbox")!, withSize: CGSize(width: 65, height: 70))
    view.imageView?.tintColor = UIColor.whiteColor()
    view.loadActivityIndicator()
    view.setTitle("Loading...")
    self.view.addSubview(view)
    
    view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint(item: view, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0).active = true
    NSLayoutConstraint(item: view, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0).active = true
    
    let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC))
    dispatch_after(delay, dispatch_get_main_queue()) {
      view.stopActivityIndicator()
      view.setImage(UIImage(named: "Checkbox")!, withSize: CGSize(width: 65, height: 75))
      view.setTitle("Something loaded!")
      view.delayFadeOut = 1
      view.beginFadeOut()
    }
    
  }
  
}


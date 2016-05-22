//
//  NotifiOS.swift
//
//  Created by Ardalan Samimi on 22/05/16.
//
//

public class NotifiOS: UIView {
  
  /**
   *  The title label.
   *  - Note: Use setTitle(_:) method to set the title label's string text.
   *  - Note: The title label will be positioned below the image view, if set.
   */
  public private(set) var titleLabel: UILabel?
  /**
   *  The image view of the notification view.
   *  - Note: Use setImage(_:) to set the image.
   *  - Note: The image will be hidden if the activity indicator is on.
   */
  public private(set) var imageView: UIImageView?
  /**
   *  The image that is displayed by the image view.
   */
  public private(set) var image: UIImage?
  /**
   *  An activity indicator.
   *  - Note: Use loadIndicator(_:) method to activate the indicator.
   *  - Note: The activity indicator will hide the image view while active.
   */
  public private(set) var activityIndicator: UIActivityIndicatorView?
  /**
   *  The maximum dimensions of the view.
   *
   *  The view will automatically size itself. The maxDimension property determines the maximum height och width of the view.
   *  - Note: Use the init(withMaxDimension:) method to set the maximum dimensions of the view.
   */
  public private(set) var maxDimension: CGSize!
  /**
   *  The notification view will position itself at the center of its superview. Use this property to set the point at which the view is offset from the superviews origin.
   */
  public var viewOffset: CGPoint?
  /**
   *  The duration of the fadeout.
   *  - Note: Defaults to 2.
   */
  public var fadeDuration: NSTimeInterval = 2
  /**
   *  The number of seconds the view should be displayed.
   *  - Note: If set, the view will automatically start the fadeout after the provided number of seconds.
   *  - Note: The default value is 1.
   */
  public var delayFadeOut: Double = 1
  /**
   *  The callback that will be fired after the fadeout has finished.
   */
  public var afterFadeOut: (() -> Void)?
  /**
   *  If true, the view will start the fadeout process when the user clicks on it.
   *
   *  Use the onTouch property to set a callback for touch events.
   *  - Note: Defaults to false.
   */
  public var removeOnTouch: Bool = false
  
  public func configureView() {
    self.backgroundColor = UIColor.blackColor()
    self.alpha = 0.85
    self.layer.cornerRadius = 5
  }
  
  convenience public init(withMaxDimensions dimensions: CGSize) {
    let w = (dimensions.width < 200) ? dimensions.width : 200
    let h = (dimensions.height < 100) ? dimensions.height : 100
    let frame = CGRect(x: 0, y: 0, width: w, height: h)
    self.init(frame: frame)
    self.maxDimension = dimensions
  }
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    self.maxDimension = CGSize(width: frame.width, height: frame.height)
    self.configureView()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if self.removeOnTouch {
      // Stops the animation immediately and removes the view.
      self.layer.removeAllAnimations()
      self.removeFromSuperview()
    }
  }
  
  override public func willMoveToSuperview(newSuperview: UIView?) {
    self.updateWidth()
  }
  
  override public func didMoveToSuperview() {
    if let superview = self.superview {
      self.translatesAutoresizingMaskIntoConstraints = false
      let offsetX = (self.viewOffset == nil) ? 0 : self.viewOffset!.x
      let offsetY = (self.viewOffset == nil) ? 0 : self.viewOffset!.y
      
      NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: superview, attribute: .CenterX, multiplier: 1, constant: offsetX).active = true
      NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: superview, attribute: .CenterY, multiplier: 1, constant: offsetY).active = true
    }
    
    if let imageView = self.imageView {
      imageView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint(item: imageView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0).active = true
      NSLayoutConstraint(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 5).active = true
      NSLayoutConstraint(item: imageView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: imageView.frame.size.width).active = true
      NSLayoutConstraint(item: imageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: imageView.frame.size.width).active = true
    }
    
    if let label = self.titleLabel {
      label.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint(item: label, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .LeadingMargin, multiplier: 1, constant: 5).active = true
      NSLayoutConstraint(item: label, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .BottomMargin, multiplier: 1, constant: -5).active = true
      NSLayoutConstraint(item: label, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .TrailingMargin, multiplier: 1, constant: -5).active = true
      
      if let imageView = self.imageView {
        NSLayoutConstraint(item: label, attribute: .Top, relatedBy: .Equal, toItem: imageView, attribute: .Bottom, multiplier: 1, constant: 2).active = true
      } else {
        NSLayoutConstraint(item: label, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 10).active = true
      }
    }
    
    if self.delayFadeOut > 0 {
      self.fadeOut(self.fadeDuration, completion: self.afterFadeOut)
    }
  }
  /**
   *  Start a timer for when to destroy itself.
   */
  public func beginFadeOut() {
    self.fadeOut(self.fadeDuration, completion: self.afterFadeOut)
  }
  /**
   *  Fade out method.
   *  - Parameters:
   *    - duration: The total duration of the fade out, measured in seconds. If you specify a negative value or 0, the changes are made without animating them.
   *    - completion: A block object to be executed when the animation sequence ends. This block has no return value and takes a single Boolean argument that indicates whether or not the animations actually finished before the completion handler was called. If the duration of the animation is 0, this block is performed at the beginning of the next run loop cycle. This parameter may be nil.
   */
  private func fadeOut(duration: NSTimeInterval, completion: (() -> Void)?) {
    // The fade out will only go to 0.001 before removing. This allows for touch events to work.
    UIView.animateWithDuration(duration, delay: self.delayFadeOut, options: [.AllowUserInteraction], animations: { self.alpha = 0.1 }) { (_: Bool) in
      self.removeFromSuperview()
      completion?()
    }
  }
  
  public func loadActivityIndicator(withSize: CGSize? = nil) {
    if self.activityIndicator == nil {
      self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
      self.activityIndicator?.hidesWhenStopped
      if self.imageView == nil {
        let size = (withSize == nil) ? CGSize(width: self.activityIndicator!.frame.width, height: self.activityIndicator!.frame.height) : withSize!
        
        self.setImage(UIImage(), withSize: size)
      } else {
        self.imageView?.image = nil
      }
      
      let size = withSize ?? CGSize(width: self.imageView?.frame.width ?? 0, height: self.imageView?.frame.height ?? 0)
      
      self.activityIndicator!.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
      self.imageView?.addSubview(self.activityIndicator!)
      self.activityIndicator!.contentMode = .Center
      self.imageView?.contentMode = .Center
    }
    
    self.activityIndicator?.startAnimating()
  }
  
  public func stopActivityIndicator() {
    self.activityIndicator?.stopAnimating()
    self.activityIndicator?.removeFromSuperview()
    self.activityIndicator = nil
  }
  
  public func setImage(image: UIImage, withSize size: CGSize) {
    if self.imageView == nil {
      
      var frame = CGRectZero
      
      frame.origin.y = 5
      frame.origin.x = 0
      if size.width > self.maxDimension.width {
        frame.size.width = self.maxDimension.width
      } else {
        frame.size.width = size.width
      }
      
      if size.height > self.maxDimension.height {
        frame.size.height = self.maxDimension.height
      } else {
        frame.size.height = size.height
      }
      
      self.imageView = UIImageView(frame: frame)
      self.addSubview(self.imageView!)
      self.updateHeight()
    }
    
    self.image = image
    self.imageView?.image = self.image
    self.imageView?.contentMode = .ScaleAspectFit
  }
  
  public func setTitle(title: String) {
    if self.titleLabel == nil {
      let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
      self.titleLabel = UILabel(frame: frame)
      self.addSubview(self.titleLabel!)
      self.updateHeight()
    }
    
    self.titleLabel?.numberOfLines = 0
    self.titleLabel?.preferredMaxLayoutWidth = self.maxDimension.width
    self.titleLabel?.textColor = UIColor.whiteColor()
    self.titleLabel?.textAlignment = .Center
    self.titleLabel?.text = title
  }
  /**
   *  Adjusts the view's frame to fit its subviews
   */
  private func updateHeight() {
    var height: CGFloat = 0
    for view in self.subviews {
      height += view.frame.height
    }
    
    if height > self.frame.height {
      if height > self.maxDimension.height {
        height = self.maxDimension.height
      }
    }
    
    self.frame.size.height = height
  }
  
  private func updateWidth() {
    var width: CGFloat = 0
    for view in self.subviews {
      if view.frame.width > width {
        width = view.frame.width
      }
    }
    
    if width > self.maxDimension.width {
      width = self.maxDimension.width
    }
    
    self.frame.size.width = width
  }

  
}
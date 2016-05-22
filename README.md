# NotifiOS

[![CI Status](http://img.shields.io/travis/Ardalan Samimi/NotifiOS.svg?style=flat)](https://travis-ci.org/Ardalan Samimi/NotifiOS)
[![Version](https://img.shields.io/cocoapods/v/NotifiOS.svg?style=flat)](http://cocoapods.org/pods/NotifiOS)
[![License](https://img.shields.io/cocoapods/l/NotifiOS.svg?style=flat)](http://cocoapods.org/pods/NotifiOS)
[![Platform](https://img.shields.io/cocoapods/p/NotifiOS.svg?style=flat)](http://cocoapods.org/pods/NotifiOS)

## Overview

Create user notifications with NotifiOS, a very small and easy to use Swift library (subclassing UVIew).   

<img src="https://raw.githubusercontent.com/pkrll/NotifiOS/master/screenshot.png" width="400">

## Requirements
* iOS 8

## Install with CocoaPods

NotifiOS is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "NotifiOS"
```

## Usage
It is recommended that you instantiate NotifiOS with the convenience initializer init(withMaxDimensions:) where you input the maximum dimensions of the view, as it will automatically adjusts itself depending on the content. The max dimensions property will make sure it does not grow over a certain size.
```swift
let view = NotifiOS(withMaxDimensions: CGSize(width: 250, height: 250))
```

NotifiOS basically consist of two subviews: A text label and an Image View. To set the image of the view, use the setImage(_:, withSize:) method, where withSize should be provided as the preferred size of the image. Set the title with the setTitle(_:) method.
```swift
let image = UIImage(named: "SomeImage")
view.setImage(image, withSize: CGSize(width: 65, height: 70))
view.setTitle("Some Title!")
```


NotifiOS also provides an activity indicator. Note: The spinner will hide the image when active.
```swift
view.loadActivityIndicator()
view.setTitle("Loading...")
view.delayFadeOut = 0 // To make sure the view will not go away
view.removeOnTouch = false

// Change the image after the loading is done:
let image = UIImage(named: "SomeImage")
view.setImage(image, withSize: CGSize(width: 65, height: 70))
view.setTitle("Did Load!")
view.beginFadeOut()
```

If not configured otherwise, NotifiOS will begin fading out 1 second after the view has been added as a subview (for configurations, see below).
```swift
someSuperView.addSubview(view)
```

### Configurations
Customize the NotifiOS experience.
```swift
view.fadeDuration = 5 // The duration of the fade.
view.delayFadeOut = 5 // The number of seconds the view should be displayed. If set to 0, the view will stay until the beginFadeout() method is called.
view.removeOnTouch = true // If true, the view will start the fadeout process when the user taps it.
view.afterTouch = {
  // The callback that will be fired after the fadeout has finished.
}
```

You can also customize the title, image view and activity indicator elements.


## Example

An example project is included with this repo. To run the example project, clone the repo, and run pod install from the Example directory first.

## Author

Ardalan Samimi, ardalan@saturnfive.se

## License

NotifiOS is available under the MIT license. See the LICENSE file for more info.

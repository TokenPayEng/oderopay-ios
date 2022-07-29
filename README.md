# OderoPay

OderoPay is a Swift Package that lets you integrate your iOS application to the Odero Payment Ecosystem.

## Installation

In Xcode open `File` => `Add Packages...` => enter this Github repository.

## Usage

Add `View` to your .storyboard file, place it where you would like payment button to appear. In the
IdentityInspector select `OderoButtonView` class for your newly added `View`. Connect IBOutlet
to the related ViewController class.
 
```swift
    @IBOutlet weak var oderoPayButtonView: OderoPayButtonView!
```
In order to be able to navigate to the Payment Page you need to pass `NavigationController` as a parameter
to the initNavigationController function.

```swift
    @IBOutlet weak var oderoPayButtonView: OderoPayButtonView! {
        didSet {
            oderoPayButtonView.initNavigationController(named: self.navigationController!)
        }
    }
```

## Functionality and Customizability

Adding navigation controller to the OderoPay button.

Function:

`oderoPayButtonView.initNavigationController(named: UINavigationController)`

Example:

```swift
    oderoPayButtonView.initNavigationController(named: self.navigationController!)
```

Changing color of the OderoPay button from white to black and reverse.

Function:

`oderoPayButtonView.changeDefaultColor(fromWhiteToBlack: Bool)`

Example:

```swift
    oderoPayButtonView.changeDefaultColor(fromWhiteToBlack: true)
```

Adding outline of any color to the OderoPay button.

Function:

`oderoPayButtonView.addOderoPayButtonOutline(colored: UIColor)`

Example:

```swift
    oderoPayButtonView.addOderoPayButtonOutline(colored: .black)
```

Removing outline from the OderoPay button.

Function:

`oderoPayButtonView.removeOderoPayButtonOutline()`

Example:

```swift
    oderoPayButtonView.removeOderoPayButtonOutline()
```
      
Setting image (OderoPay logo) insets inside OderoPay button.

Function:

`oderoPayButtonView.setOderoPayButtonImageEdgeInsets(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat)`

Example:

```swift
    oderoPayButtonView.setOderoPayButtonImageEdgeInsets(top: 0, left: 0, bottom: -5, right: 5)
```

## License

Copyright © 2022 Token Payment Services and Electronic Money Inc. All rights reserved.

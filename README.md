# OderoPay

OderoPay is a Swift Package that lets you integrate your iOS application to the Odero Payment Ecosystem.

## Installation

In Xcode open `File` => `Add Packages...` => enter this Github repository.

## Support

OderoPay supports `Visa`, `Visa Electron`, `MasterCard`, `Maestro` and `American Express` card associations.

## Usage

SET API KEY AND ETC

SET WEB VIEW NATIVE BY DEFAULT

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

OderoPay Swift Package comes with UI customizability and detailed description of functionality. First comes customizability of the Common Payment Page, next functionality description.

## Navigating to Common Payment Page using OderoPay button

To navigate to the common payment page you need to add navigation controller to the OderoPay button.

Function header:

```swift
    oderoPayButtonView.initNavigationController(named: UINavigationController)
```

Code example:

```swift
    oderoPayButtonView.initNavigationController(named: self.navigationController!)
```

## Changing OderoPay button color

OderoPay button color comes in two variations: black and white. You can also add button outline to the button itself. It's recommended to use black color variation or white color with black outline variation for light backgrounds, and white color variation for the dark backgrounds.

Function header:

```swift
    oderoPayButtonView.changeDefaultColor(fromWhiteToBlack: Bool)
```

Code example:

```swift
    oderoPayButtonView.changeDefaultColor(fromWhiteToBlack: true)
```

## Adding outline to OderoPay button

You can add any desired color outline to the OderoPay button. It's recommended only to add black colored outline to the white colored button.

Function header:

```swift
    oderoPayButtonView.addOderoPayButtonOutline(colored: UIColor)
```

Code example:

```swift
    oderoPayButtonView.addOderoPayButtonOutline(colored: .black)
```

## Removing outline from OderoPay button

You can remove added outline from the OderoPay button just as easy as adding it.

Function header:

```swift
    oderoPayButtonView.removeOderoPayButtonOutline()
```

Code example:

```swift
    oderoPayButtonView.removeOderoPayButtonOutline()
```
      
## Change OderoPay image size

You can change the size of the OderoPay sign/image inside the OderoPay button as you see fit depending on the size of your OderoPay button itself.

Function header:

```swift
    oderoPayButtonView.setOderoPayImageSize(height: CGFloat, width: CGFloat)
```

Code example:

```swift
    oderoPayButtonView.setOderoPayImageSize(height: 40, width: 80)
```

## License

Copyright © 2022 Token Payment Services and Electronic Money Inc. All rights reserved.

# PPMusicImageShadow

## Synopsis

PPMusicImageShadow is a view that imitates in real time the shadow blurred effect of iOS Music App.

![alt tag](https://github.com/PierrePerrin/PPMusicImageShadow/blob/master/ExampleScreenShots/Simulator%20Screen%20Shot%206%20mars%202017%20à%2022.02.37.png)
![alt tag](https://github.com/PierrePerrin/PPMusicImageShadow/blob/master/ExampleScreenShots/Simulator%20Screen%20Shot%206%20mars%202017%20à%2022.04.20.png)
![alt tag](https://github.com/PierrePerrin/PPMusicImageShadow/blob/master/ExampleScreenShots/Simulator%20Screen%20Shot%206%20mars%202017%20à%2022.08.12.png)

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```
To integrate PPMusicImageShadow into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target '<Your Target Name>' do
pod 'PPMusicImageShadow'
end
```

### Manually

If you prefer  you can clone the project, release the framework or use the view swift file directly.

## Code Example

### Storyboard Example

Insert a normal UIView in your viewController.

![alt tag](https://github.com/PierrePerrin/PPMusicImageShadow/blob/master/ExampleScreenShots/Storyboard%20screens/1.jpg)
![alt tag](https://github.com/PierrePerrin/PPMusicImageShadow/blob/master/ExampleScreenShots/Storyboard%20screens/2.jpg)

Change it class with "PPMusicImageShadow". Now you can set an image like an imageView, a blur radius, and a corner radius.

### Programing Example

```swift
import PPMusicImageShadow

class ProgramingExampleViewController: UIViewController {

    var exampleView : PPMusicImageShadow!


    override func viewDidLoad() {
        super.viewDidLoad()

        self.addEffectView()
        self.prepareExampleView()
        self.setImageToExampleView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.exampleView.center = self.view.center
    }

    //MARK: Example
    func addEffectView(){

        self.exampleView = PPMusicImageShadow(frame: CGRect.init(x: 0, y: 0, width: 300, height: 300))
        self.view.addSubview(self.exampleView)
    }

    func setImageToExampleView(){

        let image = UIImage(named: "prairie-679016_1920.jpg")
        self.exampleView.image = image
    }

    func prepareExampleView(){

        self.exampleView.cornerRaduis = 10
        self.exampleView.blurRadius = 5
    }
}
```

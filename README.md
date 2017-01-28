## Requirements
* iOS 8.0+
* Xcode 8.0+
* Swift 3.0+

## Installation
### CocoaPods
if not installed yet install cocoaPods with the following command

```
$ gem install cocoapods
```

> CocoaPods 1.1.0+ is required to build CustomLoader

To integrate **CustomLoader** into your Xcode project using CocoaPods, specify it in your Podfile:

```
platform :ios, '8.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'CustomLoader'
end

```

> This will install the latest version of CustomLoader

Apply your configuration with the following command:

```
$ pod install
```

## Usage
### Presenting a loading view
```
import CustomLoader

LoadingView.standardProgressBox.show(inView: view)
```

### Remove the loading view
```
view.removeLoadingViews(animated: true)
```

### Customizing the progress ring
```
public extension ProgressRingView {
    
    public static var appProgressRing: ProgressRingView {
        let view = ProgressRingView()
        view.outterColor = .red
        view.innerColor = .blue
        return view
    }
}

public extension LoadingView {

    public static var appLoadingView: LoadingView {
        return LoadingView(loaderView: ProgressRingView. appProgressRing)
    }
}

```
### Loader with your view
```
static var myLoader: LoadingView {
    let loaderView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    loaderView.startAnimating()
    return LoadingView(loaderView: loaderView)
}
```

### Present the customized loader
```
LoadingView.appLoadingView.show(inView: view)
```
```
LoadingView.myLoader.show(inView: view)
```



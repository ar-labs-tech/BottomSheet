# BottomSheet

BottomSheet implementation of custom modal presentation style.

## How it looks like



## Usage

```Swift
let options = OptionsTable()
options.configurePanSetting(viewController: options, defaultHeight: 300, maxHeight: 300)
options.delegate = self
self.presentPanViewController(viewController: options)

override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    presentContainerViewWithAnimation() 
}
```


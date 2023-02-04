# BottomSheet

BottomSheet implementation of custom modal presentation style.

## How it looks like


https://user-images.githubusercontent.com/14196441/216781920-1cc74a2c-b5e9-43a9-9eac-c63c9dcf8883.mov


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


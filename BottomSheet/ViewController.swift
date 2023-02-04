//
//  ViewController.swift
//  BottomSheet
//
//  Created by AR on 04/02/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonOptions(_ sender: Any) {
        let options = OptionsTable()
        options.configurePanSetting(viewController: options, defaultHeight: 300, maxHeight: 300)
        options.delegate = self
        self.presentPanViewController(viewController: options)
    }
}

extension ViewController: OptionsDelegate {
    func didSelectItem(index: Int, type: Int) {
        print("\(index)")
    }
}


//
//  DocumentOptionsVC.swift
//  BottomSheet
//
//  Created by AR on 04/02/23.
//

import UIKit

@objc protocol OptionsDelegate {
    @objc func didSelectItem(index:Int, type:Int)
}

struct Options {
    var id: Int?
    var name: String?
    var icon: String?
}


@objcMembers class OptionsTable: UIViewController {
    
    var delegate: OptionsDelegate?
    
    var options = [Options]()
    var passCodeEnable:Bool?
    var passCode: String?
    
    lazy var tableOption:UITableView = {
       var tableView = UITableView()
        tableView.separatorStyle = .none
       return tableView
    }()
    
    lazy var dragIndicatorView:UIView = {
       let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.7450980392, green: 0.7450980392, blue: 0.7450980392, alpha: 1)
        return view
    }()

    //MARK: - controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        options = [Options(id: 0,
                         name: "Bookmark",
                         icon: "bookmark.circle.fill"),
                   Options(id: 1,
                           name: "Share",
                           icon: "square.and.arrow.up.circle.fill"),
                   Options(id: 1,
                           name: "Play",
                           icon: "play.circle.fill"),
                   Options(id: 1,
                           name: "Forward",
                           icon: "arrowshape.turn.up.forward.circle.fill")
        ]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentContainerViewWithAnimation() // from bottom sheet extention
    }
    
    // Register Cell Xib
    func registerXIBCell() {
        tableOption.register(nibWithCalss: OptionsCell.self)
    }
    
    func setupUI() {
        DispatchQueue.main.async { [self] in
            dragIndicatorView.frame = CGRect(x: view.bounds.size.width/2-22, y: 15, width: 44, height: 4)
            dragIndicatorView.layer.cornerRadius = 2
            dragIndicatorView.layer.masksToBounds = true
            tableOption.frame = CGRect(x: 15, y: 55, width: view.bounds.size.width-30, height: view.bounds.size.height-55)
            tableOption.delegate = self
            tableOption.dataSource = self
            tableOption.backgroundColor = .clear
            self.containerView.addSubview(dragIndicatorView)
            self.containerView.addSubview(tableOption)
            registerXIBCell()
        }
    }
    
    @objc func didSelectDelete(){
        delegate?.didSelectItem(index: 404, type: 0)
        dismissViewAnimation()
    }
}

extension OptionsTable: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: OptionsCell.self, for: indexPath)
        cell.lblName.text = options[indexPath.row].name
        cell.selectionStyle = .none
        cell.iconImage.image = UIImage(systemName: options[indexPath.row].icon ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectItem(index: indexPath.row, type: 0)
        dismissViewAnimation()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}



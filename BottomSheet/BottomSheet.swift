//
//  BottomSheet.swift
//  BottomSheet
//
//  Created by AR on 04/02/23.
//

import Foundation
import UIKit

public protocol PanViewControllerAble where Self: UIViewController{
    
    func presentPanViewController(viewController vc: UIViewController)
    func configurePanSetting(viewController vc: UIViewController, defaultHeight: CGFloat, maxHeight: CGFloat)
}


extension UIViewController: PanViewControllerAble{
    
    fileprivate struct Holder
    {
        static var dimmedView:UIView = UIView()
        static var dragIndicatorView = UIView()
        
        static var containerView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            view.layer.cornerRadius = 30
            view.clipsToBounds = true
            return view
        }()
        
        
        static fileprivate var defaultHeight: CGFloat = 300
        
        static fileprivate var dismissibleHeight: CGFloat = ((defaultHeight - 100) <= 0) ? 50 : defaultHeight - 100
        static fileprivate var maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
        
        static fileprivate var currentContainerHeight: CGFloat = defaultHeight
        
        static fileprivate var containerViewHeightConstraint: NSLayoutConstraint?
        static fileprivate var containerViewBottomConstraint: NSLayoutConstraint?
    }
    
    fileprivate func resetHolder()
    {
        dimmedView = UIView()
        dragIndicatorView = UIView()
        containerView = {
            let view = UIView()
            view.backgroundColor = .white
            view.layer.cornerRadius = 30
            view.clipsToBounds = true
            return view
        }()
        
        currentContainerHeight = defaultHeight
        containerViewHeightConstraint = nil
        containerViewBottomConstraint = nil
    }
    
    @objc fileprivate func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        let isDraggingDown = translation.y > 0
        
        let newHeight = currentContainerHeight + (-translation.y)
        
        switch gesture.state {
        case .changed:
            if newHeight < maximumContainerHeight {
                containerViewHeightConstraint?.constant = newHeight
                view.layoutIfNeeded()
            }
        case .ended:

            if newHeight < dismissibleHeight {
                self.dismissViewAnimation()
            }
            else if newHeight < defaultHeight {
                setContainerViewHeightAnimation(defaultHeight)
            }
            else if newHeight < maximumContainerHeight && isDraggingDown {
                setContainerViewHeightAnimation(defaultHeight)
            }
            else if newHeight > defaultHeight && !isDraggingDown {
                setContainerViewHeightAnimation(maximumContainerHeight)
            }
            
        default:
            break
        }
    }
    
    @objc func dismissViewAnimation() {
        
        dimmedView.alpha = dimmedMaxAlpha
        let dismissDimmedViewAnimate = UIViewPropertyAnimator(duration: 0.4, curve: .easeIn) {
            self.dimmedView.alpha = 0
        }
        
        dismissDimmedViewAnimate.addCompletion { position in
            if position == .end
            {
                self.dismiss(animated: false, completion:{
                    self.resetHolder()
                })
            }
        }
        dismissDimmedViewAnimate.startAnimation()
        
        UIViewPropertyAnimator(duration: 0.3, curve: .easeIn) {
            self.containerViewBottomConstraint?.constant = self.currentContainerHeight
            
            self.view.layoutIfNeeded()
        }.startAnimation()
        
    }
}

extension PanViewControllerAble where Self: UIViewController {

    fileprivate var dimmedView: UIView{
        get{
            return Holder.dimmedView
        }set{
            Holder.dimmedView = newValue
        }
    }
    
    fileprivate var dragIndicatorView: UIView
    {
        get
        {
            return Holder.dragIndicatorView
        }set{
            Holder.dragIndicatorView = newValue
        }
    }
    
    public var containerView: UIView{
        get{
            return Holder.containerView
        }set{
            Holder.containerView = newValue
        }
    }
    
    fileprivate var defaultHeight: CGFloat
    {
        get{
            return Holder.defaultHeight
        }set{
            Holder.defaultHeight = newValue
        }
    }
    
    fileprivate var dismissibleHeight: CGFloat
    {
        get{
            ((defaultHeight - 100) <= 0) ? 50 : defaultHeight - 100
        }set{
            Holder.dismissibleHeight = newValue
        }
    }
    fileprivate var maximumContainerHeight: CGFloat{
        get{
            Holder.maximumContainerHeight
        }set{
            Holder.maximumContainerHeight = newValue
        }
    }
    
    fileprivate var currentContainerHeight: CGFloat
    {
        get{
            return Holder.currentContainerHeight
        }set{
            Holder.currentContainerHeight = newValue
        }
    }
    
    fileprivate var containerViewHeightConstraint: NSLayoutConstraint?
    {
        get{
            return Holder.containerViewHeightConstraint
        }set
        {
            Holder.containerViewHeightConstraint = newValue
        }
    }
    fileprivate var containerViewBottomConstraint: NSLayoutConstraint?
    {
        get{
            return Holder.containerViewBottomConstraint
        }set
        {
            Holder.containerViewBottomConstraint = newValue
        }
    }
    
    
    fileprivate var dimmedMaxAlpha: CGFloat {
        get{
            0.6
        }
    }
    
    public func presentPanViewController(viewController vc: UIViewController)
    {
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
    }
    
    public func configurePanSetting(viewController vc: UIViewController, defaultHeight: CGFloat, maxHeight: CGFloat)
    {
        setDefauleHeight(height: defaultHeight)
        setMaxHeight(height: maxHeight)
        resetHolder()
        vc.view.backgroundColor = .clear
        configureDimmedView(viewController: vc)
        configureContainerView(viewController: vc)
        configurePanGesture(viewController: vc)
    }
    
    public func presentContainerViewWithAnimation() {
        showDimmedViewAnimation()
        UIViewPropertyAnimator(duration: 0.3, curve: .easeIn) {
            self.containerViewBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }.startAnimation()
    }
    
   private func configureDimmedView(viewController vc: UIViewController)
    {
        self.dimmedView.alpha = dimmedMaxAlpha
        self.dimmedView.backgroundColor = .black
        vc.view.addSubview(dimmedView)
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dimmedView.topAnchor.constraint(equalTo: vc.view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissViewAnimation))
        dimmedView.addGestureRecognizer(tapGesture)
    }
    
    private func configureContainerView(viewController vc: UIViewController)
    {
        vc.view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        if containerViewHeightConstraint?.isActive == false{
            containerViewHeightConstraint?.isActive = true
        }
        if containerViewBottomConstraint?.isActive == false
        {
            containerViewBottomConstraint?.isActive = true
        }
    }
    
    private func configureDragIndicatorView(viewController vc: UIViewController)
    {
        vc.view.addSubview(dragIndicatorView)
        self.dragIndicatorView.backgroundColor = #colorLiteral(red: 0.7450980392, green: 0.7450980392, blue: 0.7450980392, alpha: 1)
        self.dragIndicatorView.layer.masksToBounds = true
        self.dragIndicatorView.layer.cornerRadius = 30
        dragIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        dragIndicatorView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15).isActive = true
        dragIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dragIndicatorView.widthAnchor.constraint(equalToConstant: self.view.frame.width / 8).isActive = true
        dragIndicatorView.heightAnchor.constraint(equalToConstant: 6).isActive = true
    }
    
    
    private func configurePanGesture(viewController vc: UIViewController) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        vc.view.addGestureRecognizer(panGesture)
    }
    
    
    fileprivate func setContainerViewHeightAnimation(_ height: CGFloat) {
        
        UIViewPropertyAnimator(duration: 0.4, curve: .easeIn) {
            self.containerViewHeightConstraint?.constant = height
            self.view.layoutIfNeeded()
        }.startAnimation()
        currentContainerHeight = height
    }
    
    private func showDimmedViewAnimation() {
        dimmedView.alpha = 0
        UIViewPropertyAnimator(duration: 0.4, curve: .easeIn) {
            self.dimmedView.alpha = self.dimmedMaxAlpha
        }.startAnimation()
        
    }
    
    fileprivate func setDefauleHeight(height: CGFloat) {
        defaultHeight = height
    }
    
    fileprivate func setMaxHeight(height: CGFloat)
    {
        maximumContainerHeight = height
    }
}

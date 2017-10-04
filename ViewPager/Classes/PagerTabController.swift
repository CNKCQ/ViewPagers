//
//  ChildTabViewController.swift
//  Elegant
//
//  Created by Steve on 29/09/2017.
//  Copyright © 2017 KingCQ. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class PagerTabController: UITabBarController {
    var panGesture: UIPanGestureRecognizer!
    var subViewControllerCount: Int = 0
    var viewPagerTabBarDelete: ViewPagerTabBarDelete!
    var pageDidAppear: ((_ toPage: UIViewController, _ index: Int) -> Void)?
    var didSelected: ((_ index: Int) -> Void)?
    var shouldUpdateProgress: Bool = false
    
    convenience init(_ controllers: [UIViewController]) {
        self.init(nibName: nil, bundle: nil)
        self.viewPagerTabBarDelete = ViewPagerTabBarDelete()
        controllers.forEach { (controller) in
            self.addChildViewController(controller)
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        extendedLayoutIncludesOpaqueBars = true
        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(gesture:)))
        self.view.addGestureRecognizer(self.panGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.subViewControllerCount = self.viewControllers?.count ?? 0
        self.delegate = self.viewPagerTabBarDelete
    }
    
    @objc func onPan(gesture: UIPanGestureRecognizer)  {
        
        let tranlation = gesture.translation(in: self.view)
        let tranlationX = tranlation.x
        let tranlationY = tranlation.y
        if fabs(tranlationY) > fabs(tranlationX) {
            self.viewPagerTabBarDelete?.interactiveTransition.cancel()
            return
        }
        let progress = fabs(tranlationX/self.view.frame.size.width)
        
        switch gesture.state {
        case .began:
            self.viewPagerTabBarDelete?.interactive = true
            let velocityX = gesture.velocity(in: self.view).x
            if velocityX < 0 {
                if self.selectedIndex < self.subViewControllerCount - 1 {
                    self.selectedIndex += 1
                    self.shouldUpdateProgress = true
                } else {
                    self.shouldUpdateProgress = false
                }
            } else {
                if selectedIndex > 0 {
                    selectedIndex -= 1
                    self.shouldUpdateProgress = true
                } else {
                    self.shouldUpdateProgress = false
                }
            }
        case .changed:
            if self.shouldUpdateProgress == true {
                self.viewPagerTabBarDelete?.interactiveTransition.update(progress)
                (self.parent as? ViewPagerController)?
                    .viewPageBar.updateProgress(progress,
                                                    fromIndex: self.viewPagerTabBarDelete.fromIndex,
                                                    toIndex: self.viewPagerTabBarDelete.toIndex)
            }
        case .ended, .cancelled, .failed:
            if shouldUpdateProgress == true {
                if progress > 0.3 {
                    self.viewPagerTabBarDelete?
                        .interactiveTransition
                        .completionSpeed = 0.99
                    self.viewPagerTabBarDelete?
                        .interactiveTransition.finish()
                    (self.parent as? ViewPagerController)?.viewPageBar
                        .updateProgress(progress,
                                              fromIndex: self.viewPagerTabBarDelete.fromIndex,
                                              toIndex: self.viewPagerTabBarDelete.toIndex)
                    (self.parent as? ViewPagerController)?.viewPageBar.finishProgress(index: self.viewPagerTabBarDelete.toIndex)
                    self.viewPagerTabBarDelete?.interactive = false
                    self.pageDidAppear?(self.childViewControllers[self.selectedIndex], self.selectedIndex)
                } else {
                    self.viewPagerTabBarDelete?
                        .interactiveTransition.completionSpeed = 0.99
                    (self.parent as? ViewPagerController)?.viewPageBar
                        .updateProgress(progress,
                                              fromIndex: self.viewPagerTabBarDelete.toIndex,
                                              toIndex: self.viewPagerTabBarDelete.fromIndex)
                    (self.parent as? ViewPagerController)?.viewPageBar.finishProgress(index: self.viewPagerTabBarDelete.fromIndex)
                    self.viewPagerTabBarDelete?.interactiveTransition.cancel()
                }
            }
        default:
            break
        }
        
    }
}

extension PagerTabController: ViewPageBarDelegate {
    
    func viewPageBar(_ viewPageBar: ViewPageBar, selectedIndex index: Int) {
        self.selectedIndex = index
        self.viewPagerTabBarDelete.interactive = false
        self.didSelected?(index)
        viewPageBar.finishProgress(index: index)
    }
}

class ViewPagerTabBarDelete: NSObject, UITabBarControllerDelegate {
    
    var interactive: Bool = false
    var interactiveTransition: UIPercentDrivenInteractiveTransition!
    var tabBarAnimator: AnimatedTransitioning!
    var toIndex: Int = 0
    var fromIndex: Int = 0
    var pageDidAppear: (() -> Void)?

    
    override init() {
        super.init()
        interactiveTransition = UIPercentDrivenInteractiveTransition()
        tabBarAnimator = AnimatedTransitioning()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactive ? self.interactiveTransition : nil
    }
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        fromIndex = tabBarController.viewControllers?.index(of: fromVC) ?? 0
        toIndex = tabBarController.viewControllers?.index(of: toVC) ?? 0
        self.tabBarAnimator.swipeDirection = (toIndex < fromIndex) ? .left: .right
        return self.interactive ? self.tabBarAnimator : nil
    }
}



let kAnimationDuration: TimeInterval = 0.4
class AnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    var swipeDirection: SwipeDirection = .left
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return kAnimationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to), let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
            fatalError("sorry failed to find the toVC or fromVC")
        }
        let containerView = transitionContext.containerView
        toVC.view.transform = CGAffineTransform.identity
        fromVC.view.transform = CGAffineTransform.identity
        var translation = containerView.frame.size.width
        switch self.swipeDirection {
        case .left:
            break
        case .right:
            translation = -translation
        }
        containerView.addSubview(toVC.view)
        toVC.view.transform = CGAffineTransform.init(translationX: -translation, y: 0)
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            fromVC.view.transform = CGAffineTransform.init(translationX: translation, y: 0)
            toVC.view.transform = CGAffineTransform.identity
        }) { (finished) in
            fromVC.view.transform = CGAffineTransform.identity
            toVC.view.transform = CGAffineTransform.identity
            let didComplete = transitionContext.transitionWasCancelled == false
            transitionContext.completeTransition(didComplete)
        }
    }
}

enum SwipeDirection {
    case left
    case right
}
public struct ViewPager {
    var title: String?
    var controller: UIViewController?
    
    public init(title: String?, controller: UIViewController?) {
        self.title = title
        self.controller = controller
    }
}


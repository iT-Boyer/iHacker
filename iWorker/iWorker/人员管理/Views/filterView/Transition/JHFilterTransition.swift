//
//  MapFilterTransitionDelegate.swift
//  iWorker
//
//  Created by boyer on 2022/5/26.
//

import Foundation
import UIKit
// 转场代理：（转场页面，出场动画，退场动画）
class JHFilterTransitionDelegate:NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        JHFilterPresentationViewController(presentedViewController: presented, presenting: presenting)
    }
    
    // 出场动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animate = JHFilterAnimatedTransitioning()
        animate.isPresentation = true
        return animate
    }
    
    // 退场动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animate = JHFilterAnimatedTransitioning()
        animate.isPresentation = false
        return animate
    }
}

// 转场动画控制器：负责添加视图以及执行动画
class JHFilterAnimatedTransitioning:NSObject, UIViewControllerAnimatedTransitioning {
    
    var isPresentation = false
    //动画时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.5
    }
    
    //动画逻辑
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //获取两个VC和动画容器
        let from = transitionContext.viewController(forKey: .from)
        let to = transitionContext.viewController(forKey: .to)
        let containerView = transitionContext.containerView
        
        //确定动画作用在哪个VC上。的进场/退场状态
        containerView.addSubview((isPresentation ? to?.view:from?.view) ?? UIView())
        let animatingVC = isPresentation ? to:from
        let animatingView = animatingVC?.view
        //获取动画前后的视图大小
        let finalFrame = transitionContext.finalFrame(for: animatingVC!)
        var initFrame = finalFrame
        initFrame.origin.y += initFrame.size.height
        //
        let animatingFinalFrame = isPresentation ? initFrame:finalFrame
        let animatingInitFrame = isPresentation ? finalFrame:initFrame
        animatingView?.frame = animatingInitFrame
        // 开始View动画
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration) {
            animatingView?.frame = animatingFinalFrame
        } completion: {[weak self] finished in
            guard let wf = self else{return}
            if wf.isPresentation {
                from?.view.removeFromSuperview()
            }
            transitionContext.completeTransition(true)
        }

    }
}

//UIPresentationController控制器
/**
 1定制 presentedView 的外观：设定 presentedView 的尺寸以及在 containerView 中添加自定义视图并为这些视图添加动画；
 2可以选择是否移除 presentingView；
 3可以在不需要动画控制器的情况下单独工作；
 UIAdaptivePresentationControllerDelegate 转场协调器，可在转场 动画发生的同时执行其他动画。
 转场协调器主要在转场和交互转场取消时使用。
 */
class JHFilterPresentationViewController:UIPresentationController, UIAdaptivePresentationControllerDelegate {
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override var shouldPresentInFullscreen: Bool{
        true
    }
    
    override var adaptivePresentationStyle: UIModalPresentationStyle{
        .fullScreen
    }
    
    override var presentedView: UIView?{
        presentedViewController.view //默认返回。当返回其他视图，一定要是 presentedViewController.view 的上层视图。
    }
    
    override var frameOfPresentedViewInContainerView: CGRect{
        var presentViewFrame = CGRect.zero
        let containerBounds = containerView?.bounds ?? .zero
        //进场控制器内容视图的大小
        presentViewFrame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerBounds.size)
        presentViewFrame.origin.y = containerBounds.size.height - presentViewFrame.size.height
        return presentViewFrame
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        CGSize(width: parentSize.width, height: parentSize.height - 80)
    }
    
    //MARK: 自定义转场动画
    // 转场开始
    /*
     转场协调器确保了转场与过渡动画同步进行
        1. 添加过渡视图：在containerView中插入视图chromeView
        2. 添加转场动画:为转场中涉及到的视图（chromeView）
    */
    override func presentationTransitionWillBegin() {
        chromeView.frame = containerView?.bounds ?? .zero
        chromeView.alpha = 0.0
        containerView?.insertSubview(chromeView, at: 0)
        animate(true)
    }
    // 转场结束
    override func dismissalTransitionWillBegin() {
        animate(false)
    }
    
    func animate(_ show:Bool) {
        let alpha = show ? 1.0:0.0
        let coordinator = presentedViewController.transitionCoordinator
        if coordinator != nil {
            coordinator?.animate(alongsideTransition: {[weak self] context in
                guard let wf = self else {
                    return
                }
                wf.chromeView.alpha = alpha
            }, completion: { context in
            })
        }else{
            chromeView.alpha = alpha
        }
    }
    
    
    //MARK: 自定义背景视图
    lazy var chromeView: UIView = {
        let chrome = UIView()
        //入场视图背景样式
        chrome.backgroundColor = .init(white: 0, alpha: 0.4)
        chrome.alpha = 0.0
        //退场手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(chromeViewTaped(tap:)))
        return chrome
    }()
    @objc
    func chromeViewTaped(tap:UITapGestureRecognizer) {
        if tap.state == .ended {
            presentingViewController.dismiss(animated: true)
        }
    }
}

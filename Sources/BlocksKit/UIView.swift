//
//  UIView.swift
//  BlocksKit
//
//  Created by Ventus on 2020/5/20.
//  Copyright © 2020 Nameless. All rights reserved.
//

import UIKit

fileprivate class UIGestureRecognizerTarget: NSObject {
    enum AssociatedKeys {
        static var target = "target"
    }
    
    private let block: () -> Void
    
    init(block: @escaping () -> Void) {
        self.block = block
        
        super.init()
    }
    
    @objc func invoke(_ sender: Any?) {
        block()
    }
}

// MARK: *************** UITapGestureRecognizer ***************

public extension UIView {
    @discardableResult
    func tap(numberOfTouches: Int = 1, numberOfTaps: Int = 1, handler: @escaping () -> Void) -> UITapGestureRecognizer {
        let target = UIGestureRecognizerTarget(block: handler)
        let gestureRecognizer = UITapGestureRecognizer(target: target, action: #selector(UIGestureRecognizerTarget.invoke(_:)))
        
        gestureRecognizer.numberOfTouchesRequired = numberOfTouches
        gestureRecognizer.numberOfTapsRequired = numberOfTaps
        
        objc_setAssociatedObject(gestureRecognizer, UIGestureRecognizerTarget.AssociatedKeys.target, target, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        addGestureRecognizer(gestureRecognizer)
        
        return gestureRecognizer
    }
    
    @discardableResult
    @inlinable
    func doubleTap(numberOfTouches: Int = 1, handler: @escaping () -> Void) -> UITapGestureRecognizer {
        tap(numberOfTouches: numberOfTouches, numberOfTaps: 2, handler: handler)
    }
}

// MARK: *************** UISwipeGestureRecognizer ***************

public extension UIView {
    @discardableResult
    func swipe(direction: UISwipeGestureRecognizer.Direction, numberOfTouches: Int = 1, handler: @escaping () -> Void) -> UISwipeGestureRecognizer {
        let target = UIGestureRecognizerTarget(block: handler)
        let gestureRecognizer = UISwipeGestureRecognizer(target: target, action: #selector(UIGestureRecognizerTarget.invoke(_:)))
        
        gestureRecognizer.direction = direction
        gestureRecognizer.numberOfTouchesRequired = numberOfTouches
        
        objc_setAssociatedObject(gestureRecognizer, UIGestureRecognizerTarget.AssociatedKeys.target, target, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        addGestureRecognizer(gestureRecognizer)
        
        return gestureRecognizer
    }
    
    @discardableResult
    @inlinable
    func swipeUp(numberOfTouches: Int = 1, handler: @escaping () -> Void) -> UISwipeGestureRecognizer {
        swipe(direction: .up, numberOfTouches: numberOfTouches, handler: handler)
    }
    
    @discardableResult
    @inlinable
    func swipeDown(numberOfTouches: Int = 1, handler: @escaping () -> Void) -> UISwipeGestureRecognizer {
        swipe(direction: .down, numberOfTouches: numberOfTouches, handler: handler)
    }
    
    @discardableResult
    @inlinable
    func swipeLeft(numberOfTouches: Int = 1, handler: @escaping () -> Void) -> UISwipeGestureRecognizer {
        swipe(direction: .left, numberOfTouches: numberOfTouches, handler: handler)
    }
    
    @discardableResult
    @inlinable
    func swipeRight(numberOfTouches: Int = 1, handler: @escaping () -> Void) -> UISwipeGestureRecognizer {
        swipe(direction: .right, numberOfTouches: numberOfTouches, handler: handler)
    }
}

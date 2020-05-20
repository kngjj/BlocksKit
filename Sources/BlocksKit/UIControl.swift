//
//  UIControl.swift
//  BlocksKit
//
//  Created by Ventus on 2020/5/20.
//  Copyright © 2020 Nameless. All rights reserved.
//

import UIKit

fileprivate class EventHandler: NSObject {
    enum AssociatedKeys {
        static var eventHandlers = "eventHandlers"
    }
    
    private let controlEvents: UIControl.Event
    private let block: ControlEvents.EventHandler

    init(controlEvents: UIControl.Event, block: @escaping ControlEvents.EventHandler) {
        self.controlEvents = controlEvents
        self.block = block

        super.init()
    }

    @objc func invoke(_ sender: UIControl) {
        block(sender)
    }
}

public struct ControlEvents {
    public typealias EventHandler = (UIControl) -> Void
    
    public let controlEvents: UIControl.Event
    private let control: UIControl
    
    public init(control: UIControl, controlEvents: UIControl.Event) {
        self.control = control
        self.controlEvents = controlEvents
    }

    public func add(eventHandler handler: @escaping EventHandler) {
        let sender = control
        let controlEvents = self.controlEvents
        
        var eventHandlers: NSMutableDictionary! = objc_getAssociatedObject(sender, BlocksKit.EventHandler.AssociatedKeys.eventHandlers) as? NSMutableDictionary
        
        if eventHandlers == nil {
            eventHandlers = NSMutableDictionary()
            
            objc_setAssociatedObject(sender, BlocksKit.EventHandler.AssociatedKeys.eventHandlers, eventHandlers, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        var handlers: NSMutableSet! = eventHandlers[controlEvents] as? NSMutableSet
        
        if handlers == nil {
            handlers = NSMutableSet()
            
            eventHandlers[controlEvents] = handlers
        }
        
        let target = BlocksKit.EventHandler(controlEvents: controlEvents, block: handler)
        
        handlers.add(target)
        
        sender.addTarget(target, action: #selector(BlocksKit.EventHandler.invoke(_:)), for: controlEvents)
    }
    
    public func removeEventHandlers() {
        let sender = control
        
        guard let eventHandlers = objc_getAssociatedObject(sender, BlocksKit.EventHandler.AssociatedKeys.eventHandlers) as? NSMutableDictionary else {
            return
        }
        
        let controlEvents = self.controlEvents
        
        guard let handlers = eventHandlers[controlEvents] as? NSMutableSet else {
            return
        }
        
        for target in handlers {
            sender.removeTarget(target, action: nil, for: controlEvents)
        }
        
        eventHandlers.removeObject(forKey: controlEvents)
    }
    
    public var hasEventHandlers: Bool {
        let sender = control
        
        guard let eventHandlers = objc_getAssociatedObject(sender, BlocksKit.EventHandler.AssociatedKeys.eventHandlers) as? NSMutableDictionary else {
            return false
        }
        
        let controlEvents = self.controlEvents
        
        guard let handlers = eventHandlers[controlEvents] as? NSMutableSet else {
            return false
        }
        
        return handlers.count > 0
    }
}

public extension UIControl {
    @inlinable
    var touchUpInsideEvent: ControlEvents {
        ControlEvents(control: self, controlEvents: .touchUpInside)
    }
    
    @inlinable
    func controlEvents(_ controlEvents: UIControl.Event) -> ControlEvents {
        ControlEvents(control: self, controlEvents: controlEvents)
    }
}

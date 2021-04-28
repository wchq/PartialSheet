//
//  PartialSheetManager.swift
//  PartialSheetExample
//
//  Created by Andrea Miotto on 29/4/20.
//  Copyright © 2020 Swift. All rights reserved.
//

import Combine
import SwiftUI

/**
 The Partial Sheet Manager helps to handle the Partial Sheet when you have many view layers.

 Make sure to pass an instance of this manager as an **environmentObject** to your root view in your Scene Delegate:
 ```
 let sheetManager: PartialSheetManager = PartialSheetManager()
 let window = UIWindow(windowScene: windowScene)
 window.rootViewController = UIHostingController(
 rootView: contentView.environmentObject(sheetManager)
 )
 ```
 */
public class PartialSheetManager: ObservableObject {

    /// Published var to present or hide the partial sheet
    @Published var willPresent: Bool = false
    @Published var isPresented: Bool = false
    
    /// The content of the sheet
    @Published private(set) var content: AnyView
    /// the onDismiss code runned when the partial sheet is closed
    private(set) var onDismiss: (() -> Void)?
    
    /// Possibility to customize the slide in/out animation of the partial sheet
    public var animationCooldown = 0.4
    
    //spring animations
    //public var defaultShowAnimation: Animation = Animation.spring(response: 0.4, dampingFraction: 0.7, blendDuration: 1.0)
    //public var defaultKeyboardAnimation: Animation = Animation.spring(response: 0.4, dampingFraction: 0.7, blendDuration: 1.0)
    
    public var defaultHideAnimation: Animation = Animation.linear(duration: 0.1)
    
    //timing curve animations
    public var defaultShowAnimation: Animation = Animation.timingCurve(0.075, 0.82, 0.165, 1.0)
    public var defaultKeyboardAnimation: Animation = Animation.timingCurve(0.075, 0.82, 0.165, 1.0)

    public init() {
        self.content = AnyView(EmptyView())
    }

    /**
      Presents a **Partial Sheet**  with a dynamic height based on his content.
     - parameter content: The content to place inside of the Partial Sheet.
     - parameter onDismiss: This code will be runned when the sheet is dismissed.
     */
    public func showPartialSheet<T>(_ onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> T) where T: View {
//        guard !isPresented else {
//            withAnimation(defaultAnimation) {
//                updatePartialSheet(
//                    content: {
//                        // do not animate the content, just the partial sheet
//                        withAnimation(nil) {
//                            content()
//                        }
//                    },
//                    onDismiss: onDismiss)
//            }
//            return
//        }
        if self.isPresented {
            return
        }
        
        self.content = AnyView(content())
        self.onDismiss = onDismiss
        DispatchQueue.main.async {
            withAnimation(self.defaultShowAnimation) {
                self.willPresent = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + self.animationCooldown) {
                self.isPresented = true
            }
        }
    }

    /**
     Updates some properties of the **Partial Sheet**
    - parameter isPresented: If the partial sheet is presented
    - parameter content: The content to place inside of the Partial Sheet.
    - parameter onDismiss: This code will be runned when the sheet is dismissed.
    */
    public func updatePartialSheet<T>(isPresented: Bool? = nil, content: (() -> T)? = nil, onDismiss: (() -> Void)? = nil) where T: View {
        if let content = content {
            self.content = AnyView(content())
        }
        if let onDismiss = onDismiss {
            self.onDismiss = onDismiss
        }
        /*
        if let isPresented = isPresented {
            withAnimation(defaultAnimation) {
                self.isPresented = isPresented
            }
        }
        */
    }

    /// Close the Partial Sheet and run the onDismiss function if it has been previously specified
    public func closePartialSheet() {
        guard self.isPresented else {
            return
        }
        
        withAnimation(self.defaultHideAnimation) {
            self.willPresent = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + self.animationCooldown) {
            self.isPresented = false
            self.onDismiss = nil
            self.content = AnyView(EmptyView())
        }
        self.onDismiss?()
    }
}

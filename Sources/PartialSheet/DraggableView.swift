//
//  DraggableView.swift
//  PartialSheetExample
//
//  Created by Rasmus Styrk on 07/02/2021.
//  Copyright © 2021 Swift. All rights reserved.
//

import SwiftUI
import UIKit

class TestController<Content: View>: UIViewController {
    var hostingController: UIHostingController<Content>! = nil

    init(rootView: Content) {
        self.hostingController = UIHostingController<Content>(rootView: rootView)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hostingController.willMove(toParent: self)
        self.view.addSubview(self.hostingController.view)
        self.hostingController.view.isUserInteractionEnabled = true
        self.makefullScreen(of: self.hostingController.view, to: self.view)
        self.hostingController.didMove(toParent: self)
    }

    func makefullScreen(of viewA: UIView, to viewB: UIView) {
        viewA.translatesAutoresizingMaskIntoConstraints = false
        viewB.addConstraints([
            viewA.leadingAnchor.constraint(equalTo: viewB.leadingAnchor),
            viewA.trailingAnchor.constraint(equalTo: viewB.trailingAnchor),
            viewA.topAnchor.constraint(equalTo: viewB.topAnchor),
            viewA.bottomAnchor.constraint(equalTo: viewB.bottomAnchor),
        ])
    }
}

struct DraggableView<Content: View>: UIViewControllerRepresentable {
    var content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> TestController<Content> {
        let controller = TestController(rootView: self.content())
        let gesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePan(_:)))
        gesture.delegate = context.coordinator
        gesture.cancelsTouchesInView = false
        //controller.view.addGestureRecognizer(gesture)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: TestController<Content>, context: Context) {
        uiViewController.hostingController.rootView = self.content()
    }
  
    

    /*
    func makeUIView(context: Context) -> UIView {
        /*
        let host = UIHostingController(rootView: self.content())
        
        let gesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePan(_:)))
        gesture.delegate = context.coordinator
        gesture.cancelsTouchesInView = false
        host.view.addGestureRecognizer(gesture)
        
        context.coordinator.hostingController = host
        
        return host.view*/
        
        let host = UIHostingController(rootView: self.content())
        
        let view = UIView()
        let gesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePan(_:)))
        gesture.delegate = context.coordinator
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)
        view.backgroundColor = UIColor.red.withAlphaComponent(0.2)
        let hostView = host.view!
        
        view.addSubview(hostView)
        
        let constraints = [
            hostView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostView.topAnchor.constraint(equalTo: view.topAnchor),
            hostView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ]
        view.addConstraints(constraints)
        
        return view
        
        /*self.content.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(self.content)
        let constraints = [
            content.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            content.topAnchor.constraint(equalTo: view.topAnchor),
            content.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            content.widthAnchor.constraint(equalTo: view.widthAnchor)
        ]
        view.addConstraints(constraints)*/
        //return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        //uiView.subviews.map { $0.removeFromSuperview() }
        context.coordinator.hostingController?.rootView = self.content()
        /*if let view = context.coordinator.hostingController?.view {
            uiView.addSubview(view)
        }*/
    }*/
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var parent: DraggableView
        
        init(_ view: DraggableView) {
            self.parent = view
        }
        
        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            print("should begin?!")
            print(gestureRecognizer.view)
            
            return false
        }
        
        @objc func handlePan(_ pan: UIPanGestureRecognizer) {
            print("pann pan pan pan")
        }
    }
}

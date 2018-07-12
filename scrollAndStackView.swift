//
//  scrollAndStackView.swift
//  stack-Swift
//
//  Created by IosDeveloper on 07/06/18.
//  Copyright © 2018 serviceApp. All rights reserved.
//

import UIKit

extension UIView {
    //MARK: Add Shadow To UIView
    /**
     This Function is used to add shadow to UIView
     - parameter color : color of shadow
     */
    func addShadowToView(color:UIColor) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 8
    }
}

class scrollAndStackView: UIViewController {
    
    @IBOutlet weak var baseScrollView: UIView!
    
    /// Required Views
    private var paginationScrollView : UIScrollView?
    private var stack1BaseView: UIView?
    private var stack2BaseView: UIView?
    private var stack3BaseView: UIView?
    private var stackView1: UIStackView?
    private var stackView2: UIStackView?
    private var stackView3: UIStackView?
    private var contentHeight: CGFloat?
    
    
    /// Width Height
    let height = UIScreen.main.bounds.height
    let width = UIScreen.main.bounds.width
    
    
}

//MARK:- View Life Cycles
extension scrollAndStackView
{
    //MARK: Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Add A scrollView
        DispatchQueue.main.async {
            self.contentHeight = 0
            self.setUpScrollView()
        }
    } 
}



//MARK:- Required Functions
extension scrollAndStackView
{
    //MARK: Add A ScrollView
    private func setUpScrollView(){
        paginationScrollView = UIScrollView()
        stack1BaseView = UIView()
        stack2BaseView = UIView()
        stack3BaseView = UIView()
        stackView1 = UIStackView()
        stackView2 = UIStackView()
        stackView3 = UIStackView()
        paginationScrollView?.frame = CGRect(x: 0, y: 0, width: self.baseScrollView.frame.size.width, height: self.baseScrollView.frame.size.height)
        paginationScrollView?.delegate = self
        paginationScrollView?.isScrollEnabled = true
        paginationScrollView?.bounces = false
        paginationScrollView?.bouncesZoom = false
        paginationScrollView?.backgroundColor = UIColor.clear
        self.baseScrollView.addSubview(paginationScrollView!)
        
        /// Set Translationb Properties
        stackView2?.translatesAutoresizingMaskIntoConstraints = false
        stackView3?.translatesAutoresizingMaskIntoConstraints = false
        
        addContentView()
    }
    
    //MARK: Set content Size
    private func addContentView() {
        
        stack1BaseView?.backgroundColor = UIColor.white
        stack1BaseView?.translatesAutoresizingMaskIntoConstraints = false
        self.paginationScrollView?.addSubview(stack1BaseView!)
        stack1BaseView?.topAnchor.constraint(equalTo: paginationScrollView!.topAnchor, constant: 20).isActive=true
        stack1BaseView?.widthAnchor.constraint(equalToConstant: width*0.8).isActive=true
        stack1BaseView?.centerXAnchor.constraint(equalTo: paginationScrollView!.centerXAnchor).isActive=true
        //stack1BaseView?.bottomAnchor.constraint(equalTo: paginationScrollView!.bottomAnchor).isActive=true
        
        /// Add First StackView
        stackView1?.distribution = .fillEqually
        stackView1?.axis = .vertical
        stackView1?.alignment = .center
        stackView1?.spacing = 10
        stackView1?.backgroundColor = UIColor.white
        
        stackView1?.translatesAutoresizingMaskIntoConstraints = false
        stack1BaseView?.addSubview(stackView1!)
        stackView1?.topAnchor.constraint(equalTo: stack1BaseView!.topAnchor, constant: 0).isActive=true
        stackView1?.leadingAnchor.constraint(equalTo: stack1BaseView!.leadingAnchor).isActive=true
        stackView1?.trailingAnchor.constraint(equalTo: stack1BaseView!.trailingAnchor).isActive=true
        stackView1?.bottomAnchor.constraint(equalTo: stack1BaseView!.bottomAnchor).isActive=true
        
        /// Add Views of First Stack View
        for _ in 0..<3 {
            /// Initiate A View
            let myView = UIView()
            myView.backgroundColor = UIColor.gray
            
            /// Add in StackView
            myView.translatesAutoresizingMaskIntoConstraints = false
            stackView1?.addArrangedSubview(myView)
            myView.leadingAnchor.constraint(equalTo: stackView1!.leadingAnchor).isActive=true
            myView.widthAnchor.constraint(equalTo: stackView1!.widthAnchor).isActive=true
            myView.heightAnchor.constraint(equalToConstant: height*0.08).isActive=true
            contentHeight!+=height*0.08
        }
        
        /// Layer Properties
        stack1BaseView?.addShadowToView(color: .black)
        
        
        /// StackBase View 2
        stack2BaseView?.backgroundColor = UIColor.white
        stack2BaseView?.translatesAutoresizingMaskIntoConstraints = false
        self.paginationScrollView?.addSubview(stack2BaseView!)
        stack2BaseView?.topAnchor.constraint(equalTo: stack1BaseView!.bottomAnchor, constant: 20).isActive=true
        stack2BaseView?.widthAnchor.constraint(equalToConstant: width*0.8).isActive=true
        stack2BaseView?.centerXAnchor.constraint(equalTo: paginationScrollView!.centerXAnchor).isActive=true
        
        /// Add Second StackView
        stackView2?.distribution = .fillEqually
        stackView2?.axis = .vertical
        stackView2?.alignment = .center
        stackView2?.spacing = 10
        stackView2?.backgroundColor = UIColor.white
        
        stackView2?.translatesAutoresizingMaskIntoConstraints = false
        stack2BaseView?.addSubview(stackView2!)
        stackView2?.topAnchor.constraint(equalTo: stack2BaseView!.topAnchor, constant: 0).isActive=true
        stackView2?.leadingAnchor.constraint(equalTo: stack2BaseView!.leadingAnchor).isActive=true
        stackView2?.trailingAnchor.constraint(equalTo: stack2BaseView!.trailingAnchor).isActive=true
        stackView2?.bottomAnchor.constraint(equalTo: stack2BaseView!.bottomAnchor).isActive=true
        
        /// Add Views of First Stack View
        for _ in 0..<3 {
            /// Initiate A View
            let myView = UIView()
            myView.backgroundColor = UIColor.gray
            
            /// Add in StackView
            myView.translatesAutoresizingMaskIntoConstraints = false
            stackView2?.addArrangedSubview(myView)
            myView.leadingAnchor.constraint(equalTo: stackView2!.leadingAnchor).isActive=true
            myView.widthAnchor.constraint(equalTo: stackView2!.widthAnchor).isActive=true
            myView.heightAnchor.constraint(equalToConstant: height*0.08).isActive=true
            contentHeight!+=height*0.08
        }
        
        /// Layer Properties
        stack2BaseView?.addShadowToView(color: .black)
        
        
        /// StackBase View 2
        stack3BaseView?.backgroundColor = UIColor.white
        stack3BaseView?.translatesAutoresizingMaskIntoConstraints = false
        self.paginationScrollView?.addSubview(stack3BaseView!)
        stack3BaseView?.topAnchor.constraint(equalTo: stack2BaseView!.bottomAnchor, constant: 20).isActive=true
        stack3BaseView?.widthAnchor.constraint(equalToConstant: width*0.8).isActive=true
        stack3BaseView?.centerXAnchor.constraint(equalTo: paginationScrollView!.centerXAnchor).isActive=true
        
        /// Add Second StackView
        stackView3?.distribution = .fillEqually
        stackView3?.axis = .vertical
        stackView3?.alignment = .center
        stackView3?.spacing = 10
        stackView3?.backgroundColor = UIColor.white
        
        stackView3?.translatesAutoresizingMaskIntoConstraints = false
        stack3BaseView?.addSubview(stackView3!)
        stackView3?.topAnchor.constraint(equalTo: stack3BaseView!.topAnchor, constant: 0).isActive=true
        stackView3?.leadingAnchor.constraint(equalTo: stack3BaseView!.leadingAnchor).isActive=true
        stackView3?.trailingAnchor.constraint(equalTo: stack3BaseView!.trailingAnchor).isActive=true
        stackView3?.bottomAnchor.constraint(equalTo: stack3BaseView!.bottomAnchor).isActive=true
        
        /// Add Views of First Stack View
        for _ in 0..<3 {
            /// Initiate A View
            let myView = UIView()
            myView.backgroundColor = UIColor.gray
            
            /// Add in StackView
            myView.translatesAutoresizingMaskIntoConstraints = false
            stackView3?.addArrangedSubview(myView)
            myView.leadingAnchor.constraint(equalTo: stackView3!.leadingAnchor).isActive=true
            myView.widthAnchor.constraint(equalTo: stackView3!.widthAnchor).isActive=true
            myView.heightAnchor.constraint(equalToConstant: height*0.08).isActive=true
            contentHeight!+=height*0.08
        }
        
        /// Layer Properties
        stack3BaseView?.addShadowToView(color: .black)
        contentHeight!+=80
        
        ///Set Content Size to Show
        print(self.contentHeight!)
        print(height)
        self.paginationScrollView?.contentSize = CGSize(width: self.paginationScrollView!.frame.size.width, height: contentHeight!)
        //paginationScrollView?.setNeedsLayout()
    }
}

extension scrollAndStackView: UIScrollViewDelegate {
    
}

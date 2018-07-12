//
//  UploadFile.swift
//  Service App-Provider
//
//  Created by IosDeveloper on 06/06/18.
//  Copyright © 2018 serviceApp. All rights reserved.
//

import Foundation
import UIKit

class DropdownBtn : UIButton, DropdownProtocol {
    
    func dropDownPressed(string: String) {
        self.setTitle(string, for: .normal)
        self.dismissDropDown()
    }
    
    
    var dropView = DropdownView()
    var height = NSLayoutConstraint()
    var isOpen = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.darkGray
        
        dropView = DropdownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        dropView.delegate = self
        dropView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func didMoveToSuperview() {
        self.superview?.addSubview(dropView)
        self.superview?.bringSubview(toFront: dropView)
        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        height = dropView.heightAnchor.constraint(equalToConstant: 0)
        self.addTarget(self, action: #selector(buttonClickedHandler(_:)), for: .touchDown)
    }
    
    
    
    @objc func buttonClickedHandler(_ sender: UIButton){
        print("btn handler inside class")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false {
            isOpen = true
            NSLayoutConstraint.deactivate([self.height])
            
            if self.dropView.tableView.contentSize.height > 150 {
                self.height.constant = 150
            } else {
                self.height.constant = self.dropView.tableView.contentSize.height
            }
            
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
            }, completion: nil)
        } else {
            dismissDropDown()
        }
    }
    
    func dismissDropDown() {
        isOpen = false
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dropView.center.y -= self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()
        }, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol DropdownProtocol {
    func dropDownPressed(string: String)
}


class DropdownView : UIView, UITableViewDelegate, UITableViewDataSource {
    
    var dropDownOptions = [String]()
    var tableView = UITableView()
    var delegate : DropdownProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.backgroundColor = UIColor.darkGray
        self.backgroundColor = UIColor.darkGray
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableView)
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = dropDownOptions[indexPath.row]
        cell.backgroundColor = UIColor.darkGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.dropDownPressed(string: dropDownOptions[indexPath.row])
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

/// Usage

var languageButton : UIButton?
var LanguageBtn = DropdownBtn()
var languagesArray = ["English" , "Русски" , "Español"]


func setupButtons() {
    LanguageBtn = DropdownBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    LanguageBtn.translatesAutoresizingMaskIntoConstraints = false
    LanguageBtn.setTitle("121212", for: .normal)
    
    print("Adding target")
    LanguageBtn.addTarget(self, action: #selector(languageBtnPressed(_:)), for: .touchUpInside)
    print("Succesfully added target")
    
    self.view.addSubview(LanguageBtn)
    self.view.layoutIfNeeded()
    LanguageBtn.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 100).isActive = true
    LanguageBtn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 300).isActive = true
    LanguageBtn.widthAnchor.constraint(equalToConstant: 115).isActive = true
    LanguageBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
    LanguageBtn.dropView.dropDownOptions = languagesArray
}

@objc func languageBtnPressed(_ sender: UIButton) {
    print("Btn Pressed")
}

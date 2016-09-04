//
//  ViewController.swift
//  AutocompleteText
//
//  Created by Ray Fix on 9/3/16.
//  Copyright © 2016 Neko Labs. All rights reserved.
//

import UIKit


class ViewController: UIViewController, AutocompleteDataSource {

  @IBOutlet weak var textField: UITextField!
  
  let entries = ["Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune"]

  var autocompleteTextCount: Int {
    return entries.count
  }
  
  func autoCompleteText(at index: Int) -> String {
    return entries[index]
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()    
    let accessoryView = AutocompleteAccessoryView(dataSource: self) { [weak self] text in
      self?.textField.text = text
    }
    textField.inputAccessoryView = accessoryView
  }
}


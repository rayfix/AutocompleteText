//
//  AutocompleteAccessoryView.swift
//  AutocompleteText
//
//  Created by Ray Fix on 9/3/16.
//  Copyright © 2016 Neko Labs. All rights reserved.
//

import UIKit

protocol AutocompleteDataSource {
  var autocompleteTextCount: Int { get }
  func autoCompleteText(at index: Int) -> String
}

private class AutocompleteCell: UICollectionViewCell {
  static let reuseID = "autoCell"
  
  static let padding: CGFloat = 10
  static let buttonHeight: CGFloat = 30
  static let cornerRadius: CGFloat = 4
  static let font = UIFont.systemFont(ofSize: 16)
  static let boxColor = UIColor(white: 0.95, alpha: 1)
  static let textColor = UIColor(white: 0.3, alpha: 1)
  
  var label: UILabel?
  
  var text: String = "" {
    didSet {
        label?.text = text
    }
  }
  
  func configure(text: String) {
    self.text = text
  }
  
  func commonInit() {
    backgroundColor = AutocompleteCell.boxColor
    layer.cornerRadius = AutocompleteCell.cornerRadius
    clipsToBounds = true
    let labelFrame = UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: AutocompleteCell.padding, bottom: 0, right: AutocompleteCell.padding))
    let label = UILabel(frame: labelFrame)
    label.autoresizingMask = [.flexibleWidth]
    label.adjustsFontSizeToFitWidth = false
    label.lineBreakMode = .byClipping
    label.font = AutocompleteCell.font
    label.textColor = AutocompleteCell.textColor
    addSubview(label)
    self.label = label
  }
 
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  fileprivate override var intrinsicContentSize : CGSize {
    return AutocompleteCell.size(text: text)
  }
  
  static func size(text: String) -> CGSize {
    let textWidth = text.size(attributes: [NSFontAttributeName: AutocompleteCell.font]).width
    let itemSize = CGSize(width: textWidth + 2*AutocompleteCell.padding, height: AutocompleteCell.buttonHeight)
    return itemSize
  }
}

class AutocompleteAccessoryView: UIView {
  var dataSource: AutocompleteDataSource?
  var tapHandler: ((String)->Void)?
  
  init(dataSource: AutocompleteDataSource, tapHandler:@escaping (String)->Void) {
    self.dataSource = dataSource
    self.tapHandler = tapHandler
    super.init(frame:CGRect(x: 0, y: 0, width: 0, height: 44))
    commonInit()
  }
  
  func commonInit() {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    flowLayout.minimumLineSpacing = 10
    flowLayout.minimumInteritemSpacing = 10
    
    let collectionView = UICollectionView(frame: bounds, collectionViewLayout: flowLayout)
    collectionView.backgroundColor = .white
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    collectionView.allowsMultipleSelection = false
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.showsVerticalScrollIndicator = false
    collectionView.register(AutocompleteCell.self, forCellWithReuseIdentifier: AutocompleteCell.reuseID)
    collectionView.dataSource = self
    collectionView.delegate = self
    addSubview(collectionView)
    collectionView.scrollsToTop = false
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  func autocompleteText(at indexPath: IndexPath) -> String {
    return dataSource!.autoCompleteText(at: indexPath.row)
  }
  
}

extension AutocompleteAccessoryView: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let text = autocompleteText(at: indexPath)
    return AutocompleteCell.size(text: text)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
  }
}

extension AutocompleteAccessoryView: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataSource?.autocompleteTextCount ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let text = autocompleteText(at: indexPath)
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AutocompleteCell.reuseID, for: indexPath) as! AutocompleteCell
    cell.configure(text: text)
    return cell
  }
}

extension AutocompleteAccessoryView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let text = autocompleteText(at: indexPath)
    tapHandler?(text)
  }
}

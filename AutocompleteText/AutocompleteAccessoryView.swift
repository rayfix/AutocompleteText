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
  static let font = UIFont.systemFontOfSize(16)
  static let backgroundColor = UIColor(white: 0.95, alpha: 1)
  static let textColor = UIColor(white: 0.3, alpha: 1)
  
  var label: UILabel?
  
  var text: String = "" {
    didSet {
        label?.text = text
    }
  }
  
  func configure(text text: String) {
    self.text = text
  }
  
  func commonInit() {
    backgroundColor = AutocompleteCell.backgroundColor
    layer.cornerRadius = AutocompleteCell.cornerRadius
    clipsToBounds = true
    let labelFrame = UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: AutocompleteCell.padding, bottom: 0, right: AutocompleteCell.padding))
    let label = UILabel(frame: labelFrame)
    label.autoresizingMask = [.FlexibleWidth]
    label.adjustsFontSizeToFitWidth = false
    label.lineBreakMode = .ByClipping
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
  
  private override func intrinsicContentSize() -> CGSize {
    return AutocompleteCell.size(text: text)
  }
  
  static func size(text text: String) -> CGSize {
    let textWidth = text.sizeWithAttributes([NSFontAttributeName: AutocompleteCell.font]).width
    let itemSize = CGSize(width: textWidth + 2*AutocompleteCell.padding, height: AutocompleteCell.buttonHeight)
    return itemSize
  }
}

class AutocompleteAccessoryView: UIView {
  var dataSource: AutocompleteDataSource?
  var tapHandler: ((String)->Void)?
  
  init(dataSource: AutocompleteDataSource, tapHandler:(String)->Void) {
    self.dataSource = dataSource
    self.tapHandler = tapHandler
    super.init(frame:CGRect(x: 0, y: 0, width: 0, height: 44))
    commonInit()
  }
  
  func commonInit() {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .Horizontal
    flowLayout.minimumLineSpacing = 10
    flowLayout.minimumInteritemSpacing = 10
    
    let collectionView = UICollectionView(frame: bounds, collectionViewLayout: flowLayout)
    collectionView.backgroundColor = .whiteColor()
    collectionView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    collectionView.allowsMultipleSelection = false
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.showsVerticalScrollIndicator = false
    collectionView.registerClass(AutocompleteCell.self, forCellWithReuseIdentifier: AutocompleteCell.reuseID)
    collectionView.dataSource = self
    collectionView.delegate = self
    addSubview(collectionView)
    collectionView.scrollsToTop = false
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  func autocompleteText(at indexPath: NSIndexPath) -> String {
    return dataSource!.autoCompleteText(at: indexPath.row)
  }
  
}

extension AutocompleteAccessoryView: UICollectionViewDelegateFlowLayout {
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    let text = autocompleteText(at: indexPath)
    return AutocompleteCell.size(text: text)
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
  }
}

extension AutocompleteAccessoryView: UICollectionViewDataSource {
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataSource?.autocompleteTextCount ?? 0
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let text = autocompleteText(at: indexPath)
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(AutocompleteCell.reuseID, forIndexPath: indexPath) as! AutocompleteCell
    cell.configure(text: text)
    return cell
  }
}

extension AutocompleteAccessoryView: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let text = autocompleteText(at: indexPath)
    tapHandler?(text)
  }
}

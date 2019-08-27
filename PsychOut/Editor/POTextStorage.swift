//
//  POTextStorage.swift
//  PsychOut
//
//  Created by Chirag Davé on 8/26/19.
//  Copyright © 2019 Super Catilac, Inc. All rights reserved.
//

import Foundation
import AppKit

class POTextStorage : NSTextStorage {
  private var storage: NSMutableAttributedString
  
  override init() {
    storage = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor : NSColor.green])
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("\(#function) is not supported")
  }
  
  required init?(pasteboardPropertyList propertyList: Any, ofType type: NSPasteboard.PasteboardType) {
    fatalError("\(#function) is not supported")
  }
  
  // MARK - Required for subclassing
  
  override var string: String {
    return storage.string
  }

  override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedString.Key : Any] {
    return storage.attributes(at: location, effectiveRange: range)
  }
  
  override func replaceCharacters(in range: NSRange, with str: String) {
    beginEditing()
      storage.replaceCharacters(in: range, with: str)
      edited(.editedCharacters, range: range, changeInLength: str.count - range.length)
    endEditing()
  }
  
  override func setAttributes(_ attrs: [NSAttributedString.Key : Any]?, range: NSRange) {
    beginEditing()
      storage.setAttributes(attrs, range: range)
      edited(.editedAttributes, range: range, changeInLength: 0)
    endEditing()
  }
}

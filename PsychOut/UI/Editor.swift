//
//  Editor.swift
//  PsychOut
//
//  Created by Chirag Davé on 8/21/19.
//  Copyright © 2019 Super Catilac, Inc. All rights reserved.
//

import Foundation
import AppKit

class Editor : NSScrollView {
  var textView: NSTextField!
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    borderType = .bezelBorder
    textView = NSTextField(frame: NSRect(x: 0, y: 0, width: frame.width, height: frame.height))
    documentView = textView
  }
  
  func setText(text: String) {
    textView.stringValue = text
    print("Setting editor text to: \(text)")
  }
}

//
//  Editor.swift
//  PsychOut
//
//  Created by Chirag Davé on 8/21/19.
//  Copyright © 2019 Super Catilac, Inc. All rights reserved.
//

import Foundation
import AppKit

protocol Shader {
  func getCode() -> String
}

class Editor : NSScrollView, Shader {
  var textView: NSTextField!
  public weak var renderer: Renderer?
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    borderType = .bezelBorder
    textView = NSTextField(frame: NSRect(x: 0, y: 0, width: frame.width, height: 2*frame.height))
    textView.delegate = self
    documentView = textView
  }
  
  func setText(text: String) {
    textView.stringValue = text
  }
  
  func getCode() -> String {
    return textView.stringValue
  }
}

extension Editor : NSTextFieldDelegate {
  func controlTextDidChange(_ obj: Notification) {
    renderer?.updatePipelineState()
  }
}

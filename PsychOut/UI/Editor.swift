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
  var textView: NSTextView!
  public weak var renderer: Renderer?
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    textView = NSTextView(frame: NSRect(x: 0, y: 0, width: frame.width, height: 2*frame.height))
    textView.typingAttributes = [NSAttributedString.Key.backgroundColor: NSColor(calibratedRed: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)]
    textView.delegate = self
    textView.textColor = NSColor.white
    textView.backgroundColor = NSColor(calibratedHue: 1.0, saturation: 1.0, brightness: 1.0, alpha: 0)
    documentView = textView
  }
  
  func setText(text: String) {
    textView.string = text
  }
  
  func getCode() -> String {
    return textView.string
  }
}

extension Editor : NSTextViewDelegate, NSTextDelegate {
  func textDidChange(_ notification: Notification) {
    renderer?.updatePipelineState()
  }
}

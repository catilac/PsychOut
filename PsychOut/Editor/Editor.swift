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
//  private var textStorage: POTextStorage!
  
  private func initTextView() {
//    textStorage = POTextStorage()
//    let layoutManager = NSLayoutManager()
//    let textContainer = NSTextContainer(containerSize: frame.size)
//
//    textStorage.addLayoutManager(layoutManager)
//    layoutManager.addTextContainer(textContainer)
    
    textView = NSTextView(frame: NSRect(x: 0, y: 0, width: frame.width, height: frame.height))//,
//                          textContainer: textContainer)
    textView.typingAttributes = [NSAttributedString.Key.backgroundColor: NSColor(calibratedRed: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)]
    textView.delegate = self
    textView.textColor = NSColor.white
    textView.backgroundColor = NSColor(calibratedHue: 1.0, saturation: 1.0, brightness: 1.0, alpha: 0)
    
    if let font = NSFont(name: "Courier", size: 13.0) {
      textView.font = font
    } else {
      print("DEBUG: FONT NOT FOUND")
    }
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    initTextView()
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

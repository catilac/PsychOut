//
//  ViewController.swift
//  PsychOut
//
//  Created by Chirag Davé on 8/20/19.
//  Copyright © 2019 Super Catilac, Inc. All rights reserved.
//

import Cocoa
import MetalKit

class ViewController: NSViewController {
  var renderer: Renderer?
  
  @IBOutlet weak var metalView: MTKView?
  @IBOutlet weak var editor: Editor?

  override func viewDidLoad() {
    super.viewDidLoad()

    guard let metalView = metalView else {
      fatalError("metalView not setup in storyboard")
    }

    setDefaultCode()
    
    renderer = Renderer()
    editor?.renderer = renderer
    renderer?.computeShader = editor
    metalView.device = renderer?.device
    
    // So we can write to textures via compute shader
    metalView.framebufferOnly = false
    
    metalView.delegate = renderer
  }

  override var representedObject: Any? {
    didSet {
    // Update the view, if already loaded.
    }
  }
  
  // MARK: Private Functions
  
  private func setDefaultCode() {
    if let filepath = Bundle.main.path(forResource: "DefaultShader", ofType: nil) {
      do {
        let code = try String(contentsOfFile: filepath)
        editor?.setText(text: code)
      } catch {
        print(error)
      }
    } else {
      fatalError("Could not load default shader")
    }
  }


}


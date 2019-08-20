//
//  Renderer.swift
//  PsychOut
//
//  Created by Chirag Davé on 8/20/19.
//  Copyright © 2019 Super Catilac, Inc. All rights reserved.
//

import MetalKit

class Renderer : NSObject {
  public var device: MTLDevice!
  var queue: MTLCommandQueue!
  var pipelineState: MTLComputePipelineState!
  var time: Float = 0
  
  override init() {
    device = MTLCreateSystemDefaultDevice()!
    guard let library = device.makeDefaultLibrary(),
          let kernel = library.makeFunction(name: "compute") else {
      fatalError("Could not create default library and kernel")
    }
    
    do {
      try pipelineState = device.makeComputePipelineState(function: kernel)
    } catch {
      print(error.localizedDescription)
    }
    
    queue = device.makeCommandQueue()
    
    super.init()
  }
}

extension Renderer : MTKViewDelegate {
  func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    print(size.width, size.height)
  }
  
  func draw(in view: MTKView) {
    time += 0.01
    guard let commandBuffer = queue.makeCommandBuffer(),
      let commandEncoder = commandBuffer.makeComputeCommandEncoder(),
      let drawable = view.currentDrawable else { fatalError("HELP") }

    commandEncoder.setComputePipelineState(pipelineState)
    commandEncoder.setTexture(drawable.texture, index: 0)
    commandEncoder.setBytes(&time, length: MemoryLayout<Float>.size, index: 0)

    let w = pipelineState.threadExecutionWidth
    let h = pipelineState.maxTotalThreadsPerThreadgroup / w
    let threadsPerGroup = MTLSizeMake(w, h, 1)
    let threadsPerGrid = MTLSizeMake(Int(view.drawableSize.width),
                                     Int(view.drawableSize.height), 1)
    
    commandEncoder.dispatchThreads(threadsPerGrid, threadsPerThreadgroup: threadsPerGroup)
    commandEncoder.endEncoding()
    
    commandBuffer.present(drawable)
    commandBuffer.commit()
  }
}

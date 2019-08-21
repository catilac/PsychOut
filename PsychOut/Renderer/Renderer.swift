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
  var pipelineState: MTLComputePipelineState?
  var time: Float = 0
  
  public var computeShader: Shader! {
    didSet {
      createNewPipelineState(shader: computeShader)
    }
  }
  public var fragmentShader: Shader!
  public var vertexShader: Shader!
  
  override init() {
    device = MTLCreateSystemDefaultDevice()!
    queue = device.makeCommandQueue()
    super.init()
  }
  
  private func createNewPipelineState(shader: Shader) {
    // TODO do this not on the main thread
    do {
      let library = try device.makeLibrary(source: shader.getCode(), options: nil)
      guard let kernel = library.makeFunction(name: "compute") else { fatalError() }
      pipelineState = try device.makeComputePipelineState(function: kernel)
    } catch {
      print(error.localizedDescription)
    }
  }
  
  public func updatePipelineState() {
    print("DEBUG: UPDATE PIPELINE STATE...")
    createNewPipelineState(shader: computeShader)
    print("...DONE!")
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

    if let pipelineState = pipelineState {
      commandEncoder.setComputePipelineState(pipelineState)
      commandEncoder.setTexture(drawable.texture, index: 0)
      commandEncoder.setBytes(&time, length: MemoryLayout<Float>.size, index: 0)

      let w = pipelineState.threadExecutionWidth
      let h = pipelineState.maxTotalThreadsPerThreadgroup / w
      let threadsPerGroup = MTLSizeMake(w, h, 1)
      let threadsPerGrid = MTLSizeMake(Int(view.drawableSize.width),
                                       Int(view.drawableSize.height), 1)
      
      commandEncoder.dispatchThreads(threadsPerGrid, threadsPerThreadgroup: threadsPerGroup)
    }
    
    commandEncoder.endEncoding()
    
    commandBuffer.present(drawable)
    commandBuffer.commit()
  }
}

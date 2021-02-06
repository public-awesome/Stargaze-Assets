//
//  Renderer.swift
//  Example Shared
//
//  Created by Reza Ali on 8/22/19.
//  Copyright © 2019 Reza Ali. All rights reserved.
//

import Metal
import MetalKit

import Forge
import Satin
#if os(macOS) || os(iOS)
import Youi
#endif

class BlobMaterial: LiveMaterial {}

class Renderer: Forge.Renderer, MaterialDelegate {
    var assetsURL: URL {
        let url = Bundle.main.resourceURL!
        return url.appendingPathComponent("Assets")
    }
    
    var pipelinesURL: URL {
        assetsURL.appendingPathComponent("Pipelines")
    }
    
    lazy var blobMaterial: BlobMaterial = {
        let material = BlobMaterial(pipelinesURL: pipelinesURL)
        material.delegate = self
        return material
    }()
    
    #if os(macOS) || os(iOS)
    var inspectorWindow: InspectorWindow?
    var _updateInspector: Bool = true
    #endif
    
    var observers: [NSKeyValueObservation] = []
    
    var bgColorParam = Float4Parameter("Background", [1, 1, 1, 1], .colorpicker)
    var blobVisibleParam = BoolParameter("Show Blob", true, .toggle)
    
    lazy var appParams: ParameterGroup = {
        let params = ParameterGroup("Controls")
        params.append(bgColorParam)
        params.append(blobVisibleParam)
        return params
    }()
    
    lazy var blobMesh: Mesh = {
        let mesh = Mesh(geometry: IcoSphereGeometry(radius: 2.0, res: 5), material: blobMaterial)
        return mesh
    }()
    
    lazy var scene: Object = {
        let scene = Object()
        scene.add(blobMesh)
        return scene
    }()
    
    lazy var context: Context = {
        Context(device, sampleCount, colorPixelFormat, depthPixelFormat, stencilPixelFormat)
    }()
    
    lazy var camera: PerspectiveCamera = {
        let camera = PerspectiveCamera()
        camera.position = simd_make_float3(0.0, 0.0, 10.0)
        camera.near = 0.01
        camera.far = 100.0
        return camera
    }()
    
    lazy var cameraController: PerspectiveCameraController = {
        PerspectiveCameraController(camera: camera, view: mtkView)
    }()
    
    lazy var renderer: Satin.Renderer = {
        let renderer = Satin.Renderer(context: context, scene: scene, camera: camera)
        renderer.setClearColor(bgColorParam.value)
        return renderer
    }()
    
    lazy var startTime: CFAbsoluteTime = {
        CFAbsoluteTimeGetCurrent()
    }()
    
    override func setupMtkView(_ metalKitView: MTKView) {
        metalKitView.sampleCount = 1
        metalKitView.depthStencilPixelFormat = .depth32Float
        metalKitView.preferredFramesPerSecond = 60
    }
    
    override init() {
        // do stuff here
    }
    
    override func setup() {
        // or do stuff here
        setupObservers()
    }
    
    func getTime() -> Float {
        return Float(CFAbsoluteTimeGetCurrent() - startTime)
    }

    
    override func update() {
        blobMaterial.set("Time", getTime())
        cameraController.update()
        #if os(macOS) || os(iOS)
            updateInspector()
        #endif
    }
    
    override func draw(_ view: MTKView, _ commandBuffer: MTLCommandBuffer) {
        guard let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
        renderer.draw(renderPassDescriptor: renderPassDescriptor, commandBuffer: commandBuffer)
    }
    
    override func resize(_ size: (width: Float, height: Float)) {
        camera.aspect = size.width / size.height
        renderer.resize(size)
    }
    
    func updated(material: Material) {
        print("Material Updated: \(material.label)")
        #if os(macOS) || os(iOS)
            _updateInspector = true
        #endif
    }
    
    #if os(macOS)
    override func keyDown(with event: NSEvent) {
        if event.characters == "e" {
            openEditor()
        }
    }
    #endif
}

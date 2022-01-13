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

class Renderer: Forge.Renderer, MaterialDelegate {
    class TextMaterial: LiveMaterial {}
    
    // MARK: - Paths

    var assetsURL: URL {
        getDocumentsAssetsDirectoryURL()
    }

    var mediaURL: URL {
        getDocumentsMediaDirectoryURL()
    }

    var modelsURL: URL {
        getDocumentsMediaDirectoryURL()
    }

    var parametersURL: URL {
        getDocumentsParametersDirectoryURL()
    }

    var pipelinesURL: URL {
        getDocumentsPipelinesDirectoryURL()
    }

    var presetsURL: URL {
        getDocumentsPresetsDirectoryURL()
    }

    var settingsFolderURL: URL {
        getDocumentsSettingsDirectoryURL()
    }

    var texturesURL: URL {
        getDocumentsTexturesDirectoryURL()
    }

    var dataURL: URL {
        getDocumentsDataDirectoryURL()
    }

    var paramKeys: [String] {
        return [
            "Controls",
            "Text Material"
        ]
    }

    var params: [String: ParameterGroup?] {
        return [
            "Controls": appParams,
            "Text Material": textMaterial.parameters
        ]
    }

    lazy var textMaterial: TextMaterial = {
        let material = TextMaterial(pipelinesURL: pipelinesURL)
        material.delegate = self
        return material
    }()

    #if os(macOS) || os(iOS)
    var inspectorWindow: InspectorWindow?
    var _updateInspector: Bool = true
    #endif

    var _updateWindow = false

    var fontList: [String] {
        [
            "BarlowSemiCondensed-Medium",
            "Dosis-Medium",
            "Futura-Medium",
            "AtkinsonHyperlegible-Regular",
            "Audiowide-Regular",
            "BellotaText-Regular",
            "DarkerGrotesque-Regular",
            "DMSans-Regular",
            "DMSerifDisplay-Regular",
            "Goldman-Regular",
            "Iceland-Regular",
            "Inter-Regular",
            "JockeyOne-Regular",
            "KronaOne-Regular",
            "KumbhSans-Regular",
            "LexendDeca-Regular",
            "MajorMonoDisplay-Regular",
            "Megrim",
            "Montserrat-Regular",
            "Mulish-Regular",
            "MuseoSans-500",
            "NTR",
            "Padauk-Regular",
            "Poppins-Regular",
            "Questrial-Regular",
            "Raleway-Regular",
            "RedHatDisplay-Regular",
            "RedHatText-Regular",
            "Righteous-Regular",
            "RussoOne-Regular",
            "SecularOne-Regular",
            "SFProRounded-Regular",
            "Sunflower-Medium",
            "Teko-Regular",
            "Urbanist-Regular",
            "Vidaloka-Regular"
        ]
    }

    lazy var bgColorParam: Float4Parameter = {
        Float4Parameter("Background", [1, 1, 1, 1], .colorpicker) { [unowned self] value in
            renderer.setClearColor(value)
        }
    }()

    lazy var fontSizeParam: FloatParameter = {
        var param = FloatParameter("Font Size", 12, .inputfield) { [unowned self] value in
            textGeometry.fontSize = value
        }
        return param
    }()

    lazy var fontParam: StringParameter = {
        var param = StringParameter("Font", "Righteous-Regular", fontList) { [unowned self] value in
            textGeometry.fontName = value
        }
        return param
    }()

    lazy var textParam: StringParameter = {
        var param = StringParameter("Text", "STARGAZE", .inputfield) { [unowned self] value in
            textGeometry.text = value
        }
        return param
    }()

    var exportScaleParam = IntParameter("Export Scale", 4, .inputfield)
    lazy var windowPosition: Int2Parameter = {
        Int2Parameter("Position", simd_make_int2(500, 500), .inputfield) { [unowned self] _ in
            _updateWindow = true
        }
    }()

    lazy var windowSize: Int2Parameter = {
        Int2Parameter("Window Size", simd_make_int2(500, 500), .inputfield) { [unowned self] _ in
            _updateWindow = true
        }
    }()

    lazy var appParams: ParameterGroup = {
        let params = ParameterGroup("Controls")
        params.append(bgColorParam)
        params.append(fontParam)
        params.append(fontSizeParam)
        params.append(textParam)
        params.append(exportScaleParam)
        params.append(windowSize)
        return params
    }()

    lazy var textGeometry: TextGeometry = {
        TextGeometry(text: textParam.value, fontName: fontParam.value, fontSize: fontSizeParam.value)
    }()

    lazy var textMesh: Mesh = {
        let mesh = Mesh(geometry: textGeometry, material: textMaterial)
        mesh.preDraw = { [unowned self] _ in
            let bb = mesh.worldBounds
            self.textMaterial.set("Bounds", simd_make_float4(bb.min.x, bb.min.y, bb.max.x, bb.max.y))
            self.textMaterial.update()
        }
        return mesh
    }()

    lazy var scene: Object = {
        let scene = Object()
        scene.add(textMesh)
        return scene
    }()

    lazy var context: Context = {
        Context(device, sampleCount, colorPixelFormat, depthPixelFormat, stencilPixelFormat)
    }()

    lazy var camera: OrthographicCamera = {
        OrthographicCamera()
    }()

    lazy var cameraController: OrthographicCameraController = {
        OrthographicCameraController(camera: camera, view: mtkView, defaultZoom: 0.0375)
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
        metalKitView.sampleCount = 4
        metalKitView.depthStencilPixelFormat = .invalid
        metalKitView.preferredFramesPerSecond = 60
    }

    deinit {
        save()
    }

    override func setup() {
        load()
    }

    func getTime() -> Float {
        return Float(CFAbsoluteTimeGetCurrent() - startTime)
    }

    override func update() {
#if os(macOS)
        updateWindow()
#endif
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
        cameraController.resize(size)
        renderer.resize(size)
#if os(macOS)
        updateWindowParams()
#endif
    }

    func updated(material: Material) {
        print("Material Updated: \(material.label)")
        #if os(macOS) || os(iOS)
        _updateInspector = true
        #endif
    }
}

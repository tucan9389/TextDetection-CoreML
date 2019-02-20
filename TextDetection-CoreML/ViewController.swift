//
//  ViewController.swift
//  TextDetection-CoreML
//
//  Created by GwakDoyoung on 21/02/2019.
//  Copyright © 2019 tucan9389. All rights reserved.
//

import UIKit
import Vision
import CoreMedia

class ViewController: UIViewController {

    // MARK: - UI Properties
    @IBOutlet weak var videoPreview: UIView!
    @IBOutlet weak var drawingView: DrawingView!
    
    @IBOutlet weak var inferenceLabel: UILabel!
    @IBOutlet weak var etimeLabel: UILabel!
    @IBOutlet weak var fpsLabel: UILabel!
    
    // MARK: - Vision 프로퍼티
    var request: VNDetectTextRectanglesRequest?
    
    // MARK - Performance Measurement Property
    private let 👨‍🔧 = 📏()
    
    // MARK: - AV Property
    var videoCapture: VideoCapture!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup the model
        setUpModel()
        
        // setup camera
        setUpCamera()
        
        // setup delegate for performance measurement
        👨‍🔧.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.videoCapture.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.videoCapture.stop()
    }
    
    // MARK: - Setup Core ML
    func setUpModel() {
        let request = VNDetectTextRectanglesRequest(completionHandler: self.visionRequestDidComplete)
        request.reportCharacterBoxes = true
        self.request = request
    }
    
    // MARK: - SetUp Video
    func setUpCamera() {
        videoCapture = VideoCapture()
        videoCapture.delegate = self
        videoCapture.fps = 30
        videoCapture.setUp(sessionPreset: .vga640x480) { success in
            
            if success {
                // add preview view on the layer
                if let previewLayer = self.videoCapture.previewLayer {
                    self.videoPreview.layer.addSublayer(previewLayer)
                    self.resizePreviewLayer()
                }
                
                // start video preview when setup is done
                self.videoCapture.start()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resizePreviewLayer()
    }
    
    func resizePreviewLayer() {
        videoCapture.previewLayer?.frame = videoPreview.bounds
    }
}

// MARK: - VideoCaptureDelegate
extension ViewController: VideoCaptureDelegate {
    func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame pixelBuffer: CVPixelBuffer?, timestamp: CMTime) {
        // the captured image from camera is contained on pixelBuffer
        if let pixelBuffer = pixelBuffer {
            // start of measure
            self.👨‍🔧.🎬👏()
            
            // predict!
            self.predictUsingVision(pixelBuffer: pixelBuffer)
        }
    }
}

extension ViewController {
    func predictUsingVision(pixelBuffer: CVPixelBuffer) {
        // Vision이 입력이미지를 자동으로 크기조정을 해줄 것임.
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        if let request = request {
            try? handler.perform([request])
        }
    }
    
    func visionRequestDidComplete(request: VNRequest, error: Error?) {
        self.👨‍🔧.🏷(with: "endInference")
        guard let observations = request.results else {
            // end of measure
            self.👨‍🔧.🎬🤚()
            return
        }
        
        DispatchQueue.main.async {
            let regions: [VNTextObservation?] = observations.map({$0 as? VNTextObservation})
            
            self.drawingView.regions = regions
            
//            // self.videoPreview.layer.sublayers?.removeSubrange(1...)
//
//            for region in regions {
//                guard let rg = region else {
//                    continue
//                }
//
////                self.highlightWord(box: rg)
//
//                if let boxes = region?.characterBoxes {
//                    self.drawingView.boxes = boxes
////                    for characterBox in boxes {
////                        self.highlightLetters(box: characterBox)
////                    }
//                }
//            }
            
            // end of measure
            self.👨‍🔧.🎬🤚()
        }
    }
    
//    func highlightWord(box: VNTextObservation) {
//        guard let boxes = box.characterBoxes else { return }
//        guard let imageView = videoPreview else { return }
//
//        var maxX: CGFloat = 9999.0
//        var minX: CGFloat = 0.0
//        var maxY: CGFloat = 9999.0
//        var minY: CGFloat = 0.0
//
//        for char in boxes {
//            if char.bottomLeft.x < maxX {
//                maxX = char.bottomLeft.x
//            }
//            if char.bottomRight.x > minX {
//                minX = char.bottomRight.x
//            }
//            if char.bottomRight.y < maxY {
//                maxY = char.bottomRight.y
//            }
//            if char.topRight.y > minY {
//                minY = char.topRight.y
//            }
//        }
//
//        let xCord = maxX * imageView.frame.size.width
//        let yCord = (1 - minY) * imageView.frame.size.height
//        let width = (minX - maxX) * imageView.frame.size.width
//        let height = (minY - maxY) * imageView.frame.size.height
//
//        let outline = CALayer()
//        outline.frame = CGRect(x: xCord, y: yCord, width: width, height: height)
//        outline.borderWidth = 2.0
//        outline.borderColor = UIColor.red.cgColor
//
//        imageView.layer.addSublayer(outline)
//    }
//
//    func highlightLetters(box: VNRectangleObservation) {
//        guard let imageView = videoPreview else { return }
//
//        let xCord = box.topLeft.x * imageView.frame.size.width
//        let yCord = (1 - box.topLeft.y) * imageView.frame.size.height
//        let width = (box.topRight.x - box.bottomLeft.x) * imageView.frame.size.width
//        let height = (box.topLeft.y - box.bottomLeft.y) * imageView.frame.size.height
//
//        let outline = CALayer()
//        outline.frame = CGRect(x: xCord, y: yCord, width: width, height: height)
//        outline.borderWidth = 1.0
//        outline.borderColor = UIColor.blue.cgColor
//
//        imageView.layer.addSublayer(outline)
//    }
}

// MARK: - 📏(Performance Measurement) Delegate
extension ViewController: 📏Delegate {
    func updateMeasure(inferenceTime: Double, executionTime: Double, fps: Int) {
        //print(executionTime, fps)
        self.inferenceLabel.text = "inference: \(Int(inferenceTime*1000.0)) mm"
        self.etimeLabel.text = "execution: \(Int(executionTime*1000.0)) mm"
        self.fpsLabel.text = "fps: \(fps)"
    }
}

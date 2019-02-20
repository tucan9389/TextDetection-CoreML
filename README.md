# TextDetection-CoreML

![platform-ios](https://img.shields.io/badge/platform-ios-lightgrey.svg)
![swift-version](https://img.shields.io/badge/swift-4.2-red.svg)
![lisence](https://img.shields.io/badge/license-MIT-black.svg)

This project is Text Detection on iOS using [Vision](https://developer.apple.com/documentation/vision) built-in model.<br>If you are interested in iOS + Machine Learning, visit [here](https://github.com/motlabs/iOS-Proejcts-with-ML-Models) you can see various DEMOs.<br>

![TextDetection-CoreML_DEMO001](resource/TextDetection-CoreML_DEMO001.gif)

## Requirements

- Xcode 9.2+
- iOS 12.0+
- Swift 4.2

## Performance

### Inference Time

| device   | inference time |
| -------- | -------------- |
| iPhone X | 10 ms          |

## Build & Run

### 1. Prerequisites

#### Add permission in info.plist for device's camera access

![prerequest_001_plist](/Users/canapio/Project/machine%20learning/MoT%20Labs/github_project/ml-ios-projects/PoseEstimation-CoreML/resource/prerequest_001_plist.png)

### 2. Dependencies

No external library yet.

### 3. Code

#### 3.1 Import Vision framework

```swift
import Vision
```

#### 3.2 Define properties for Vision

```swift
// properties on ViewController
var request: VNDetectTextRectanglesRequest?
```

#### 3.3 Configure and prepare

```swift
override func viewDidLoad() {
    super.viewDidLoad()

	let request = VNDetectTextRectanglesRequest(completionHandler: self.visionRequestDidComplete)
    request.reportCharacterBoxes = true
    self.request = request
}

func visionRequestDidComplete(request: VNRequest, error: Error?) { 
    /* ------------------------------------------------------ */
    /* something postprocessing what you want after inference */
    /* ------------------------------------------------------ */
}
```

#### 3.4 Inference 🏃‍♂️

```swift
// on the inference point
let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
if let request = request {
	try? handler.perform([self.request])
}
```


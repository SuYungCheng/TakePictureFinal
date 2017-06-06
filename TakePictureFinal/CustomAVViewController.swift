//
//  CustomAVViewController.swift
//  TakePictureFinal
//
//  Created by Tim on 2017/6/6.
//  Copyright © 2017年 Tim. All rights reserved.
//

import UIKit
import AVFoundation

class CustomAVViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, AVCapturePhotoCaptureDelegate {

    let captureSession = AVCaptureSession()
    var previewLayer:CALayer!
    
    var captureDevice:AVCaptureDevice!
    var takePhoto = false
    
    /// Method:2.with stillImageOutput
    /*
    let stillImageOutput = AVCaptureStillImageOutput()
    */
    
    /// Method:3.with PhotoOutput
    let cameraOutput = AVCapturePhotoOutput()
    
    @IBAction func takePhoto(_ sender: Any) {
//        takePhoto = true
        
        capturePhoto()
        
        /// Method:2.with stillImageOutput
        /*
 
        if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo) {
            
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (CMSampleBuffer, Error) in
                if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(CMSampleBuffer) {
                    
                    if let cameraImage = UIImage(data: imageData) {
                        
                        UIImageWriteToSavedPhotosAlbum(cameraImage, nil, nil, nil)
                    }
                }
            })
        }*/
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareCamera()
    }
    func prepareCamera() {
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        if let availableDevices = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .back).devices {
            captureDevice = availableDevices.first
            beginSession()
        }
        
    }
    ///Method:2 with stillImageOutput and 3. Photo Output
    /**/
    func beginSession () {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            // input
            captureSession.addInput(captureDeviceInput)
            /// stillImageOutput
            /*
            stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
            
            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
            }*/
            /// Photo Output
            if captureSession.canAddOutput(cameraOutput) {
                captureSession.addOutput(cameraOutput)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        if let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) { //預覽層
            self.previewLayer = previewLayer
            self.view.layer.addSublayer(self.previewLayer)
            self.previewLayer.frame = self.view.layer.frame
            captureSession.startRunning()
            
        }
    }
 
    func capturePhoto() {
        
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                             kCVPixelBufferWidthKey as String: 160,
                             kCVPixelBufferHeightKey as String: 160]
        settings.previewPhotoFormat = previewFormat
        self.cameraOutput.capturePhoto(with: settings, delegate: self)
        
    }
    
    
    ///with VideoDataOutput
    /*
 
    func beginSession () {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(captureDeviceInput)
        } catch {
            print(error.localizedDescription)
        }
        
        if let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) { //預覽層
            self.previewLayer = previewLayer
            self.view.layer.addSublayer(self.previewLayer)
            self.previewLayer.frame = self.view.layer.frame
            captureSession.startRunning()
            
            let dataOutput = AVCaptureVideoDataOutput()
            dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString):NSNumber(value:kCVPixelFormatType_32BGRA)]
            dataOutput.alwaysDiscardsLateVideoFrames = true
            if captureSession.canAddOutput(dataOutput) {
                captureSession.addOutput(dataOutput)
            }
            captureSession.commitConfiguration()
            
            let queue = DispatchQueue(label: "com.dcview.captureQueue")
            dataOutput.setSampleBufferDelegate(self, queue: queue)
            
        }
    }
 */
    ///with PhotoOutput
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let error = error {
            print(error.localizedDescription)
        }
        
        if let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
            print(dataImage)
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        if takePhoto {
            print("take pics")
            takePhoto = false
            // getImageFromSampleBuffer
            
            if let image = self.getImageFromSampleBuffer(buffer: sampleBuffer) {
                let photoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoVC") as! PhotoViewController
                photoVC.takenPhoto = image
                DispatchQueue.main.async {
                    self.present(photoVC, animated: true, completion: {
                        self.stopCaptureSession()
                    })
                    
                    
                }
            }
        }
        
    }
    
    
    func getImageFromSampleBuffer(buffer:CMSampleBuffer) -> UIImage? {
        
        /*
        guard let imageBuffer = CMSampleBufferGetImageBuffer(buffer) else {
            return nil
        }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
        */
        
        if let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) {
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let context = CIContext()
            
            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
            
            if let image = context.createCGImage(ciImage, from: imageRect) {
                return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
                
            }
        }
        return nil
    }
    
    func stopCaptureSession() {
        self.captureSession.stopRunning()
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                self.captureSession.removeInput(input)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

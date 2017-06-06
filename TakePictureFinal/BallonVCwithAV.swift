//
//  BallonVCwithAV.swift
//  TakePictureFinal
//
//  Created by Tim on 2017/6/6.
//  Copyright © 2017年 Tim. All rights reserved.
//

import UIKit
import AVFoundation

class BallonVCwithAV: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetMedium
        
        let captureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        captureVideoPreviewLayer?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        let camScaleup : CGFloat = 1.8
        captureVideoPreviewLayer?.setAffineTransform(CGAffineTransform(scaleX: camScaleup, y: camScaleup))
        self.view.layer.addSublayer(captureVideoPreviewLayer!)
        
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if (session.canAddInput(input)) {
                let stillImageOutput = AVCaptureStillImageOutput()
                let outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
                stillImageOutput.outputSettings = outputSettings
                session.addOutput(stillImageOutput)
                session.startRunning()
            }
            
        } catch let error as NSError {
            print(error)
        }
        
        
        
        // 创建执行动画的Image View对象
        let imageView = UIImageView(frame: self.view.frame)
        
        var array1 = [AnyObject]()
        var array2 = [AnyObject]()
        
        for i in 10...40 {
            let fileName1 = "100\(i)"
            let img1 = UIImage(named: fileName1)
            array1.append(img1!)
            
            let fileName2 = "100\(50-i)"
            let img2 = UIImage(named: fileName2)
            array2.append(img2!)
        }
        
        
        array1 += array2
        
        imageView.animationImages = array1 as! [UIImage]
        imageView.animationDuration = 1.75
        imageView.animationRepeatCount = 0
        imageView.startAnimating()
        
        self.view.addSubview(imageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

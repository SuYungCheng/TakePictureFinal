//
//  BallonVC.swift
//  TakePictureFinal
//
//  Created by Tim on 2017/6/6.
//  Copyright © 2017年 Tim. All rights reserved.
//

import UIKit

class BallonVC: UIImagePickerController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.sourceType = .camera
        self.showsCameraControls = false
        
        let camScaleup : CGFloat = 1.8
        
        self.cameraViewTransform = CGAffineTransform(scaleX: camScaleup, y: camScaleup)
        
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
        
    }
    

}

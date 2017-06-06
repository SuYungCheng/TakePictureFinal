//
//  ViewController.swift
//  TakePictureFinal
//
//  Created by Tim on 2017/6/5.
//  Copyright © 2017年 Tim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var imagePicker : UIImagePickerController!
    
    @IBAction func takeImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.imagePicker = UIImagePickerController()
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = true
            self.imagePicker.cameraOverlayView = self.customOverlayView()
            self.imagePicker.showsCameraControls = false
            let camScaleup : CGFloat = 1.8
//            self.imagePicker.cameraViewTransform = CGAffineTransform(translationX: 0.0, y: 50.0)
            self.imagePicker.cameraViewTransform = CGAffineTransform(scaleX: camScaleup, y: camScaleup)
            self.present(self.imagePicker, animated: true, completion: nil)
            
        } else {
            NSLog("照相機不可用。")
        }
    }
    
    func customOverlayView() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 568))
        let shootPictureButton = UIButton(frame: CGRect(x: 180, y: 500, width: 120, height: 44))
        shootPictureButton.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        shootPictureButton.setTitle("拍攝", for: .normal)
        shootPictureButton.setTitleColor(UIColor.white, for: .normal)
        shootPictureButton.addTarget(self.imagePicker, action: #selector(UIImagePickerController.takePicture), for: .touchUpInside)
        view.addSubview(shootPictureButton)
        return view
    } 


    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        var title = ""
        var message = ""
        
        if let error = error {
            title = "Save error"
            message = error.localizedDescription
        } else {
            title = "Picture Saved"
            message = "Success"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) -> Void in
        })
        alert.addAction(confirmAction)
        present(alert, animated: true, completion: nil)
    }
    

}

extension ViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        NSLog("willShow")
    }
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        NSLog("didShow")
    }
    
}

extension ViewController: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imageView.image = originalImage
//        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
//        self.imageView.image = editedImage
        self.imageView.contentMode = .scaleAspectFill
        self.dismiss(animated: true, completion: nil)
        UIImageWriteToSavedPhotosAlbum(originalImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
//        UIImageWriteToSavedPhotosAlbum(editedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
}

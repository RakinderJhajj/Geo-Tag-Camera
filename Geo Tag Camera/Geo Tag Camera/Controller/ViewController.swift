//
//  ViewController.swift
//  Geo Tag Camera
//
//  Created by Rakinder on 20/03/20.
//  Copyright © 2020 Rakinder. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Variable declartion
    var imagePicker     = UIImagePickerController()
    var selectedImage: UIImage?
    var isGallery = Bool()
    
    //MARK: - Outlet declaration
    @IBOutlet weak var btnTakePhoto: UIButton!
    @IBOutlet weak var viewDot: UIView!
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        viewDot.layer.cornerRadius = viewDot.frame.size.height/2
        btnTakePhoto.layer.cornerRadius = btnTakePhoto.frame.size.height/2
    }
    
    //MARK: - Button Actions
    @IBAction func takePhotoClicked(_ sender: Any) {
        openActionSheetForCameraAndGallery()
    }
    
    func moveToNextView(imageData: ImageDetail){
        if #available(iOS 13.0, *) {
            let vc = self.storyboard?.instantiateViewController(identifier: "ImageViewController") as? ImageViewController
            vc?.imageData = imageData
            vc?.imgSelected = selectedImage ?? UIImage()
            self.navigationController?.pushViewController(vc!, animated: true)
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewController") as? ImageViewController
            vc?.imageData = imageData
            vc?.imgSelected = selectedImage ?? UIImage()
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func  openActionSheetForCameraAndGallery(){
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelActionButton = UIAlertAction(title: Constant.String.kCancel, style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelActionButton)
        let saveActionButton = UIAlertAction(title: Constant.String.KCamera, style: .default) { action -> Void in
            self.openCamera()
        }
        actionSheetController.addAction(saveActionButton)
        let deleteActionButton = UIAlertAction(title: Constant.String.KGallery, style: .default) { action -> Void in
            self.openGallary()
        }
        actionSheetController.addAction(deleteActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    //MARK: - Camera
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.delegate = self
            isGallery = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            Alert.addAlertController(strTittle: "", strMessage: Constant.String.kCameraError, viewC: self)
        }
    }
    
    func changeImagePIckerNavColor(){
        imagePicker.navigationBar.barTintColor = UIColor.darkGray
        imagePicker.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Constant.Color.kGreenColor]
    }
    
    //MARK: - Gallery
    func openGallary(){
        changeImagePIckerNavColor()
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        isGallery = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - ImagePicker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let originalImage = info[.originalImage] as? UIImage {
            
            selectedImage = originalImage
            var strDate = String()
            var strLat = String()
            var strLong = String()
            let options = [kCGImageSourceShouldCache as String: kCFBooleanFalse]
            if isGallery{
                if let data = NSData(contentsOf:   info[.imageURL] as! URL), let imgSrc = CGImageSourceCreateWithData(data, options as CFDictionary) {
                    
                    let metadata = CGImageSourceCopyPropertiesAtIndex(imgSrc, 0, options as CFDictionary)
                    if let dict = metadata as? [String: AnyObject] {
                        if  let dicGPS = dict["{GPS}"] as? [String: AnyObject]{
                            strLat = Singleton.sharedInstance.getString(str: dicGPS["Latitude"] as Any)
                            strLong = Singleton.sharedInstance.getString(str: dicGPS["Longitude"] as Any)
                        }
                        if  let dicDateTime = dict["{TIFF}"] as? [String: AnyObject]{
                            if let date = dicDateTime["DateTime"] as? String{
                                strDate = Singleton.sharedInstance.convertDateFormat(strDate: date)
                                print(Singleton.sharedInstance.convertDateFormat(strDate: date))
                            }
                        }
                    }
                }
            }
            let image = ImageDetail(date: strDate, latitude: strLat, longitude: strLong , isFromGallery: isGallery, image: originalImage)
            self.moveToNextView(imageData: image)
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated:true, completion: nil)
    }
}



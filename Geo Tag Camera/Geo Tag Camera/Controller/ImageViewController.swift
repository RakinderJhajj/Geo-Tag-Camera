//
//  ImageViewController.swift
//  Geo Tag Camera
//
//  Created by Rakinder on 20/03/20.
//  Copyright © 2020 Rakinder. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    //MARK: - Outlet declaration
    var imgSelected = UIImage()
    var imageData:  ImageDetail?
    
    //MARK: - Outlet declaration
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnRetake: UIButton!
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imgV.image = imageData?.image
        if imageData?.isFromGallery ?? false{
            let latitude = imageData?.latitude == "" ? "" : "Latitude: \( imageData?.latitude ?? "") \n "
            let longitude = (imageData?.longitude ?? "") == "" ? "" : "Longitude: \( imageData?.longitude ?? "") \n "
            let date = (imageData?.date ?? "") == "" ? "" : "Clicked on: \( imageData?.date ?? "") "
            lblName.text =  latitude + longitude + date
        }
    }
    
    //MARK: - Common Functions
    func takeScreenshot() -> UIImage? {
        var screenshotImage: UIImage?
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        btnSave.isHidden = true
        btnRetake.isHidden = true
        
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        btnSave.isHidden = false
        btnRetake.isHidden = false
        
        return screenshotImage
    }
    
    //MARK: - Button Actions
    @IBAction func saveClicked(_ sender: Any) {
        Singleton.sharedInstance.save(photo: takeScreenshot() ?? UIImage(), toAlbum: Constant.String.KAppName) { (isSuccess, error) in
            if isSuccess{
                DispatchQueue.main.async {
                    Alert.addAlertControllerWithAction(strTittle: Constant.String.kSuccess, strMessage: Constant.String.kSaveImageMessage, strActionTittleFirst: Constant.String.kDone, strActionTittleSecond: "", viewC: self, isSecondAction: false, actionFirst: {_ in
                        self.navigationController!.popViewController(animated: true)
                    }, actionSecond: {_ in
                    })
                }
            }
            else{
                DispatchQueue.main.async {
                    Alert.addAlertController(strTittle: Constant.String.kError, strMessage: Constant.String.kErrorImageMessage, viewC: self)
                }
            }
        }
    }
    
    @IBAction func retakeClicked(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
}

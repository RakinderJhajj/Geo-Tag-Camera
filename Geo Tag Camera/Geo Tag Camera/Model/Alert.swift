//
//  Alert.swift
//  Geo Tag Camera
//
//  Created by Rakinder on 20/03/20.
//  Copyright © 2020 Rakinder. All rights reserved.
//

import UIKit

class Alert: NSObject {
    static func addAlertController(strTittle: String, strMessage: String,viewC: UIViewController){
        
        let alertController = UIAlertController(title: strTittle, message: strMessage, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
        }
        alertController.addAction(OKAction)
        viewC.present(alertController, animated: true)
    }
    
    static func addAlertControllerWithAction(strTittle: String, strMessage: String,strActionTittleFirst: String, strActionTittleSecond: String ,viewC: UIViewController,isSecondAction: Bool, actionFirst:((UIAlertAction) -> Void)?,actionSecond: ((UIAlertAction) -> Void)?){
        
        let alertController = UIAlertController(title: strTittle, message: strMessage, preferredStyle: .alert)
        let firstAction = UIAlertAction(title: strActionTittleFirst, style: .default, handler: actionFirst)
        alertController.addAction(firstAction)
        if(isSecondAction){
            let secondAction = UIAlertAction(title: strActionTittleSecond, style: .default, handler: actionSecond)
            alertController.addAction(secondAction)
        }
        viewC.present(alertController, animated: true)
    }
}

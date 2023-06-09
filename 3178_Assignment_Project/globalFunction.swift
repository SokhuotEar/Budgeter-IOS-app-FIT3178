//
//  globalFunction.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 3/5/2023.
//

import Foundation
import UIKit

let DEFAULT_OTHER = "Default: Other"
let DEFAULT_LENDING = "Default: Lending"
let DEFAULT_REPAYMENT = "Default: Lending repayment"



func displayMessage(controller: UIViewController,title: String, message: String){
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
    controller.present(alertController, animated: true, completion: nil)
}


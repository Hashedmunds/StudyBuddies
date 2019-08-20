//
//  Helper.swift
//  FirebaseAuthenticationUI
//
//  Created by Hashaivione Edmundson on 11/12/18.
//  Copyright © 2018 Frederik Kofoed. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

private let temp: UserModel = UserModel.sharedInstance

class Helper{
   static let helper = Helper()
    
    //swtich to success VC
    func swtichToSuccessVC(){
        
        //createmain storyboard
  
        let storyboard = UIStoryboard(name: "Main",bundle: nil);
    
        //Instantiate success view
        let successVC = storyboard.instantiateViewController(withIdentifier: "SuccessfulLogInVC")
        
        //get the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //set success view controller as root view
        appDelegate.window?.rootViewController = successVC

    }
    
    //log out function
    func logOut(){
        do{
            try Auth.auth().signOut()
            temp.CurrentUser = nil
        }
        catch let error{
            print(error)
        }
        
        
        //switch the log in view
        //createmain storyboard
        
        let storyboard = UIStoryboard(name: "Main",bundle: nil);
        
        //Instantiate success view
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LogIn")
        
        //get the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        //set success view controller as root view
        appDelegate.window?.rootViewController = loginVC
        
        
    }
    
}

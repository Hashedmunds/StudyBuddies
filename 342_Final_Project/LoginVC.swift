//
//  LoginVC.swift
//  342_Final_Project
//
//  Created by Hashaivione Edmundson on 11/20/18.
//  Copyright © 2018 Hashaivione Edmundson. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {

    //IBOutlets
    @IBOutlet weak var UsernameLabel: UITextField!
    @IBOutlet weak var PasswordLabel: UITextField!
    @IBOutlet weak var SubmitButton: UIButton!
    @IBOutlet weak var SignUpButton: UIButton!
    @IBOutlet weak var LabelError: UILabel!
    
    //Singleton
    private let temp: UserModel = UserModel.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SubmitButton.isEnabled = false;
        LabelError.numberOfLines = 0;
        LabelError.adjustsFontSizeToFitWidth = true
        self.PasswordLabel.isSecureTextEntry = true;
        
        //Checks to see if all forms that are required are filled
        self.UsernameLabel.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.PasswordLabel.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
       
        
    }
    
    //Checks to see if text field changed
    @objc func textFieldDidChange(_ textField: UITextField) {
        AllFormsFilled()
    }
    
    //Checks to see if all forms are filled
    func AllFormsFilled(){
        
        //If any fields are empty then keep create account button disabled till filled
        guard let email = UsernameLabel.text else{ return }
        guard let pass = PasswordLabel.text else{ return }
        
        
        if( email.count > 0 && pass.count > 0 ){
            self.SubmitButton.isEnabled = true
        }else{
            self.SubmitButton.isEnabled = false
        }
        
    }
  
    //Keyboard dismisses if background is touched
    @IBAction func BackgroundDismiss(_ sender: UITapGestureRecognizer) {
        
        UsernameLabel.resignFirstResponder()
        PasswordLabel.resignFirstResponder()
        
        // Empty Question text view
        if let tmp = UsernameLabel.text, let tmp2 = PasswordLabel.text {
            enableSubmitButton(usernametext: tmp, passwordtext: tmp2)
        }
        //One or both is nil
        else {
            return
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Empty Question text view
        if let tmp = UsernameLabel.text, let tmp2 = PasswordLabel.text {
        
            enableSubmitButton(usernametext: tmp, passwordtext: tmp2)
        }
        else {
            return false
            // double check
        }
        return true
    }
    
    //Reenables submit button
    func enableSubmitButton(usernametext: String?, passwordtext: String?){
        
        // Empty Question text view
        if let tmp = usernametext, let tmp2 = passwordtext{
            
            if(tmp.count > 0 && tmp2.count > 0){
                self.SubmitButton.isEnabled = true
            }
            else{
                self.SubmitButton.isEnabled = false
            }
        }
        else {
            self.SubmitButton.isEnabled = false
            return
        }
    }
    
    //Handles sign in
    @IBAction func SignIn(_ sender: UIButton) {
        login()
    }
    
    
    //Handles login
    @objc func login(){
        
        guard let email = UsernameLabel.text else { return;}
        guard let pass = PasswordLabel.text else {return;}
        
        Auth.auth().signIn(withEmail: email, password: pass){(user,error) in
  
            //if not log in not succesful
            if error != nil{
                print(error!.localizedDescription)
                
                // display error message
                self.LabelError.text = error!.localizedDescription
                
                //return
                return
                
            }else{
               Helper.helper.swtichToSuccessVC()
            }
        }
        
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

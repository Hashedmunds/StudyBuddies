//
//  SignUpVC.swift
//  342_Final_Project
//
//  Created by Hashaivione Edmundson on 11/20/18.
//  Copyright © 2018 Hashaivione Edmundson. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage



class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate{
    
    @IBOutlet weak var ImageView: UIImageView!
    let picker = UIImagePickerController()
    
    //Firebase Database reference
    var ref: DatabaseReference?
    var hold: String = ""
    var textViewOg: Bool = false
  
    
    //IB Outlets Declared
    @IBOutlet weak var UsernameTF: UITextField!
    @IBOutlet weak var PasswordTF: UITextField!
    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var ClassTV: UITextView!
    @IBOutlet weak var ErrorLabel: UILabel!
    @IBOutlet weak var SchoolLabel: UITextField!
    @IBOutlet weak var CreateButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         picker.delegate = self;
        
        //Gets reference to database
         ref = Database.database().reference()
        
        //School label is listed as other unless school is chosen
        SchoolLabel.text = "Other"
        self.CreateButton.isEnabled = false;
        
        //Checks to see if screen needs to move up
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //Checks to see if all forms that are required are filled
        self.UsernameTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.PasswordTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.EmailTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        AllFormsFilled()
    }
    
    
    //Hides keyboard when click off of keyboard from Class TextView Label
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
    
    //Moves screen up to show Class TextView
    @objc func keyboardWillChange(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.ClassTV.isFirstResponder {
                self.view.frame.origin.y = -keyboardSize.height
            }
        }
    }
    
    
    //Send school data back to SignUp VC to be updated
    @IBAction func UpdateSchoolLabel(_ sender: UIStoryboardSegue) {
        
        if sender.source is CollegeTVC{
            if let CollVC = sender.source as? CollegeTVC{
                self.SchoolLabel.text = CollVC.valueSelected
            }
        }
        
    }

    //Goes to List of colleges for selection
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if(textField == self.SchoolLabel){
           performSegue(withIdentifier: "CollSegue", sender: self)
            return false
        }
        return true
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        AllFormsFilled()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        AllFormsFilled()
        self.UsernameTF.resignFirstResponder()
        self.PasswordTF.resignFirstResponder()
        self.SchoolLabel.resignFirstResponder()
        self.EmailTF.resignFirstResponder()
        self.ClassTV.resignFirstResponder()
        return true
    }
    
    //Image Picker
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImage: UIImage?
        if let editedImage = info[.editedImage] as? UIImage{
            selectedImage = editedImage
            ImageView.image = selectedImage!
            picker.dismiss(animated: true, completion: nil)
        }else if let originalImage = info[.originalImage] as? UIImage{
            selectedImage = originalImage
            ImageView.image = selectedImage!
            picker.dismiss(animated: true, completion: nil)
        }
      
        picker.dismiss(animated: true, completion: nil)
    }
    
    //Opens up gallery for image picking if allowed to
    func openCamera(){
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
           
            self.present(imagePicker,animated: true,completion: nil)
        }
        else{
            let alert = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert,animated: true,completion: nil)
        }
        
    }
    
    //Alert that allows user to click on photo source
    @IBAction func ImageButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: {_ in self.openCamera()
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //Dismisses keyboard anytime user clicks off screen
    @IBAction func TapKeyboardDismiss(_ sender: UITapGestureRecognizer) {
        self.UsernameTF.resignFirstResponder()
        self.PasswordTF.resignFirstResponder()
        self.SchoolLabel.resignFirstResponder()
        self.EmailTF.resignFirstResponder()
        self.ClassTV.resignFirstResponder()
    }
    
    //Erases message in Class TextView when being edited
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.ClassTV.text = "";
        self.textViewOg = true
        AllFormsFilled()
    }
    
    //Calls signup function to create user
    @IBAction func CreatAccountButton(_ sender: UIButton) {
        self.UsernameTF.resignFirstResponder()
        self.EmailTF.resignFirstResponder()
        self.PasswordTF.resignFirstResponder()
        self.ClassTV.resignFirstResponder()
        self.SchoolLabel.resignFirstResponder()
        handleSignUp()
    }
    
    @objc func AddUser(){
        print("Adding user info to database")
    }
    
    //Uploads user crendentials to database
    func upload(profile_pic: URL){
        
        let creds = [
            "name" : self.UsernameTF.text!,
            "email" : self.EmailTF.text!,
            "school" : self.SchoolLabel.text!,
            "profile pic" : profile_pic.absoluteString,
            "classes": self.ClassTV.text!.split(separator: "\n"),
            "ID": Auth.auth().currentUser?.uid as Any
            ] as [String : Any]
        
        let userID = Auth.auth().currentUser?.uid
        self.ref?.child("Users").child(userID!).setValue(creds)
    }
    
    func AllFormsFilled(){
        
        //If any fields are empty then keep create account button disabled till filled
        guard let email = EmailTF.text else{ return }
        guard let username = UsernameTF.text else{ return }
        guard let pass = PasswordTF.text else{ return }
        
        if(email.count > 0 && username.count > 0 && pass.count > 0 && self.textViewOg == true ){
            self.CreateButton.isEnabled = true
        }else{
            self.CreateButton.isEnabled = false
        }
    
    }
    
    
    // declare handle sign up function
    @objc func handleSignUp() {
        
        guard let email = EmailTF.text else{ return }
        guard let pass = PasswordTF.text else{ return }
   
        //create user in Firebase
        Auth.auth().createUser(withEmail: email, password: pass){
            user,error in
            
            //if error = nil and user is != nill
            if error == nil && user != nil{
                //print success
                print("User successfully created")
                
                //resign first responder on TF
                self.UsernameTF.resignFirstResponder()
                self.EmailTF.resignFirstResponder()
                self.PasswordTF.resignFirstResponder()
                self.ClassTV.resignFirstResponder()
                self.SchoolLabel.resignFirstResponder()
                
                
                let storage = Storage.storage()
                
                var data = Data()

                //Check for nil
                data = self.ImageView.image!.pngData()! // image file name
                
                let storageRef = storage.reference()
                let imageRef = storageRef.child(email + ".png")
                _ = imageRef.putData(data, metadata: nil, completion: { (metadata,error ) in
                    imageRef.downloadURL(completion: { url, error in
                        if error != nil{
                            print("Something went wrong")
                            return
                        }else{
                            guard let profile_pic = url else{
                                return
                            }
                            self.upload(profile_pic: profile_pic)
                        }
  
                    })
                })
             
            self.ErrorLabel.textColor = UIColor(red: 0/255, green: 186/255, blue: 24/255, alpha: 1.0)
             self.ErrorLabel.text = "Account was successfully created"
            self.navigationController?.popViewController(animated: true)
         
            }else{
                print("Error: \(error!.localizedDescription)")
                
                //display error message
                self.ErrorLabel.textColor = UIColor(red: 244/255, green: 0/255, blue: 53/255, alpha: 1.0)
                self.ErrorLabel.text = error!.localizedDescription
            }
        }
        
    }
    
}


//
//  AddVC.swift
//  342_Final_Project
//
//  Created by Hashaivione Edmundson on 12/5/18.
//  Copyright © 2018 Hashaivione Edmundson. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import MapKit

class AddVC: UIViewController, UITextViewDelegate, UITextFieldDelegate{
    
    var ref: DatabaseReference?
    
    //Singleton
    private let temp: UserModel = UserModel.sharedInstance
    
    //IBOutlet declared
    @IBOutlet weak var ClassNameLabel: UITextField!
    
    @IBOutlet weak var TitleLabel: UITextField!
    
    @IBOutlet weak var LocationLabel: UITextField!
    
    @IBOutlet weak var DescriptionLabel: UITextView!
    
    @IBOutlet weak var SaveButton: UIBarButtonItem!
    @IBOutlet weak var UndoButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SaveButton.isEnabled = false;
        UndoButton.isEnabled = false;
        ref = Database.database().reference()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
        
        //Checks to see if all forms that are required are filled
        self.ClassNameLabel.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.TitleLabel.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.LocationLabel.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        AllFormsFilled()
        enableUndo()
    
    }
    
    
    //Hides keyboard
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
    
    //Moves screen up when description label is click
    @objc func keyboardWillChange(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.DescriptionLabel.isFirstResponder {
                self.view.frame.origin.y = -keyboardSize.height
            }
        }
    }
    
    
    //Checks to see if all forms filled
    func AllFormsFilled(){
        
        //If any fields are empty then keep create account button disabled till filled
        
        guard let className = ClassNameLabel.text else{
            self.SaveButton.isEnabled = false
            return
        }
        guard let title = TitleLabel.text else{
            self.SaveButton.isEnabled = false
            return
        }
        guard let location = LocationLabel.text else{
            self.SaveButton.isEnabled = false
            return
        }
        
        if(className.count > 0 && title.count > 0 && location.count > 0){
            self.SaveButton.isEnabled = true
        }
        else{
            self.SaveButton.isEnabled = false
        }
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        AllFormsFilled()
        enableUndo()
        self.ClassNameLabel.resignFirstResponder()
        self.TitleLabel.resignFirstResponder()
        self.LocationLabel.resignFirstResponder()
        return true
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        AllFormsFilled()
        enableUndo()
    }
    
    
    //enables or disable undo button
    func enableUndo(){
        
        guard let className = self.ClassNameLabel.text else{
            self.UndoButton.isEnabled = false
            return
        }
        guard let title = self.TitleLabel.text else{
            self.UndoButton.isEnabled = false
            return
        }
        guard let description = self.DescriptionLabel.text else{
            self.UndoButton.isEnabled = false
            return
        }
        guard let location = self.LocationLabel.text else{
            self.UndoButton.isEnabled = false
            return
        }
        
        if(className.count > 0 || title.count > 0 || location.count > 0 || description.count > 0){
            self.UndoButton.isEnabled = true
        }else{
            self.UndoButton.isEnabled = false
        }
        
    }
    
   
    
    //Grabs location from location segue
    @IBAction func LocationUnwindSegue(_ sender: UIStoryboardSegue) {
        
        if sender.source is MapView{
            if let MapViewController = sender.source as? MapView{
                self.LocationLabel.text = MapViewController.AddressLabel.text
                AllFormsFilled()
            }
        }
        
    }

    //Saves creds of newly created event to be uploaded to server
    @IBAction func SaveButton(_ sender: UIBarButtonItem){
        let class_name = self.ClassNameLabel.text
        let title = self.TitleLabel.text
        let description = self.DescriptionLabel.text
        let location = self.LocationLabel.text
        let event_id = NSUUID().uuidString.lowercased()
        
        //Creates event
        let event = [
            "Class Name": class_name,
            "Title": title,
            "Description": description,
            "Location": location,
            "Creator": temp.getName(),
            "ID" : event_id,
            "Creator Image": temp.getProfilePic()
        ]
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.init(abbreviation: "America/Los_Angeles")
        formatter.dateFormat = "MM-dd-yyyy"
        
        let dateString = formatter.string(from: now)
        
        self.ref?.child("Events").child(dateString).child(event_id).setValue(event)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //Undo button alert
    @IBAction func UndoButton(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Warning", message: "Are you sure you want to undo?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: clearall))
         alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert,animated: true,completion: nil)
        
    }
    
    //Clears all fields
    func clearall(alert: UIAlertAction!){
        self.ClassNameLabel.text = ""
        self.DescriptionLabel.text = ""
        self.LocationLabel.text = ""
        self.TitleLabel.text = ""
        self.ClassNameLabel.resignFirstResponder()
        self.DescriptionLabel.resignFirstResponder()
        self.LocationLabel.resignFirstResponder()
        self.TitleLabel.resignFirstResponder()
    }
   
    //Dismisses keyboard if screen is tapped
    @IBAction func TapKeyBoardDismiss(_ sender: UITapGestureRecognizer) {
        self.ClassNameLabel.resignFirstResponder()
        self.DescriptionLabel.resignFirstResponder()
        self.LocationLabel.resignFirstResponder()
        self.TitleLabel.resignFirstResponder()
    }
    

}

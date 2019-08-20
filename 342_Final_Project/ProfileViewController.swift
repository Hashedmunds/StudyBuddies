//
//  ProfileViewController.swift
//  342_Final_Project
//
//  Created by Hashaivione Edmundson on 11/7/18.
//  Copyright © 2018 Hashaivione Edmundson. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth


class ProfileViewController: UIViewController {

    var ref: DatabaseReference?
    
    //Singleton
    private let temp: UserModel = UserModel.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.ClassesLabel.isEditable = false
       
        //Gets current logged in user
        let userID = Auth.auth().currentUser?.uid
        
        ref!.child("Users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            //let username = value?["username"] as? String ?? ""
            //let user = User(username: username)
            
            //Load Name
            let name = value?["name"] as? String ?? ""
            self.NameLabel.text = name
            
            //Load Classes
            let classes = value?["classes"] as? [String] ?? [String]()
            var hold: String = ""
            for i in classes{
                hold = hold + i + "\n"
            }
            
            self.ClassesLabel.text = hold
            
            //Load School
            let school = value?["school"] as? String ?? ""
            self.SchoolLabel.text = school
            
            //Load Profile Pic
            let profile_pic = value?["profile pic"] as? String ?? ""
            let data = NSData(contentsOf: URL(string: profile_pic)!)
            
            self.ProfileImageView.image = UIImage(data: data! as Data)
            
            let email = value?["email"] as? String ?? ""
            
            let id = value?["ID"] as? String ?? ""
            
        self.temp.createUser(name,school,email,classes,id,profile_pic)
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }

        // Do any additional setup after loading the view.
    }
    
    //IBOutlets
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var ProfileImageView: UIImageView!
    
    @IBOutlet weak var SchoolLabel: UILabel!
    
    @IBOutlet weak var ClassesLabel: UITextView!
    
    //Logout function
    @IBAction func LogOut(_ sender: UIBarButtonItem) {
        
        Helper.helper.logOut()
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

//
//  ProfileClickVC.swift
//  342_Final_Project
//
//  Created by Hashaivione Edmundson on 12/5/18.
//  Copyright © 2018 Hashaivione Edmundson. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class ProfileClickVC: UIViewController {

    //IBOutlet declared
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var ProfilePicLabel: UIImageView!
    
    @IBOutlet weak var SchoolLabel: UILabel!
    @IBOutlet weak var ClassesLabel: UITextView!
    
    var user_id: String = ""
    
    var ref: DatabaseReference?
    
    //Singleton
    private let temp: UserModel = UserModel.sharedInstance
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        ref = Database.database().reference()
       
            //Clicked on User profile creds
        ref!.child("Users").child(user_id).observeSingleEvent(of: .value, with: { (snapshot) in
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
            let profilePic = value?["profile pic"] as? String ?? ""
            let data = NSData(contentsOf: URL(string: profilePic)!)
            
            self.ProfilePicLabel.image = UIImage(data: data! as Data)
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    override func viewDidLoad() {
        self.ClassesLabel.isEditable = false
        super.viewDidLoad()
        
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

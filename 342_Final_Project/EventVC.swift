//
//  EventVC.swift
//  342_Final_Project
//
//  Created by Hashaivione Edmundson on 12/5/18.
//  Copyright © 2018 Hashaivione Edmundson. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseCore

class EventVC: UIViewController {
    
    var event_id: String = ""
    var ref: DatabaseReference?
    
    //IBOutlets declared
    @IBOutlet weak var TitleLabel: UILabel!
    
    @IBOutlet weak var LocationLabel: UILabel!
    @IBOutlet weak var CreatorLabel: UILabel!
    @IBOutlet weak var CreatorImage: UIImageView!
    @IBOutlet weak var DescriptionTV: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
         ref = Database.database().reference()
        LoadEvent()
        self.CreatorLabel.adjustsFontSizeToFitWidth = true
        self.LocationLabel.adjustsFontSizeToFitWidth = true
        self.TitleLabel.adjustsFontSizeToFitWidth = true
        self.DescriptionTV.isEditable = false
    
        // Do any additional setup after loading the view.
        
    }
   
    //Grabs events creds from database
    func LoadEvent(){
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.init(abbreviation: "America/Los_Angeles")
        formatter.dateFormat = "MM-dd-yyyy"
        
        let dateString = formatter.string(from: now)
        
        ref!.child("Events").child(dateString).child(event_id).observeSingleEvent(of: .value, with: { (snapshot) in
            

            let valueCheck = snapshot.value as? NSDictionary
            
            //No events of the day
            guard let value = valueCheck else{
                return
            }
            
            //Load Profile Pic
            let profilePic = value["Creator Image"] as? String ?? "No Image"
            let data = NSData(contentsOf: URL(string: profilePic)!)
            let creator = value["Creator"] as? String  ?? "No Creator"
            let location = value["Location"] as? String ?? "No Location"
            let title = value["Title"] as? String ?? "No Tile"
            let description = value["Description"] as? String ?? "No Description"
        
            //Sets respective objects with creds
            self.CreatorImage.image = UIImage(data: data! as Data)
            self.DescriptionTV.text = description
            self.CreatorLabel.text = creator
            self.LocationLabel.text = location
            self.TitleLabel.text = title
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
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

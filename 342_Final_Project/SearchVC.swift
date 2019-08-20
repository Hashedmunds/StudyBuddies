//
//  SearchVC.swift
//  342_Final_Project
//
//  Created by Hashaivione Edmundson on 11/21/18.
//  Copyright © 2018 Hashaivione Edmundson. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth


class SearchVC:UIViewController,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    //IBoutlets declared
    @IBOutlet weak var SearchBarLablel: UISearchBar!
    @IBOutlet weak var TableViewLabel: UITableView!
    @IBOutlet weak var SegBar: UISegmentedControl!
    
    //reference to Firedatabase
    var ref: DatabaseReference?
    
    //Singleton
    private let temp: UserModel = UserModel.sharedInstance
    
    //Unfilterd sessions and users
    //Filtered sessions and users
    var UnfilteredSessions:   [(String,String,String)] =  [(String,String,String)]()
    
    var UnfilteredUsers: [(String,String,String)] =  [(String,String,String)]()
    
    var FilteredSessions:  [(String,String,String)]?
    var FilteredUsers: [(String,String,String)]?

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
       
        // Do any additional setup after loading the view.
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //Users Selected
        if(SegBar.selectedSegmentIndex == 0){
            LoadUnfilteredUsers()
        }
        else{
            LoadUnfilteredSession()
        }

    }
    
    //Load unfiltered array depending on segment bar selections
    @IBAction func SegBarChanged(_ sender: UISegmentedControl) {
        //Users Selected
        if(SegBar.selectedSegmentIndex == 0){
            LoadUnfilteredUsers()
        }
        else{
            LoadUnfilteredSession()
        }
    }
    
    //Load unfiltered users
    func LoadUnfilteredUsers(){
        
        ref!.child("Users").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            //Clear
            self.UnfilteredUsers = [(String,String,String)]()
            
            //Iterates over all keys in users and gets creds
            for (key,_) in value!{
                
                let UserInfo = value?[key] as? NSDictionary
                let UserId = UserInfo?["ID"] as? String ?? ""
                let UserName = UserInfo?["name"] as? String ?? ""
                let UserSchool = UserInfo?["school"] as? String ?? ""
                
            self.UnfilteredUsers.append((UserName,UserSchool,UserId))
            }
            
            self.FilteredUsers = self.UnfilteredUsers.sorted(by: {$0.0 < $1.0})
            self.TableViewLabel.reloadData()
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }
    
    //Loads unfiltered sessions
    func LoadUnfilteredSession(){
        
        //Gets todays date
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.init(abbreviation: "America/Los_Angeles")
        formatter.dateFormat = "MM-dd-yyyy"
        
        let dateString = formatter.string(from: now)
        
        //Clear
        self.UnfilteredSessions =  [(String,String,String)]()
        
        //Gets only events from today
        ref!.child("Events").child(dateString).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            let ValueCheck = snapshot.value as? NSDictionary
            
            //No events of the day
            guard let value = ValueCheck else{
                self.FilteredSessions = self.UnfilteredSessions
                self.TableViewLabel.reloadData()
                return
            }
            
            //Iterates through all keys and gets cred
            for (key,_) in value{
                
                let EventInfo = value[key] as? NSDictionary
                let ClassName = EventInfo?["Class Name"] as? String ?? ""
                let title = EventInfo?["Title"] as? String ?? ""
                let EventId = EventInfo?["ID"] as? String ?? ""
                self.UnfilteredSessions.append((title,ClassName,EventId))
            }
            
           self.FilteredSessions = self.UnfilteredSessions.sorted(by: {$0.1 < $1.1})
            self.TableViewLabel.reloadData()
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }
    
    //Shows cancel button
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    //Hides cancel button
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    //Filters dynamic results
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(SegBar.selectedSegmentIndex == 0){
            if !searchText.isEmpty{
                FilteredUsers = UnfilteredUsers.filter { team in
                    return team.0.lowercased().contains(searchText.lowercased())
                }
                
            } else {
                FilteredUsers = UnfilteredUsers
            }
            
        }
        else{
            if !searchText.isEmpty{
                FilteredSessions = UnfilteredSessions.filter { team in
                    return team.1.lowercased().contains(searchText.lowercased())
                }
                
            } else {
                FilteredSessions = UnfilteredSessions
            }
        }
        
        self.TableViewLabel.reloadData()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(SegBar.selectedSegmentIndex == 0){
            
            guard let results = FilteredUsers else {
                return 0
            }
            return results.count
            
        }else{
            
            guard let results = FilteredSessions else {
                return 0
            }
            return results.count
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath)
        
        //Depending on segment either users or sessions will display
        if(SegBar.selectedSegmentIndex == 0){
            
            if let results = FilteredUsers {
                let team = results[indexPath.row]
                cell.textLabel!.text = team.0
                cell.detailTextLabel!.text = team.1;
            }
            
        }else{
            
            if let results = FilteredSessions {
                let team = results[indexPath.row]
                cell.textLabel!.text = team.0
                cell.detailTextLabel!.text = team.1;
            }
            
        }
        return cell
    }
    
    
    //Performs segue depending if user or session is clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Users Segue
        if(SegBar.selectedSegmentIndex == 0){
            
            performSegue(withIdentifier: "ProfileSegue", sender: self)
            
            
        }else if(SegBar.selectedSegmentIndex == 1){
            
            performSegue(withIdentifier: "SessionSegue", sender: self)
        }
    }
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "AddSegue"){
            //Do nothing
        }
           //Goes to user profile that is selected
        else if(SegBar.selectedSegmentIndex == 0){
            
            if segue.identifier == "ProfileSegue", let ProfileViewController = segue.destination as? ProfileClickVC{
                ProfileViewController.user_id = self.FilteredUsers![(TableViewLabel.indexPathForSelectedRow?.row)!].2
            }
           //Goes to event that is selected
        }else if(SegBar.selectedSegmentIndex == 1){
            if segue.identifier == "SessionSegue", let EventViewController = segue.destination as? EventVC{
                EventViewController.event_id = self.FilteredSessions![(TableViewLabel.indexPathForSelectedRow?.row)!].2
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

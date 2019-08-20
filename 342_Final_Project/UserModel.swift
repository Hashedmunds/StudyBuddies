//
//  User_Model.swift
//  342_Final_Project
//
//  Created by Hashaivione Edmundson on 12/4/18.
//  Copyright © 2018 Hashaivione Edmundson. All rights reserved.
//

import Foundation

class UserModel: UserProtocols{
    
    static let sharedInstance = UserModel()
 
    public var CurrentUser: User?
    public var id: String
    
    init(){
        id = ""
    }
    
    //Create user
    func createUser(_ name:String, _ school:String, _ email:String, _ classes:[String], _ ID: String, _ profile_p: String){
        if(classes.count == 0){
            CurrentUser = User(name,school,email,ID,profile_p)
        }
        else{
            CurrentUser = User(name,school,email,classes,ID,profile_p)
        }
    }
    
    //Gets name of logged in user
    func getName() -> String {
        return CurrentUser!.name
    }
    //Get school of logged in user
    func getSchool() -> String {
        return CurrentUser!.school
    }
    //Get email of longged in user
    func getEmail() -> String {
         return CurrentUser!.email
    }
    //Get classes of logged in user or no classes
    func getClasses() -> [String] {
        
        guard let schedule = CurrentUser?.classes else{
            return [String]()
        }
        return schedule
    }
    //Sets email
    func setId(id: String){
        self.id = id
    }
    //Gets profile picture
    func getProfilePic() -> String{
        return CurrentUser!.ProfilePicture
    }
    
    
    
}

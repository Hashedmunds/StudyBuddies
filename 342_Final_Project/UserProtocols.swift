//
//  UserProtocols.swift
//  342_Final_Project
//
//  Created by Hashaivione Edmundson on 12/4/18.
//  Copyright © 2018 Hashaivione Edmundson. All rights reserved.
//

import Foundation


//User protocols
protocol UserProtocols{
    func createUser(_ name:String, _ school:String, _ email:String, _ classes:[String], _ ID: String, _ profile_pic: String)
    func getName() -> String
    func getSchool() -> String
    func getEmail() -> String
    func getClasses() -> [String]
    func setId(id: String)
    func getProfilePic() -> String
    
    
}

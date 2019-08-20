//
//  User.swift
//  342_Final_Project
//
//  Created by Hashaivione Edmundson on 12/4/18.
//  Copyright © 2018 Hashaivione Edmundson. All rights reserved.
//

import Foundation

struct User{
    
    //Variables declared
    private(set) var name: String
    private(set) var school: String
    private(set) var email: String
    private(set) var classes: [String]
    private(set) var id: String
    private(set) var ProfilePicture: String
    
    
    //No Classes
    public init(_ name_p: String,_ school_p: String, _ email_p:String, _ class_p: [String], _ id_p: String, _ profile_p: String){
        self.name = name_p
        self.school = school_p
        self.email = email_p
        self.classes = class_p
        self.id = id_p
        self.ProfilePicture = profile_p
    }
    
    //Classes
    public init(_ name_p: String,_ school_p: String, _ email_p:String, _ id_p: String, _ profile_p: String){
        self.name = name_p
        self.school = school_p
        self.email = email_p
        self.classes = [String]()
        self.id = id_p
        self.ProfilePicture = profile_p
    }
}

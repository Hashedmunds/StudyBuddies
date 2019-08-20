//
//  CollegeTVC.swift
//  342_Final_Project
//
//  Created by Hashaivione Edmundson on 12/1/18.
//  Copyright © 2018 Hashaivione Edmundson. All rights reserved.
//

import UIKit

class CollegeTVC: UITableViewController {

    
    //Variables declared
    var collegeDictionary = [String: [String]]()
    var collegeSectionTitles = [String]()
    var colleges = [String]()
    var valueSelected: String = "Other"
    var tmp = [String?]()
    
   // var completionHandler: ((_ school: String) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Holds list of colleges from file
        tmp = collegeList()

        
        for i in tmp{
            let collegeKey = String(i!.prefix(1))
            if var collegeValues = collegeDictionary[collegeKey] {
                collegeValues.append(i!)
                collegeDictionary[collegeKey] = collegeValues
            } else {
                collegeDictionary[collegeKey] = [i] as? [String]
            }
        }
        
        collegeSectionTitles = [String](collegeDictionary.keys)
    collegeSectionTitles = collegeSectionTitles.sorted(by: { $0 < $1 })
        
    }
    
   
    //Reads in file with college names
    func collegeList() -> [String?]{
        guard let path = Bundle.main.path(forResource: "Colleges_List", ofType: "txt") else {
            return []
        }
        do {
            let content = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
            return content.components(separatedBy: "\n")
        } catch _ as NSError {
            return []
        }
    }
  
    
            // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return collegeSectionTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let collegeKey = collegeSectionTitles[section]
        if let collegeValues = collegeDictionary[collegeKey] {
            return collegeValues.count
        }
        
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        valueSelected = tableView.cellForRow(at: indexPath)?.textLabel?.text ?? "Other"
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollegeCell", for: indexPath)

        
        // Configure the cell...
        let collegeKey = collegeSectionTitles[indexPath.section]
        if let collegeValues = collegeDictionary[collegeKey] {
            cell.textLabel?.text = collegeValues[indexPath.row]
        }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return collegeSectionTitles[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return collegeSectionTitles
    }
}

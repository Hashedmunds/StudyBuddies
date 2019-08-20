//
//  NotesViewController.swift
//  342_Final_Project
//
//  Created by Hashaivione Edmundson on 11/7/18.
//  Copyright © 2018 Hashaivione Edmundson. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 1) Create cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath)
        
        // 2) Configure the cell...
       cell.textLabel!.text = "Lecture 5/6/18"
        cell.detailTextLabel?.text = "Hash"
        
        cell.textLabel?.numberOfLines = 0
        // 3) Return cell
        return cell
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

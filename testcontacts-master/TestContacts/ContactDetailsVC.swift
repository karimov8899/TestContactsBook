//
//  ContactDetailsVC.swift
//  TestContacts
//
//  Created by Dave on 8/11/20.
//  Copyright © 2020 DaKar. All rights reserved.
//

import UIKit
import CoreData

class ContactDetailsVC: UIViewController, UITableViewDataSource {
   
    @IBOutlet weak var table: UITableView!
     
    var item : Entity? = nil
     
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        table.dataSource = self
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Returning number of rows in hardcode because there would be definitely 5 rows
        return 5
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Showing the contact details on table view
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! TableViewCell
        let itemsArray = [item?.name,item?.lastName,item?.email,item?.telephone,item?.city]
        cell.cellTitle.text = itemsArray[indexPath.row]
        return cell
    }
    
    // Automatically estimating the height of the row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

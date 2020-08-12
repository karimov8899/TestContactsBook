//
//  MainVC.swift
//  TestContacts
//
//  Created by Dave on 8/11/20.
//  Copyright © 2020 DaKar. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UITableViewController, NSFetchedResultsControllerDelegate, UISearchBarDelegate {
    
    //Initializing fecth
    var frc : NSFetchedResultsController = NSFetchedResultsController<NSFetchRequestResult>()
    var pc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Performing the fetch from database
        frc = getFRC()
        frc.delegate = self
        do {
            try frc.performFetch()
        }
        catch {
            print(error)
            return
        }
        searchbar.delegate = self
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = frc.sections?[section].numberOfObjects
        
        //Cheking for empty table
        if numberOfRows == 0 {
            tableView.setEmptyView(title: "You don't have any contact.", message: "Your contacts will be in here.", messageImage: #imageLiteral(resourceName: "add"))
        } else {
            tableView.restore()
        }
        
        return numberOfRows!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        let item = frc.object(at: indexPath) as! Entity
        cell.cellTitle.text = item.name
        cell.lastname.text = item.lastName
        return cell
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
         tableView.reloadData()
    } 

    // Deleting items from database
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
        let  managedObj : NSManagedObject = frc.object(at: indexPath) as! NSManagedObject
        pc.delete(managedObj)
        
        do {
            try pc.save()
        }
        catch {
            print(error)
            return
        }
    }
    
 

    //MARK: - Contact Details Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "details" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            
            let itemController : ContactDetailsVC = segue.destination as! ContactDetailsVC
            let item : Entity = frc.object(at: indexPath!) as! Entity
            
            itemController.item = item
        }
    }
    
    //MARK: - Searchbar logic
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) { 
        let predicate = NSPredicate(format: "(name contains [cd] %@) || (lastName contains[cd] %@)" , searchBar.text ?? "", searchBar.text ?? "")
        frc.fetchRequest.predicate = predicate
        searchBar.setShowsCancelButton(true, animated: true)
        do  {
           try frc.performFetch()
        }
        catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        
        searchBar.showsCancelButton = false
        
        searchBar.resignFirstResponder()
        frc = getFRC()
        frc.delegate = self
        
        do {
            try frc.performFetch()
            
        }
        catch {
            
            print(error)
            return
            
        }
        tableView.reloadData()
    }
    
    //MARK: - Fetch Request
    func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
           
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        let sorter = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sorter]
        return fetchRequest
           
    }
    
    func getFRC() -> NSFetchedResultsController<NSFetchRequestResult> {
           
        frc = NSFetchedResultsController(fetchRequest: fetchRequest(), managedObjectContext: pc, sectionNameKeyPath: nil, cacheName: nil)
        return frc
           
    }
}

//MARK: - UITableView Extention
//Extention for showing greeting view if table view is empty
extension UITableView {
    
    func setEmptyView(title: String, message: String, messageImage: UIImage) {
        
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let messageImageView = UIImageView()
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        
        messageImageView.backgroundColor = .clear
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageImageView)
        emptyView.addSubview(messageLabel)
        
        messageImageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageImageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -20).isActive = true
        messageImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        messageImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 10).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        messageImageView.image = messageImage
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        UIView.animate(withDuration: 1, animations: {
            
            messageImageView.transform = CGAffineTransform(rotationAngle: .pi / 10)
        }, completion: { (finish) in
            UIView.animate(withDuration: 1, animations: {
                messageImageView.transform = CGAffineTransform(rotationAngle: -1 * (.pi / 10))
            }, completion: { (finishh) in
                UIView.animate(withDuration: 1, animations: {
                    messageImageView.transform = CGAffineTransform.identity
                })
            })
            
        })
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func restore() {
        
        self.backgroundView = nil
        self.separatorStyle = .singleLine
        
    }
    
}

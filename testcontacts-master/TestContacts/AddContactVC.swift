//
//  AddContactVC.swift
//  TestContacts
//
//  Created by Dave on 8/11/20.
//  Copyright © 2020 DaKar. All rights reserved.
//

import UIKit
import CoreData

class AddContactVC: UIViewController , UINavigationControllerDelegate{
    //Textfields
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var phone: UITextField! 
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    
    var item : Entity? = nil
    var pc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Initializing gesture recognizer
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        //Title of the page
        self.navigationItem.title = "Add New Contact"
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
 

    
    //MARK: - Saving button
    @IBAction func save(_ sender: Any) {
        //Checking for values of textfields
        if name.text != "" && city.text != "" && phone.text != "" && email.text != "" && lastName.text != ""{
            
            //Validation of email and phone textfields
            if isValidEmail(email: email.text!) && isValidPhone(phone: phone.text!){
                let entityDescription = NSEntityDescription.entity(forEntityName: "Entity", in: pc)
                let item = Entity(entity: entityDescription!, insertInto: pc)
                item.name = name.text
                item.city = city.text
                item.telephone = phone.text
                item.email = email.text
                item.lastName = lastName.text
                 
            } else {
                //Presenting alert if textfields returns invalid data
                let alert = UIAlertController(title: "Invalid Data!", message: "Please check the entered data!", preferredStyle: .alert)
                let alertaction =  UIAlertAction(title: "Ok", style: .destructive, handler: nil)
                alert.addAction(alertaction)
                present(alert, animated: true)
            }
            // Saving the new entity
            do {
                try pc.save()
            }
            catch {
                print(error)
                return
            }
            //Returning to the home page
            navigationController!.popViewController(animated: true)
        }
        else {
            //Showing alert if any of the textfields are empty
            let alert = UIAlertController(title: title, message: "Add an entity!", preferredStyle: .alert)
            let alertaction =  UIAlertAction(title: "Ok", style: .destructive, handler: nil)
            alert.addAction(alertaction)
            present(alert, animated: true)
            
        }
        
    }
    
    @IBAction func dissmiss(_ sender: Any) {
        self.resignFirstResponder()
    }
    
    //MARK: - Email Validation
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    //MARK: - Phone Validation
    func isValidPhone(phone: String) -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }

}

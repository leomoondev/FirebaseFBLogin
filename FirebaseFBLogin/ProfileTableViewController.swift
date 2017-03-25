//
//  ProfileTableViewController.swift
//  FirebaseFBLogin
//
//  Created by Hyung Jip Moon on 2017-03-24.
//  Copyright © 2017 leomoon. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileTableViewController: UITableViewController {

    var about = ["Gender", "Age", "Home", "Email", "Website", "Bio"]

    var user = User.sharedInstance
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
                // User is signed in.
                print("start login success: " + (user?.email)! )
                //self.performSegue(withIdentifier: loginToList, sender: nil)
            } else {
                // No user is signed in.
                print("No user is signed in.")
            }
            
        }
        
    

    }
    @IBAction func didTapUpdate(_ sender: Any) {
        
        //we run a while loop when user clicks update
        // loop over all the textfield and take out all the data and send it to firebase DB

        
        var index = 0
        while index < about.count {
            let indexPath = NSIndexPath(row: index, section: 0)
            
            let cell: TextInputTableView? = (self.tableView.cellForRow(at: indexPath as IndexPath) as! TextInputTableView)
            
            //if user

            
            if cell?.myTextField.text != "" {
                
                
                var userID : String
                
                if let data = UserDefaults.standard.object(forKey: "uid") as? String {
                
                    userID = data
                    //print(data)
                
                }
                else {
                    print("There is an issue")
                }
                
                    
                    //UserDefaults.standard.set("(userName.text!)", forKey: "UID")
                //UserDefaults.standard.object(forKey: "uid") as? String

                    
                
                
                let item:String = (cell?.myTextField.text!)!
     
                
                //let userID: String = user.current!.uid
                userID = user.current!.uid
                
                
                switch about[index] {
                    
                case "Gender":
                    
                    self.ref.child("user_profile").child("\(userID)/gender").setValue(item)

                    //self.ref.child("users/(user.uid)/username").setValue(item)
                    //self.ref.child("Users").child(userID).setValue(item)
                    print("Wrote to Firebase DB: gender")

                    //self.ref.child("user_profile").child("\(user!.uid)/gender").setValue(item)
                case "Age":
                    self.ref.child("user_profile").child("\(userID)/age").setValue(item)
                case "Phone":
                    self.ref.child("user_profile").child("\(userID)/phone").setValue(item)
                case "Email":
                    self.ref.child("user_profile").child("\(userID)/email").setValue(item)
                case "Website":
                    self.ref.child("user_profile").child("\(userID)/website").setValue(item)
                case "Bio":
                    self.ref.child("user_profile").child("\(userID)/bio").setValue(item)
                default:
                    print("Don't Update")
                    
                }
            }
            index += 1
        }

    }
    
    func configureDatabase() {
        //Gets a FIRDatabaseReference for the root of your Firebase Database.
        ref = FIRDatabase.database().reference()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return about.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TextInputTableView = tableView.dequeueReusableCell(withIdentifier: "TextInput", for: indexPath) as! TextInputTableView

        cell.configure(text: " ", placeholder: "\(about[indexPath.row])")
        
        // Configure the cell...

        return cell
    }
}

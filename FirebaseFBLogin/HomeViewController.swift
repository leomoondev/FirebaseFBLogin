//
//  HomeViewController.swift
//  FirebaseFBLogin
//
//  Created by Hyung Jip Moon on 2017-03-23.
//  Copyright © 2017 leomoon. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FirebaseAuth
import FirebaseStorage

class HomeViewController: UIViewController {
    var currentUser = User.sharedInstance
    
    @IBOutlet weak var imageProfilePic: UIImageView!

    @IBOutlet weak var profileName: UILabel!

    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.imageProfilePic.layer.cornerRadius = self.imageProfilePic.frame.size.width/2
        
        self.imageProfilePic.clipsToBounds = true
        
        getFacebookUserInfo()
        
    }
    
    func getFacebookUserInfo() {
        
        if let user = FIRAuth.auth()?.currentUser {
            
            // User is signed in.
            // ...
            // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with your backend server,
            // if you have one. Use getTokenWithCompletion:completion: instead.
            let name = user.displayName
            let email = user.email
            let uid = user.uid
            
            let photoURL = user.photoURL
            
            self.profileName.text = name
            let data = NSData(contentsOf: photoURL!)
            self.imageProfilePic.image = UIImage(data: data! as Data)
            
            // reference to the storage service
            let storage = FIRStorage.storage()
            
            // This is equivalent to creating the full reference
            let storageRef = storage.reference(forURL: "gs://fir-fblogin-394e8.appspot.com")
            
            // Create a reference to the file you want to download
            let profilePicRef = storageRef.child(user.uid+"/profile_pic.jpg");
            
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            profilePicRef.data( withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                if(error != nil) {
                    
                    print("Unable to download image")
                }
                else {
                    
                    if(data != nil) {
                        
                        print("User already has an image, no need to download from facebook")
                        self.imageProfilePic.image = UIImage(data:data!)
                    }
                }
            }
            
            if(self.imageProfilePic.image == nil) {
                
                var profilePic = FBSDKGraphRequest(graphPath: "/me/picture", parameters: ["height": 300, "width": 300, "redirect": false], httpMethod: "GET")
                
                profilePic?.start(completionHandler: {(FBSDKGraphRequestConnection, result, error) -> Void in
                    // Handle the result
                    if(error == nil) {
                        
                        let dictionary = result as? NSDictionary
                        let data = dictionary?.object(forKey: "data")
                        let urlPic = ((data as AnyObject).object(forKey:"url"))! as! String
                        if let imageData = NSData(contentsOf: NSURL(string:urlPic)! as URL) {
                            let profilePicRef = storageRef.child(user.uid+"/profile_pic.jpg")
                            
                            let uploadTask = profilePicRef.put(imageData as Data, metadata:nil) {
                                metadata, error in
                                
                                if(error == nil) {
                                    
                                    let downloadUrl = metadata!.downloadURL
                                }
                                else {
                                    print("Error in downloading image")
                                }
                            }
                            self.imageProfilePic.image = UIImage(data:imageData as Data)
                        }
                        print(result!)
                    }
                })
            }
        }
        else {
            // No user is signed in.
            // ...
        }
        
    }
    @IBAction func didTapLougout(_ sender: Any) {
        
        // sign the user out of the Firebase app
        try! FIRAuth.auth()!.signOut()
        
        // sign the user out of the facebook app
        FBSDKAccessToken.setCurrent(nil)
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginView")
        self.present(viewController, animated: true, completion: nil)
        
    }
}

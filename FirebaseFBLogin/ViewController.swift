//
//  ViewController.swift
//  FirebaseFBLogin
//
//  Created by Hyung Jip Moon on 2017-03-23.
//  Copyright © 2017 leomoon. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    /**
     Sent to the delegate when the button was used to login.
     - Parameter loginButton: the sender
     - Parameter result: The results of the login
     - Parameter error: The error (if any) from the login
     */



    var loginButton: FBSDKLoginButton = FBSDKLoginButton()
    
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginButton.isHidden = true
        
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if let user = user {
                // User is signed in
                // Move the user to the home screen
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let homeViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeView")
                self.present(homeViewController, animated: true, completion: nil)
    
            }
            else {
                // No user is signed in.
                // Show the user the login button
                // Do any additional setup after loading the view, typically from a nib.
                self.loginButton.center = self.view.center
                self.loginButton.readPermissions = ["public_profile", "email", "user_friends"]
                self.loginButton.delegate = self
                
                self.view.addSubview(self.loginButton)
                self.loginButton.isHidden = false
            }
        }
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        print("User Logged In")
        
        
        self.loginButton.isHidden = true
        loadingSpinner.startAnimating()
        
        if(error != nil) {
            
            // handle errors here
            self.loginButton.isHidden = false
            loadingSpinner.stopAnimating()
            
        }
        else if (result.isCancelled) {
            //handle the cancel event
            self.loginButton.isHidden = false
            loadingSpinner.stopAnimating()

        }
        
        else  {
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                // ...
                
                print("User logged in to Firebase App!")
                
            }

        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User did Logout")
    }
}


//
//  LoginViewController.swift
//  ParseHeroku
//
//  Created by Daniel Lau on 8/17/18.
//  Copyright © 2018 Daniel Lau. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        let user = PFUser()
        
        user.username = usernameTextField.text
        user.password = passwordTextField.text
        
        user.signUpInBackground { (success, error) in
            if let error = error {
                print(error.localizedDescription, "error signing up user")
                return
            }
            
            print("success signing up")
          self.performSegue(withIdentifier: "toMessageVC", sender: self)
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            if let error = error {
                print("error logging in", error.localizedDescription)
                
                let alert = UIAlertController(title: "Login error", message: error.localizedDescription, preferredStyle: .alert)
                let okay = UIAlertAction(title: "Okay", style: .default, handler: { (_) in
                    print("okay")
                })
                alert.addAction(okay)
                self.present(alert, animated: true, completion: nil)
                return
            }
                print("success login")
            
            self.performSegue(withIdentifier: "toMessageVC", sender: self)
        }
        
        
    }
    
}

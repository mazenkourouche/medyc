//
//  Registration.swift
//  Medyc
//
//  Created by Mazen Kourouche on 23/2/17.
//  Copyright © 2017 Mazen Kourouche. All rights reserved.
//

import UIKit
//import Firebase
//import FirebaseAuth

class Registration: UIViewController {

    var signIn = true
    
    @IBOutlet weak var logoImageview: UIImageView!
    
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var fullnameTextfield: UITextField!
    @IBOutlet weak var fullnameUnderline: UIView!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    @IBOutlet weak var registrationButton: UIButton!
    
    @IBOutlet weak var signInSignUpButton: UIButton!
    @IBOutlet weak var signInSignUpLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.fullnameLabel.alpha = 0
        self.fullnameTextfield.alpha = 0
        self.fullnameUnderline.alpha = 0
        self.forgotPasswordButton.alpha = 1
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func registrationTapped(_ sender: Any) {
    }

    
    @IBAction func signInSignUpTapped(_ sender: Any) {
        
        signIn = !signIn
        
        if signIn {
            
            UIView.animate(withDuration: 0.3, animations: {
                self.fullnameLabel.alpha = 0
                self.fullnameTextfield.alpha = 0
                self.fullnameUnderline.alpha = 0
                self.forgotPasswordButton.alpha = 1
            })
            
            self.registrationButton.setImage(#imageLiteral(resourceName: "signInButton"), for: .normal)
            
            signInSignUpLabel.text = "DON'T HAVE AN ACCOUNT?"
            signInSignUpButton.setTitle("SIGN UP", for: .normal)
            
        } else {
            
            UIView.animate(withDuration: 0.3, animations: {
                self.fullnameLabel.alpha = 1
                self.fullnameTextfield.alpha = 1
                self.fullnameUnderline.alpha = 1
                self.forgotPasswordButton.alpha = 0
            })
            
            self.registrationButton.setImage(#imageLiteral(resourceName: "signUpButton"), for: .normal)
            
            signInSignUpLabel.text = "ALREADY HAVE AN ACCOUNT?"
            signInSignUpButton.setTitle("SIGN IN", for: .normal)
        }
        
        
        
    }
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "forgotPasswordSegue", sender: nil)
    }
    
    func authenticateUser () {
        
        //FIRAuth.auth()?.signIn(withEmail: self.emailTextfield.text!, password: self.passwordTextfield.text!) { (user, error) in
            // ...
        //}
        
    }
    
    func createUser() {
        
       // FIRAuth.auth()?.createUser(withEmail: self.emailTextfield.text!, password: self.passwordTextfield.text!) { (user, error) in
            // ...
       // }
        
    }
    
    

}

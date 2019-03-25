//
//  ForgotPasswordViewcontroller.swift
//  Medyc
//
//  Created by Mazen Kourouche on 23/2/17.
//  Copyright © 2017 Mazen Kourouche. All rights reserved.
//

import UIKit
//import FirebaseAuth
class ForgotPasswordViewcontroller: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendEmailTapped(_ sender: Any) {
        
        //FIRAuth.auth()?.sendPasswordReset(withEmail: self.emailTextfield.text!) { error in
        //    self.dismiss(animated: true, completion: nil)
       // }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

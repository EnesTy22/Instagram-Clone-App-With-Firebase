//
//  ViewController.swift
//  InstaCloneWithFirebase
//
//  Created by Enes Talha Yılmaz on 7.03.2023.
//

import UIKit
import Firebase
class ViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
    }
    @IBAction func SignInClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { authData, error in
                if error != nil{
                    self.PopAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }
                else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }
        else{
            PopAlert(titleInput: "Error", messageInput: "Username or Password is empty")
        }
        
    }
    
    fileprivate func PopAlert(titleInput : String, messageInput : String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler:nil)
        alert.addAction(okButton)
        self.present(alert, animated: true,completion : nil)
    }
    
    @IBAction func SignUpClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != ""
        {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authData,error in
                if error != nil
                {
                    
                }
                else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        }
        else
        {
            PopAlert(titleInput: "Error", messageInput: "Email or Password empty!")
        }
    }
    
}


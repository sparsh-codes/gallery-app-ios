//
//  ViewController.swift
//  GalleryApp
//
//  Created by Sparsh Singh on 14/07/23.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        
        loginLogic { bool in
            if bool {
                
                UserDefaults.standard.set(true, forKey: "logged_in")
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabVC")
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
            }
        }
        
        
    }
    
    @IBAction func resetKeyChainAction(_ sender: Any) {
        KeyChain.shared.resetKeyChain()
        print("Credentials Deleted")
    }
    
    func loginLogic(Completion: @escaping(Bool) -> Void) {
        
        // TODO: Add Alerts
        
        guard !emailTextField.text!.isEmpty, emailTextField.text != " " else { return }
        guard !passwordTextField.text!.isEmpty, passwordTextField.text != " " else {return }
        
        print("Everything is good.")
        
        if let email = KeyChain.shared.getEmail(), let password = KeyChain.shared.getPassword() {
            
            if emailTextField.text == email && passwordTextField.text == password {
                print("Credentials Matched")
                Completion(true)
                return
            }
            
        } else {
            if let newEmail = emailTextField.text, let newPassword = passwordTextField.text {
                KeyChain.shared.updateEmail(newEmail)
                KeyChain.shared.updatePassword(newPassword)
                print("Credentials Created")
                Completion(true)
                return
            }
        }
        
        Completion(false)
        return
    }
}

extension LoginVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
}

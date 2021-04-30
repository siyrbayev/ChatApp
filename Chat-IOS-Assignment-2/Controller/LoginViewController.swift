//
//  LoginViewController.swift
//  Chat-IOS-Assignment-2
//
//  Created by ADMIN ODoYal on 27.04.2021.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    static public let identifier = "LoginViewController"
    static public let nib = UINib(nibName: identifier, bundle: Bundle(for: LoginViewController.self))
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }
    
    @IBAction func pressLoginButton(_ sender: Any) {
        loginButton.isEnabled = false
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password){ [weak self](result, error) in
            if let error = error {
                print(error)
                self?.loginButton.isEnabled = true
            } else {
                let vc = self?
                    .storyboard?.instantiateViewController(withIdentifier: ChatViewController.identifier) as! ChatViewController
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        
        
    }
    
}

// LoginViewController
extension LoginViewController {
    private func configureLayout(){
        loginButton.layer.cornerRadius = 8
    }
}

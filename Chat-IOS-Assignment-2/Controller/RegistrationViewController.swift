//
//  RegistrationViewController.swift
//  Chat-IOS-Assignment-2
//
//  Created by ADMIN ODoYal on 27.04.2021.
//

import UIKit
import Firebase

class RegistrationViewController: UIViewController {
    static public let identifier = "RegistrationViewController"
    static public let nib = UINib(nibName: identifier, bundle: Bundle(for: RegistrationViewController.self))
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var registrationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }
    
    @IBAction func pressRegistrationButton(_ sender: Any) {
        defer {
            registrationButton.isEnabled = true
        }
        registrationButton.isEnabled = false
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        Auth.auth().createUser(withEmail: email, password: password){ [weak self] (result, error) in
            if let error = error {
                print(error)
            } else {
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: ChatViewController.identifier) as! ChatViewController
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }
}

// RegistrationViewController
extension RegistrationViewController {
    private func configureLayout(){
        registrationButton.layer.cornerRadius = 8
    }
}

//
//  ViewController.swift
//  Chat-IOS-Assignment-2
//
//  Created by ADMIN ODoYal on 27.04.2021.
//

import UIKit

class ViewController: UIViewController {
    static public let identifier = "ViewController"
    static public let nib = UINib(nibName: identifier, bundle: Bundle(for: ViewController.self))
    
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registrationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func pressLoginButton(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: LoginViewController.identifier) as! LoginViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func pressRegistrationButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: RegistrationViewController.identifier) as! RegistrationViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


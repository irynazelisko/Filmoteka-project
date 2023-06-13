//
//  LogInViewController.swift
//  Filmoteka
//
//  Created by Ірина Зеліско on 08.06.2023.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 1.0, alpha: 1.0)
      
    }
    @IBAction func logInPressed(_ sender: UIButton) {
        if let email = emailTextField.text , let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                }else{
                    self.performSegue(withIdentifier: "LogInToMovies", sender: self)
                }
                
            }
        }
    }
}

//
//  SignUpViewController.swift
//  Filmoteka
//
//  Created by Ірина Зеліско on 09.06.2023.
//

import UIKit
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0)
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        if let email = emailTextField.text , let password = passwordTextField.text {
            
            if password.count < 6 {
                showAlert(withTitle: "Помилка", message: "Password must be at least 6 characters long.")
                return
            }
            
            if email.isEmpty || password.isEmpty {
                showAlert(withTitle: "Помилка", message: "Please enter your email and password.")
                return
            }
            
            if !isValidEmail(email) {
                showAlert(withTitle: "Помилка", message: "Please enter a valid email address.")
                return
            }
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    if let uid = authResult?.user.uid {
                        FirestoreService.saveUserUID(uid)
                    }
                    self.performSegue(withIdentifier: "RegisterToMovies", sender: self)
                }
            }
        }
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func showAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}


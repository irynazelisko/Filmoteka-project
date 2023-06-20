//
//  AuthViewController.swift
//  Filmoteka
//
//  Created by Ірина Зеліско on 20.06.2023.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class AuthViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    enum AuthMode {
        case signUp
        case logIn
    }
    
    var authMode: AuthMode = .logIn
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        updateUIForAuthMode()
        
        if let _ = Auth.auth().currentUser {
            self.performSegue(withIdentifier: "LogInToMovies", sender: self)
        }
    }
    
    func updateUIForAuthMode() {
        switch authMode {
        case .signUp:
            view.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0)
            titleLabel.text = "Create account"
            subtitleLabel.text = "Create your account"
            actionButton.setTitle("Sign Up", for: .normal)
        case .logIn:
            view.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 1.0, alpha: 1.0)
            titleLabel.text = "Hello!"
            subtitleLabel.text = "Log in to your account"
            actionButton.setTitle("Log In", for: .normal)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            if password.count < 6 {
                showAlert(withTitle: "Error", message: "Password must be at least 6 characters long.")
                return
            }
            
            if email.isEmpty || password.isEmpty {
                showAlert(withTitle: "Error", message: "Please enter your email and password.")
                return
            }
            
            if !isValidEmail(email) {
                showAlert(withTitle: "Error", message: "Please enter a valid email address.")
                return
            }
            
            switch authMode {
            case .signUp:
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let e = error {
                        print(e.localizedDescription)
                    } else {
                        if let uid = authResult?.user.uid {
                            FirestoreService.saveUserUID(uid)
                        }
                        self.performSegue(withIdentifier: "LogInToMovies", sender: self)
                    }
                }
            case .logIn:
                Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    if let e = error {
                        print(e.localizedDescription)
                    } else {
                        if let uid = authResult?.user.uid {
                            FirestoreService.saveUserUID(uid)
                        }
                        self.performSegue(withIdentifier: "LogInToMovies", sender: self)
                    }
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

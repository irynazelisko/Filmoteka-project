//
//  ViewController.swift
//  Filmoteka
//
//  Created by Ірина Зеліско on 08.06.2023.
//

import UIKit
import Firebase

final class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientLayer = CAGradientLayer()
        
        let startColor = UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
        let endColor = UIColor(red: 0.8, green: 0.8, blue: 1.0, alpha: 1.0).cgColor
        gradientLayer.colors = [startColor, endColor]
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        gradientLayer.frame = view.bounds
        
        view.layer.insertSublayer(gradientLayer, at: 0)
        logInButton.layer.cornerRadius = 14
        signUpButton.layer.cornerRadius = 14
        
        if let _ = Auth.auth().currentUser {
            self.performSegue(withIdentifier: "logInSegue", sender: self)
        }
    }
    
    @IBAction func logInPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "logInSegue", sender: AuthViewController.AuthMode.logIn)
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "logInSegue", sender: AuthViewController.AuthMode.signUp)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logInSegue", let authMode = sender as? AuthViewController.AuthMode {
            if let authViewController = segue.destination as? AuthViewController {
                authViewController.authMode = authMode
            }
        }
    }
}

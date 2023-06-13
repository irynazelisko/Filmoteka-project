//
//  ProfileViewController.swift
//  Filmoteka
//
//  Created by Ірина Зеліско on 11.06.2023.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
          try Auth.auth().signOut()
            dismiss(animated: true,completion: nil)
            //            navigationController?.popToRootViewController(animated: true)
                    } catch let signOutError as NSError {
                      print("Error signing out: %@", signOutError)
                    }
                }
            }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



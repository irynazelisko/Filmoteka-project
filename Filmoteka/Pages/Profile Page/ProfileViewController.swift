//
//  ProfileViewController.swift
//  Filmoteka
//
//  Created by Ірина Зеліско on 11.06.2023.
//

import UIKit
import Firebase


final class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logOutButton.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 1.0, alpha: 1.0)
        logOutButton.layer.cornerRadius = 14
        setBorder()
        updateProfile()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setBorder() {
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 3
    }
    
    func updateProfile() {
        if let currentUser = Auth.auth().currentUser {
            emailLabel.text = currentUser.email
        }
    }
    
    @IBAction func logOutTapped(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    @objc func profileImageTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let resizedImage = resizeImage(image: pickedImage, targetSize: CGSize(width: 180, height: 180))
            profileImageView.image = resizedImage
            profileImageView.contentMode = .scaleAspectFill
//            saveImageToFirebaseStorage(resizedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let scaleFactor = max(widthRatio, heightRatio)
        let scaledSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
        let renderer = UIGraphicsImageRenderer(size: scaledSize)
        let scaledImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: scaledSize))
        }
        return scaledImage
    }
}

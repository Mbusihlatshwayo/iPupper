//
//  PupperViewController.swift
//  iPupper
//
//  Created by Mbusi Hlatshwayo on 2/20/20.
//  Copyright © 2020 Mbusi Hlatshwayo. All rights reserved.
//

import UIKit

class PupperViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    @IBOutlet weak var pupperProfilePicImageView: UIImageView!
    @IBOutlet weak var pupperNameLabel: UILabel!
    @IBOutlet weak var pupperLocationLabel: UILabel!
    @IBOutlet weak var pupperPhotoCollectionView: UICollectionView!
    @IBOutlet weak var profileInformationContainerView: UIView!
    @IBOutlet weak var imagePromptLabel: UILabel!
    
    var pupperPhotosList = [UIImage]()
    let imageModelController = ImageModelController()
    var imagePickerSender = String()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.roundProfilePicture()
        
        displayPromptLabel()
        if let profilePicture = self.imageModelController.profilePicture {
            self.pupperProfilePicImageView.image = profilePicture
        } else {
            self.pupperProfilePicImageView.image = UIImage(named: "plus")
        }
        addGradientToView(view: profileInformationContainerView)
        
        pupperPhotoCollectionView.delegate = self
        pupperPhotoCollectionView.dataSource = self
        
        self.pupperProfilePicImageView.isUserInteractionEnabled = true
        self.pupperProfilePicImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
    }
    
    
    // MARK: - Collection View Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageModelController.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "pupperPicturesCell", for: indexPath) as! PupperPhotoCollectionViewCell
//        print("name", self.imageModelController.images[indexPath.row])
        cell.pupperImageView.image = self.imageModelController.images[indexPath.row]
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((collectionView.frame.width - 10) / 2)
        return CGSize(width: width, height: 200)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
    
    @IBAction func didSelectCameraButton(_ sender: Any) {
        imagePickerSender = "photos_list"
        presentCameraPicker()
    }
    
    @objc private func imageTapped(_ recognizer: UITapGestureRecognizer) {
        imagePickerSender = "profile_picture"
        presentCameraPicker()
    }
    

}

// MARK: - Class extension

extension PupperViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func roundProfilePicture() {
        pupperProfilePicImageView.layer.masksToBounds = true
        pupperProfilePicImageView.layer.borderColor = UIColor.gray.cgColor
        pupperProfilePicImageView.layer.borderWidth = 3
        pupperProfilePicImageView.layer.cornerRadius = pupperProfilePicImageView.bounds.width / 2
    }
    
    func shouldDisplayPromptLabel() -> Bool {
        if self.imageModelController.images.count == 0 {
            return true
        } else {

            return false
        }
    }
    
    func displayPromptLabel() {
        let displayPhotoPrompt = self.shouldDisplayPromptLabel()
        if displayPhotoPrompt == true {
            self.imagePromptLabel.isHidden = false
        } else {
            self.imagePromptLabel.isHidden = true
        }
    }
    
    func addGradientToView(view: UIView)
    {
        //gradient layer
        let gradientLayer = CAGradientLayer()
            
        //define colors
        gradientLayer.colors = [UIColor.blue.cgColor, UIColor.systemBlue.cgColor]
            
        //define locations of colors as NSNumbers in range from 0.0 to 1.0
        //if locations not provided the colors will spread evenly
        gradientLayer.locations = [0.0, 0.6, 0.8]
            
        //define frame
        gradientLayer.frame = view.bounds


        //insert the gradient layer to the view layer
        view.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    func presentCameraPicker() {
        let vc = UIImagePickerController()
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            return
        }

        // print out the image size as a test
        print(image.size)
        if imagePickerSender == "photos_list" {
            self.imageModelController.saveImageObject(image: image, forPurpose: "photos_list")
            self.pupperPhotoCollectionView.reloadData()
        } else {
            self.imageModelController.saveImageObject(image: image, forPurpose: "profile_picture")
            self.viewDidLoad()
        }

    }
    
}


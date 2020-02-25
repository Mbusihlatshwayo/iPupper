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
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.roundProfilePicture()
        
        displayPromptLabel()
        
        addGradientToView(view: profileInformationContainerView)
        
        pupperPhotoCollectionView.delegate = self
        pupperPhotoCollectionView.dataSource = self
    }
    
    
    // MARK: - Collection View Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageModelController.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "pupperPicturesCell", for: indexPath) as! PupperPhotoCollectionViewCell
        
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
        print(pupperPhotosList.count)
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
        
        self.imageModelController.saveImageObject(image: image)
        self.pupperPhotoCollectionView.reloadData()
    }
    
}


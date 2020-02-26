//
//  EditPupperViewController.swift
//  iPupper
//
//  Created by Mbusi Hlatshwayo on 2/25/20.
//  Copyright © 2020 Mbusi Hlatshwayo. All rights reserved.
//

import UIKit

class EditPupperViewController: UIViewController {

    @IBOutlet weak var editPupperProfilePicture: UIImageView!
    @IBOutlet weak var pupperNameTextField: UITextField!
    @IBOutlet weak var pupperLocationTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.roundProfilePicture()
        // Do any additional setup after loading the view.
    }
    

    func roundProfilePicture() {
        editPupperProfilePicture.layer.masksToBounds = true
        editPupperProfilePicture.layer.borderColor = UIColor.gray.cgColor
        editPupperProfilePicture.layer.borderWidth = 3
        editPupperProfilePicture.layer.cornerRadius = editPupperProfilePicture.bounds.width / 2
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

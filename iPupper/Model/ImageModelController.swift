//
//  ImageModelController.swift
//  iPupper
//
//  Created by Mbusi Hlatshwayo on 2/25/20.
//  Copyright © 2020 Mbusi Hlatshwayo. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ImageModelController {
    
    static let shared = ImageModelController()

    let entityName = "StoredImage"

    var savedObjects = [NSManagedObject]()
    var images = [UIImage]()
    var profilePicture: UIImage?
    var managedContext: NSManagedObjectContext!
    
    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        managedContext = appDelegate.persistentContainer.viewContext

        fetchImageObjects()
        
//        deleteAllImages()
    }
    
    func deleteAllImages() {
        do {
            // delete
            let imageObjectRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
            savedObjects = try managedContext.fetch(imageObjectRequest)
            for deletions in savedObjects {
                managedContext.delete(deletions)
            }
            do {
                try managedContext.save()
            } catch {
                print("managed context save failed")
            }
        } catch {
            print("couldn't delete")
        }
    }
    
    func fetchImageObjects() {
        let imageObjectRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        do {
            savedObjects = try managedContext.fetch(imageObjectRequest)
            images.removeAll()
            profilePicture = nil
  
            for imageObject in savedObjects {
                let savedImageObject = imageObject as! StoredImage
                
                guard savedImageObject.imageName != nil else { return }
                
                let storedImage = ImageController.shared.fetchImage(imageName: savedImageObject.imageName!)
                
                if let storedImage = storedImage {
                    if savedImageObject.imageName != "profile_picture" {
                        images.append(storedImage)
                    } else {
                        profilePicture = storedImage
                    }
//                    print("image named: ", savedImageObject.imageName)
                }
            }
        } catch let error as NSError {
//            print("Could not return image objects: \(error)")
        }
    }
    
    func saveImageObject(image: UIImage, forPurpose: String) {

        var imageName: String?
        
        if forPurpose == "profile_picture" {
            imageName = ImageController.shared.saveProfilePhoto(image: image)
        } else {
            imageName = ImageController.shared.saveImage(image: image)
        }
        
        if let imageName = imageName {
            let coreDataEntity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)
            let newImageEntity = NSManagedObject(entity: coreDataEntity!, insertInto: managedContext) as! StoredImage
            
            newImageEntity.imageName = imageName
            
            do {
                try managedContext.save()
                
                if forPurpose != "profile_picture" {
                    images.append(image)
                } else {
                    profilePicture = image
                }
                
//                print("\(imageName) was saved in new object.")
            } catch let error as NSError {
//                print("Could not save new image object: \(error)")
            }
        }
    }
    
    func deleteImageObject(imageIndex: Int) {
        guard images.indices.contains(imageIndex) && savedObjects.indices.contains(imageIndex) else { return }
        
        let imageObjectToDelete = savedObjects[imageIndex] as! StoredImage
        let imageName = imageObjectToDelete.imageName
        
        do {
            managedContext.delete(imageObjectToDelete)
            
            try managedContext.save()
            
            if let imageName = imageName {
                ImageController.shared.deleteImage(imageName: imageName)
            }
            
            savedObjects.remove(at: imageIndex)
            images.remove(at: imageIndex)
            
//            print("Image object was deleted.")
        } catch let error as NSError {
//            print("Could not delete image object: \(error)")
        }
    }
    
    
}

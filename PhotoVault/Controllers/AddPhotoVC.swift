//
//  AddPhotoVC.swift
//  PhotoVault
//
//  Created by Marcus Ng on 4/22/18.
//  Copyright © 2018 Marcus Ng. All rights reserved.
//

import UIKit

class AddPhotoVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var albumTitle: String?
    var imageData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func selectPhotoBtnPressed(_ sender: Any) {
        showImagePicker()
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        if let image = imageData {
            savePhoto(image: image) { (success) in
                if success {
                    performSegue(withIdentifier: UNWIND_TO_VIEW_ALBUM, sender: nil)
                    print("Unwind to ViewAlbumVC")
                } else {
                    // ERROR: ADD A PHOTO
                    print("Failed to add photo, UIAlertVC")
                }
            }
        }
    }
    
    func initData(title: String) {
        albumTitle = title
    }
    
    // Save
    func savePhoto(image: Data, completion: (_ complete: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let photo = Photo(context: managedContext)
        photo.album = albumTitle
        photo.image = image
        photo.time = Date()
        
        do {
            try managedContext.save()
            print("Photo saved to \(String(describing: albumTitle))")
            completion(true)
        } catch {
            debugPrint("Could not save photo to \(String(describing: albumTitle)): \(error.localizedDescription)")
            completion(false)
        }
    }
    
}

extension AddPhotoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    func showImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            // Convert image to png
            imageData = UIImagePNGRepresentation(selectedImage)!
            imageView.image = UIImage(data: imageData!)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

//
//  ViewPhotoVC.swift
//  PhotoVault
//
//  Created by Marcus Ng on 4/22/18.
//  Copyright © 2018 Marcus Ng. All rights reserved.
//

import UIKit

class ViewPhotoVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var photo: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = photo {
            imageView.image = UIImage(data: image.image!, scale: 1.0)
        }
    }

    @IBAction func deleteBtnPressed(_ sender: Any) {
        // Delete Alert Controller
        let deleteAlertController = UIAlertController(title: "Delete", message: "Are you sure you want to delete this photo?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction.init(title: "Yes", style: .destructive) { action -> Void in
            // Delete Photo
            self.deletePhoto()
            self.performSegue(withIdentifier: UNWIND_TO_VIEW_ALBUM, sender: nil)
        }
        
        let noAction = UIAlertAction.init(title: "No", style: .default) { action -> Void in
            // Nothing
        }
        
        deleteAlertController.addAction(yesAction)
        deleteAlertController.addAction(noAction)
        deleteAlertController.preferredAction = noAction // Bold "No"
        
        self.present(deleteAlertController, animated: true, completion: nil)
    }
    
    func initData(img: Photo) {
        photo = img
    }
    
    // Delete
    func deletePhoto() {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        // Delete Photo
        managedContext.delete(photo!)
        
        // Save after deleting
        do {
            try managedContext.save()
            print("Successfully removed entry")
            performSegue(withIdentifier: UNWIND_TO_VIEW_ALBUM, sender: nil)
        } catch {
            debugPrint("Could not remove entry: \(error.localizedDescription)")
        }
    }
    
}

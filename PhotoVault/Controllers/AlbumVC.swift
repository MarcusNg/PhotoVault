//
//  AlbumVC.swift
//  PhotoVault
//
//  Created by Marcus Ng on 4/22/18.
//  Copyright © 2018 Marcus Ng. All rights reserved.
//

import UIKit
import CoreData

class AlbumVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var albums = [Album]() {
        didSet {
            albums = albums.sorted(by: { $0.time?.compare($1.time!) == .orderedAscending })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        print("loaded album vc...")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        updateAlbums()
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
       createDialogBox()
    }
    
    @IBAction func settingsBtnPressed(_ sender: Any) {
        
    }
    
    func createDialogBox() {
        let alertController = UIAlertController(title: "Create Album", message: "", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            
            //getting the input values from user
            guard let title = alertController.textFields?[0].text, title != "" else { return }
            
            // Save album to db
            self.createAlbum(title: title, completion: { (success) in
                if success {
                    self.updateAlbums()
                }
            })
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Title"
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Update
    func updateAlbums() {
        albums.removeAll()
        fetchAlbums() { (success) in
            if success {
                tableView.reloadData()
            }
        }
    }
    
    // Fetch
    func fetchAlbums(completion: (_ complete: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<Album>(entityName: "Album")
        
        do {
            albums = try managedContext.fetch(fetchRequest)
            completion(true)
        } catch {
            debugPrint("Could not fetch album: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func photoCount(albumTitle: String) -> Int {
        return 0
    }
    
    // Save
    func createAlbum(title: String, completion: (_ complete: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let album = Album(context: managedContext)
        
        album.title = title
        album.time = Date()
        
        do {
            try managedContext.save()
            print("Album saved")
            completion(true)
        } catch {
            debugPrint("Could not save album: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    // Remove
    func removeAlbum(indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let album = albums[indexPath.row]
        // Delete Album
        managedContext.delete(album)
        
        // Delete All Photos w/ Album Title
        
        
        // Save after deleting
        do {
            try managedContext.save()
            updateAlbums()
            print("Successfully removed album")
        } catch {
            debugPrint("Could not remove album: \(error.localizedDescription)")
        }
    }
}

extension AlbumVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell") as? AlbumCell else { return UITableViewCell() }
        cell.configure(title: albums[indexPath.row].title!, photoCount: photoCount(albumTitle: albums[indexPath.row].title!))
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: TO_VIEW_ALBUM, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            self.removeAlbum(indexPath: index)
        }
        
        return [delete]
    }
}

//
//  ViewAlbumVC.swift
//  PhotoVault
//
//  Created by Marcus Ng on 4/22/18.
//  Copyright © 2018 Marcus Ng. All rights reserved.
//

import UIKit
import CoreData

class ViewAlbumVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navBarTitle: UINavigationItem!
    
    @IBAction func prepareForUnwindToViewAlbum(segue: UIStoryboardSegue) {}
    
    var albumTitle: String?
    var selectedRow: Int?
    
    var photos = [Photo]() {
        didSet {
            photos = photos.sorted(by: { $0.time?.compare($1.time!) == .orderedDescending })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        navBarTitle.title = albumTitle
        
        // Collection View
        let itemSize = UIScreen.main.bounds.width / 3 - 5
    
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(5, 2.5, 5, 2.5)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
        
        collectionView.collectionViewLayout = layout
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        updatePhotos()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TO_ADD_PHOTO {
            if let addPhotoVC = segue.destination as? AddPhotoVC {
                addPhotoVC.initData(title: albumTitle!)
            }
        } else if segue.identifier == TO_VIEW_PHOTO {
            if let viewPhotoVC = segue.destination as? ViewPhotoVC {
                if let row = selectedRow {
                    viewPhotoVC.initData(img: photos[row])
                }
            }
        }
    }
    
    @IBAction func addPhotoBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: TO_ADD_PHOTO, sender: nil)
    }
    
    func initData(title: String) {
        albumTitle = title
    }
    
    // Update
    func updatePhotos() {
        photos.removeAll()
        fetchPhotos { (success) in
            if success {
                collectionView.reloadData()
            }
        }
    }
    
    // Fetch
    func fetchPhotos(completion: (_ complete: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<Photo>(entityName: "Photo")
        fetchRequest.predicate = NSPredicate(format: "album == %@", albumTitle!)
        
        do {
            photos = try managedContext.fetch(fetchRequest)
            print(photos)
            completion(true)
        } catch {
            debugPrint("Could not fetch photos: \(error.localizedDescription)")
            completion(false)
        }
    }
    
}

extension ViewAlbumVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
        cell.configure(imageData: photos[indexPath.row].image!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        performSegue(withIdentifier: TO_VIEW_PHOTO, sender: nil)
    }
    
}

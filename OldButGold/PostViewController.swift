    //
    //  PostViewController.swift
    //  OldButGold
    //
    //  Created by Karl Wang on 4/30/19.
    //  Copyright © 2019 Frank Ye. All rights reserved.
    //
    
    import UIKit
    import FirebaseDatabase
    import Firebase
    import BSImagePicker
    import Photos
    
    
    class PostViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate {
        
        @IBOutlet weak var imageArray: UICollectionView!
        
        
        @IBOutlet weak var priceField: UITextField!
        
        var SelectedAssets = [PHAsset]()
        var photoArray = [UIImage]()
        
        //@IBOutlet weak var image: UIImageView!
        var originalImage: UIImage!
        @IBOutlet weak var descriptionField: UITextView!
        @IBOutlet weak var titleField: UITextField!
        var ref: DatabaseReference!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            originalImage = #imageLiteral(resourceName: "c")
            imageArray.dataSource = self
            imageArray.delegate = self
            photoArray.append(originalImage)
            self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
            
            descriptionField.delegate = self
            descriptionField.text = "Enter your description here.........(be specific)"
            descriptionField.textColor = UIColor.lightGray
            
        }
        
        @objc func imageTapped(tapRecognizer: UITapGestureRecognizer){
            let imageView = tapRecognizer.view as! UIImageView
            if imageView.image != originalImage{
                fullScreen(imageView: imageView)
                return
            }
            let vc = BSImagePickerViewController()
            vc.maxNumberOfSelections = 4 - self.imageArray.visibleCells.count
            vc.takePhotos = true
            bs_presentImagePickerController(vc, animated: true,
                                            select: { (asset: PHAsset) -> Void in
                                                print("Selected: \(asset)")
            }, deselect: { (asset: PHAsset) -> Void in
                print("Deselected: \(asset)")
            }, cancel: { (assets: [PHAsset]) -> Void in
                print("Cancel: \(assets)")
            }, finish: { (assets: [PHAsset]) -> Void in
                print("Finish: \(assets)")
                //print(assets.count)
                for i in 0..<assets.count {
                    self.SelectedAssets.append(assets[i])
                }
                self.convertToUIImage(asset: self.SelectedAssets)
            }, completion: nil)
            
            
        }
        override func viewDidAppear(_ animated: Bool) {
            imageArray.reloadData()
        }
        
        func fullScreen(imageView: UIImageView){
            
            let newImageView = UIImageView(image: imageView.image)
            newImageView.frame = UIScreen.main.bounds
            newImageView.backgroundColor = .black
            newImageView.contentMode = .scaleAspectFit
            newImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
            newImageView.addGestureRecognizer(tap)
            self.view.addSubview(newImageView)
            self.navigationController?.isNavigationBarHidden = true
            self.tabBarController?.tabBar.isHidden = true
        }
        @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
            self.navigationController?.isNavigationBarHidden = false
            self.tabBarController?.tabBar.isHidden = false
            sender.view?.removeFromSuperview()
        }
        
        @IBAction func clearAll(_ sender: Any) {
            SelectedAssets.removeAll();
            convertToUIImage(asset: SelectedAssets)
            imageArray.reloadData()
        }
        
        @IBAction func onSubmit(_ sender: Any) {
            if titleField.text == "" {
                let alert = UIAlertController(title: "Please give a title for your item", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            else if descriptionField.text == "" {
                let alert = UIAlertController(title: "Please give a description for your item", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            else if priceField.text == "" {
                let alert = UIAlertController(title: "Please give a price for your item", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            else if photoArray.first == originalImage {
                let alert = UIAlertController(title: "Please add an image for your item", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
                
            else {
                
                
                
//                ref = Database.database().reference()
//                ref.child("Users").observeSingleEvent(of: .value, with: { (snapshot) in
//                    // Get user value
//                    let dict1 = snapshot.value as? [String:[String:Any]]
//
//                    guard let dict=dict1 else{
//                        print("empty")
//                        return
//                    }
//                    self.currentUser = User(dictionary: dict[userId] as! [String : AnyObject], key: userId)
//
//
//                    self.userNameLabel.text = self.currentUser?.name
//                    self.userIdLabel.text = self.currentUser?.key
//
//                    self.tableView.reloadData()
//                }) { (error) in
//                    print(error.localizedDescription)
//                }
//
//
                
                
                
                ref = Database.database().reference()
                let post = ref.child("Posts").childByAutoId()
                // Get a reference to the storage service using the default Firebase App
                let storage = Storage.storage()
                
                // Create a storage reference from our storage service
                let storageRef = storage.reference()
                let timestamp = Date().timeIntervalSince1970
                let user = self.ref.child("Users").child(Auth.auth().currentUser!.uid)
                user.child("post").setValue([post.key: post.key])
                post.setValue(["title": (self.titleField.text)! ,
                               "description": (self.descriptionField.text)!,
                               "timestamp": timestamp,
                               "price": (self.priceField.text)!,
                               "email": Auth.auth().currentUser?.email])
                for i in 0..<photoArray.count{
                    if photoArray[i] == originalImage {
                        continue
                    }
                    upload(storageRef: storageRef, post: post, i: i)
                }
                navigationController?.popViewController(animated: true)
            }
        }
        
        func upload(storageRef: StorageReference, post: DatabaseReference, i: Int){
            let data = photoArray[i].pngData()
            let photoName = post.key! + String(i)
            let picRef = storageRef.child("images/" + photoName)
            picRef.putData(data!, metadata: nil) { (metadata, error) in
                
                picRef.downloadURL { (url, error) in
                    guard let downloadURL = url?.absoluteString else {
                        return
                    }
                    //print(downloadURL)
                    //print(Auth.auth().currentUser!.uid)
                    post.child("images").updateChildValues([photoName: downloadURL])
                }
            }
        }
    
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if descriptionField.textColor == UIColor.lightGray {
                descriptionField.text = ""
                descriptionField.textColor = UIColor.black
            }
        }

        
        
        func convertToUIImage (asset: [PHAsset]){
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            photoArray.removeAll()
            for i in 0..<asset.count {
                option.isSynchronous = true
                manager.requestImage(for: asset[i], targetSize: CGSize(width: 600 , height: 600), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                    self.photoArray.append(result!)
                })
            }
            if photoArray.count < 3{
                photoArray.append(originalImage)
            }
        }
        

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return photoArray.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
            //let imageView = cell.viewWithTag(1) as! UIImageView
            //imageView.image = photoArray[indexPath.row]
            let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapRecognizer:)))
            cell.imageView.image = photoArray[indexPath.row]
            cell.imageView.addGestureRecognizer(tap)
            cell.imageView.isUserInteractionEnabled = true
            
            return cell
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

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
import AlamofireImage
class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var image: UIImageView!
    var originalImage: UIImage!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalImage = image.image
        //        let title = "test"
        //        self.ref.child("Posts").child("Post").setValue(["title": title])
        //        self.ref.child("Posts").child("Post").setValue(["description": title])
        
        // Do any additional setup after loading the view.
        //read()
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
        else if image.image == originalImage {
            let alert = UIAlertController(title: "Please add an image for your item", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else {
            navigationController?.popViewController(animated: true)
            ref = Database.database().reference()
            let postRef = ref.child("Posts").childByAutoId()
            // Get a reference to the storage service using the default Firebase App
            let storage = Storage.storage()
            
            // Create a storage reference from our storage service
            let storageRef = storage.reference()
            
            let data = image.image!.pngData()
            let picRef = storageRef.child("images/" + postRef.key!)
            
            picRef.putData(data!, metadata: nil) { (metadata, error) in
                /*guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                }*/
                // Metadata contains file metadata such as size, content-type.
                //let size = metadata.size
                // You can also access to download URL after upload.
                let timestamp = Date().timeIntervalSince1970
                picRef.downloadURL { (url, error) in
                    guard let downloadURL = url?.absoluteString else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    print(downloadURL)
                    postRef.setValue(["title": (self.titleField.text)! , "description": (self.descriptionField.text)!, "image": downloadURL,"timestamp":timestamp])
                }
            }
        }
    }
    
    
    @IBAction func onTapCamera(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        let alert = UIAlertController()
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 600, height: 600)
        let scaledImage = img.af_imageScaled(to: size)
        image.image = scaledImage
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    /*
     func read(){
     ref = Database.database().reference()
     ref.child("Posts").observeSingleEvent(of: .value, with: { (snapshot) in
     // Get user value
     let value = snapshot.value as? NSDictionary
     let title = value?["Post"] as? String ?? ""
     print(title)
     print("hi")
     // ...
     }) { (error) in
     print(error.localizedDescription)
     }
     
     }*/
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

//
//  MyProfilePage.swift
//  FirebaseDataDisplay
//
//  Created by mark me on 6/17/20.
//  Copyright © 2020 mark me. All rights reserved.
//


import UIKit
import Firebase

protocol AddModelProtocol: class {
    func didAddToArray(didAdd:AddModel)
}

struct AddModel {
    
    var image:UIImage
    var field1:String
    var field2:String
    var field3:String
}

class MyProfilePage: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var picture: UIImageView!
    @IBOutlet var text1: UITextField!
    @IBOutlet var text2: UITextField!
    @IBOutlet var text3: UITextField!
    @IBOutlet var desineButton: UIButton!
    
    weak var delegate:AddModelProtocol?
    static var refrence = DatabaseReference.init()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picture.layer.cornerRadius = picture.bounds.width/2
        picture.layer.borderWidth = 1.0
        picture.layer.borderColor = UIColor.purple.cgColor
        desineButton.layer.cornerRadius = 10
        
        MyProfilePage.self.refrence = Database.database().reference()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(MyProfilePage.tapped(gestureRecognizer:)))
        picture.addGestureRecognizer(tap)
        picture.isUserInteractionEnabled = true
        
        
    }
    @objc func tapped(gestureRecognizer: UITapGestureRecognizer) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        uploadButtonWasTapped()
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.picture.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any)
    {
        uploadButtonWasTapped()
        saveImage()
        guard let image = picture.image else {
            print("You must select an image")
            return
        }
        
        guard let text1 = text1.text else {
            print("text 1 should not be empty")
            return
        }
        guard let text2 = text2.text else {
            print("text 2 should not be empty")
            return
        }
        
        guard let text3 = text3.text else {
            print("text 3 should not be empty")
            return
        }
        
        delegate?.didAddToArray(didAdd: AddModel(image: image, field1: text1, field2: text2, field3: text3))
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func saveImage() {
        
        let mydic = ["firstName": text1.text!, "lastName": text2.text!, "emailId": text3.text!]
        MyProfilePage.refrence.child("infoData").childByAutoId().setValue(mydic)
    }
    
    func uploadButtonWasTapped() {
        let randomID = UUID.init().uuidString
        let uploadRef = Storage.storage().reference(withPath: "meemo/\(randomID).jpg")
        guard let imageData = picture.image?.jpegData(compressionQuality: 0.75) else {return }
        let uploadMetaData = StorageMetadata.init()
        uploadMetaData.contentType = "image/jpeg"
        
        uploadRef.putData(imageData, metadata: uploadMetaData) { (downloadMetaData, error) in
            
            if let error = error {
                print("Oh no! Got an error \(error.localizedDescription)")
                return
            }
            print("Image is uploaded successfullyed \(downloadMetaData)")
        }
    }
    
}

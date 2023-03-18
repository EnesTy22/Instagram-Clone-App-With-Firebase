//
//  UploadViewController.swift
//  InstaCloneWithFirebase
//
//  Created by Enes Talha Yılmaz on 7.03.2023.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore
class UploadViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var tfImageComment: UITextField!
    @IBOutlet weak var ivImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(OpenGallery))
        ivImage.addGestureRecognizer(imageTapGesture)
        ivImage.isUserInteractionEnabled = true
        
        // Do any additional setup after loading the view.
    }
    @objc func OpenGallery(){
        let uiImagePicker=UIImagePickerController()
        uiImagePicker.delegate = self
        uiImagePicker.sourceType = .photoLibrary
        uiImagePicker.allowsEditing = true
        present(uiImagePicker,animated: true,completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        ivImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true,completion: nil)
        
    }
    func PopAlert(titleInput: String,messageInput : String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: nil)
        alert.addAction(okButton)
    }
    @IBAction func btnUploadClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("media")
        if let data = ivImage.image?.jpegData(compressionQuality: 0.5)
        {
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data,metadata: nil) { metadata, error in
                if error != nil
                {
                    self.PopAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "UnknownError")
                    print(error?.localizedDescription)
                    
                }
                else{
                    imageReference.downloadURL { url, error in
                        if error == nil
                        {
                            let imageUrl = url?.absoluteString
                            let fireStoreDatabase = Firestore.firestore()
                            var firestoreReference : DocumentReference? = nil
                            let fireStorePost = ["imageUrl" : imageUrl!,"PostedBy":Auth.auth().currentUser!.email!,"postComment" : self.tfImageComment.text!,"date" : FieldValue.serverTimestamp(),"likes" : 0] as [String : Any]
                            firestoreReference = fireStoreDatabase.collection("Posts").addDocument(data: fireStorePost,completion: { error in
                                if error != nil{
                                    self.PopAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Unknown Error")
                                }
                                else{
                                    self.ivImage.image = UIImage(systemName: "photo.artframe")
                                    self.tfImageComment.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                            
                            
                        }
                        
                    }
                }
            }
        }
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

//
//  FeedViewController.swift
//  InstaCloneWithFirebase
//
//  Created by Enes Talha Yılmaz on 7.03.2023.
//

import UIKit
import Firebase
import SDWebImage
class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tvFeed: UITableView!
    var userImageArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userEmailArray = [String]()
    var userDocIDArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tvFeed.delegate = self
        tvFeed.dataSource = self
        // Do any additional setup after loading the view.
        GetFirestoreData()
    }
    func GetFirestoreData()
    {
        let firestoreDB = Firestore.firestore()
        firestoreDB.collection("Posts").order(by: "date", descending: true).addSnapshotListener { snapShot, error in
            if error != nil {
                print(error?.localizedDescription)
                
            }
            else
            {
                if snapShot?.isEmpty != true && snapShot != nil
                {
                    self.userImageArray.removeAll()
                    self.userEmailArray.removeAll()
                    self.userCommentArray.removeAll()
                    self.likeArray.removeAll()
                    for document in snapShot!.documents{
                        if let documentID = document.documentID as? String{
                            self.userDocIDArray.append(documentID)
                        }
                        if let postedBy = document.get("PostedBy") as? String{
                            self.userEmailArray.append(postedBy)
                        }
                        if let postComment = document.get("postComment") as? String{
                            self.userCommentArray.append(postComment)
                        }
                        if let like = document.get("likes") as? Int{
                            self.likeArray.append(like)
                        }
                        if let imageUrl = document.get("imageUrl") as? String{
                            self.userImageArray.append(imageUrl)
                        }
                    }
                    self.tvFeed.reloadData()

                }
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tvFeed.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        print(userCommentArray[indexPath.row])
        cell.lblComment.text = userCommentArray[indexPath.row]
        cell.lblLikeAmount.text = String(likeArray[indexPath.row])
        cell.lblUserEmail.text = userEmailArray[indexPath.row]
        cell.ivUser.sd_setImage(with:URL(string: userImageArray[indexPath.row]))
        cell.lblDocID.text=userDocIDArray[indexPath.row]
        return cell
    }

}

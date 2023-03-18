//
//  FeedCell.swift
//  InstaCloneWithFirebase
//
//  Created by Enes Talha Yılmaz on 10.03.2023.
//

import UIKit
import Firebase
class FeedCell: UITableViewCell {

    @IBOutlet weak var lblDocID: UILabel!
    @IBOutlet weak var lblUserEmail: UILabel!
    @IBOutlet weak var lblLikeAmount: UILabel!
    @IBOutlet weak var ivUser: UIImageView!
    @IBOutlet weak var lblComment: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func LikeButtonClicked(_ sender: Any) {
        
        let firestoreDB = Firestore.firestore()
        if let likeCount = Int(lblLikeAmount.text!) {
            let likeStore = ["likes":likeCount + 1] as [String : Any]
            firestoreDB.collection("Posts").document(lblDocID.text!).setData(likeStore, merge: true)
        }
    
    }
}

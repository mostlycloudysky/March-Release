//
//  UserProfileHeader.swift
//  Lets Wander
//
//  Created by Sandeep Kumar  Yaramchitti on 3/30/18.
//  Copyright © 2018 Sandeep Kumar  Yaramchitti. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
    
    //Set up profile image
    var user: User? {
        
        didSet{
            guard let profileImageUrl = user?.profileImageUrl else {return}
            profileImageView.loadImage(urlString: profileImageUrl)
            userNameLebel.text = user?.username
            setUpEditProfileButton()
        }
        
    }

    
    let profileImageView: CustomImageView = {
      let imageView = CustomImageView()
      //imageView.backgroundColor = UIColor.red
      return imageView
    }()
    
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
//        button.tintColor = UIColor(white: 0, alpha: 0.1)
        return button
    }()
    
    
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.3)
        return button
    }()
    
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.3)
        return button
    }()
    
    let userNameLebel: UILabel = {
        let label = UILabel()
        label.text = "Sandeep Kumar Y"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.white
        return label
    }()
    
    let groupLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n",
                                                       attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "Groups", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.white
        return label
    }()
    
    let postsLabel: UILabel = {
       let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "11\n",
                                                       attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "Posts", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
       //label.text = "0\nposts"
       label.numberOfLines = 0
       label.textAlignment = .center
       label.font = UIFont.boldSystemFont(ofSize: 16)
       label.textColor = UIColor.white
       return label
    }()
    
    let followesLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n",
                                                       attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "Followers", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.white
        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        //label.text = "0\nfollowing"
        let attributedText = NSMutableAttributedString(string: "0\n",
                                                       attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "Following", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profiles", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(editProfileOrFollow), for: .touchUpInside)
        return button
    }()
    
    
    @objc  func editProfileOrFollow() {
        print("Implement logic to edit profile / follow / unfollow logic...")
        guard let currentLoggedInUser = Auth.auth().currentUser?.uid else {return}
        guard let userID = user?.uid else {return}
        //Unfollow Logic
        if editProfileButton.titleLabel?.text == "Unfollow" {
            Database.database().reference().child("Following").child(currentLoggedInUser).child(userID).removeValue { (err, ref) in
                if let err = err {
                    print("Failed to unfollow user", err)
                    return
                }
                print("Successfully unfollowed the user:", self.user?.username ?? "")
               self.setUpFollowStyling()
            }
            
        }else {
            //Follow Logic
            let ref = Database.database().reference().child("Following").child(currentLoggedInUser)
            let values = [userID: 1]
            ref.updateChildValues(values) { (err, ref) in
                if let err = err {
                    print("Failed to update value for following infomration in DB", err)
                    return
                }
                print("Successfuly followed the user: ", self.user?.username ?? "")
                self.editProfileButton.setTitle("Unfollow", for: .normal)
                self.editProfileButton.backgroundColor = UIColor.white
                self.editProfileButton.setTitleColor(UIColor.black, for: .normal)
            }
        }
        
        
    }
    
    fileprivate func setUpFollowStyling() {
        self.editProfileButton.setTitle("Follow", for: .normal)
        self.editProfileButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237, alpha: 1)
        self.editProfileButton.setTitleColor(UIColor.white, for: .normal)
        self.editProfileButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [Colors.logoBlueColor.cgColor, Colors.logoRedColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        self.layer.insertSublayer(gradientLayer, at: 0)
        addSubview(profileImageView)
        //profileImageView.layer.cornerRadius = 100/2
        //profileImageView.clipsToBounds = true
        
        _ = profileImageView.anchor(self.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 180, heightConstant: 120)
        profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 3
        
        //setUpButtomToolBar()
        addSubview(userNameLebel)
      
        _ = userNameLebel.anchor(profileImageView.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        userNameLebel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
       
        setUpUserStats()
        
        addSubview(editProfileButton)
        _ = editProfileButton.anchor(self.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 15, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 34)
    }
    
    fileprivate func setUpUserStats(){
        let stackView = UIStackView(arrangedSubviews: [groupLabel, postsLabel, followesLabel,followingLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        _ = stackView.anchor(userNameLebel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 23, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
    }
    
    //Set up Tool bar
    fileprivate func setUpButtomToolBar(){
        
//        let topDividerView = UIView()
//        topDividerView.backgroundColor = UIColor.white
//        let bottomDividerView = UIView()
//        topDividerView.backgroundColor = UIColor.white
        
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        _ = stackView.anchor(profileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 120, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
    }
    
    

    
    fileprivate func setUpEditProfileButton() {
        guard let currentLoggedInuserID = Auth.auth().currentUser?.uid else {return}
        guard let userId = user?.uid else {return}
        
        if currentLoggedInuserID == userId {
            
        }else {
           //Check if following
            Database.database().reference().child("Following").child(currentLoggedInuserID).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                    
                    self.editProfileButton.setTitle("Unfollow", for: .normal)
                }else{
                    self.setUpFollowStyling()
                }
            }) { (err) in
                print("Could not fetch the following information", err)
            }
            
         
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

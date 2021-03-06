//
//  Config.swift
//  ios
//
//  Created by Matthew on 1/20/20.
//  Copyright © 2020 bahlsenwitz. All rights reserved.
//

import UIKit

class Config:
    UIViewController,
    UITabBarDelegate,
    UIGestureRecognizerDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
UIDropInteractionDelegate {
    
    var titleText: String?
    
    func setTitleText(titleText: String) {
        self.titleText = titleText
    }
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var splitViewHeight0: NSLayoutConstraint!
    @IBOutlet weak var splitViewHeight1: NSLayoutConstraint!
    @IBOutlet weak var splitViewHeight2: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var displacementImage: UIImageView!
    @IBOutlet weak var displacementLabel: UILabel!
    @IBOutlet weak var eloLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var configCollectionView0: DynamicCollectionView!
    @IBOutlet weak var configCollectionViewHeight0: NSLayoutConstraint!
    
    
    @IBOutlet weak var configCollectionView1: DynamicCollectionView!
    @IBOutlet weak var configCollectionViewHeight1: NSLayoutConstraint!
    
    @IBOutlet weak var configCollectionView2: DynamicCollectionView!
    @IBOutlet weak var configCollectionViewHeight2: NSLayoutConstraint!
    
    
    @IBOutlet weak var tabBarMenu: UITabBar!
    
    let dateTime: DateTime = DateTime()
    var attributeAlphaDotFull: [NSAttributedString.Key: NSObject]?
    var attributeAlphaDotHalf: [NSAttributedString.Key: NSObject]?
    
    var updatePhotoGesture: UITapGestureRecognizer?
    var swipeRightGesture: UISwipeGestureRecognizer?
    var swipeLeftGesture: UISwipeGestureRecognizer?
    
    let reuseIdentifier = "cell"
    
    var items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16"]
    
    var arrayFirst = [
        "red_pawn",
        "red_knight",
        "red_bishop",
        "red_rook",
        "red_queen",
        "red_amazon",
        "red_landmine_pawn",
        "red_hunter",
        "red_grasshopper",
        "red_arrow"]
    
    var tschessElementMatrix0: [[TschessElement?]]?
    var tschessElementMatrix1: [[TschessElement?]]?
    var tschessElementMatrix2: [[TschessElement?]]?
    
    var selectionElementName: String?
    var cacheCancelMatrix: [[TschessElement?]]?
    var cacheMatrix: [[TschessElement?]]?
    
    var points: Int?
    
    var deviceType: String?
    var player: Player?
    
    public func setPlayer(player: Player){
        self.player = player
    }
    
    //MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.isHidden = true
        
        self.deviceType = StoryboardSelector().device()
        
        self.configCollectionView0.delegate = self
        self.configCollectionView0.dataSource = self
        let editCollectionView0 = UITapGestureRecognizer(target: self, action: #selector(self.editCollectionView0))
        self.configCollectionView0.addGestureRecognizer(editCollectionView0)
        
        self.configCollectionView1.delegate = self
        self.configCollectionView1.dataSource = self
        let editCollectionView1 = UITapGestureRecognizer(target: self, action: #selector(self.editCollectionView1))
        self.configCollectionView1.addGestureRecognizer(editCollectionView1)
        
        self.configCollectionView2.delegate = self
        self.configCollectionView2.dataSource = self
        let editCollectionView2 = UITapGestureRecognizer(target: self, action: #selector(self.editCollectionView2))
        self.configCollectionView2.addGestureRecognizer(editCollectionView2)
        
        self.tabBarMenu.delegate = self
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        let homeStoryboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = homeStoryboard.instantiateViewController(withIdentifier: "Home") as! Home
        homeViewController.setPlayer(player: self.player!)
        UIApplication.shared.keyWindow?.rootViewController = homeViewController
    }
    
    var gameModel: Game?
    
    func setGameModel(gameModel: Game){
        self.gameModel = gameModel
    }
    
    @objc func editCollectionView0() {
        let storyboard: UIStoryboard = UIStoryboard(name: "EditSelf", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "EditSelf") as! EditSelf
        viewController.setPlayer(player: self.player!)
        viewController.setTitleText(titleText: "config. 0̸")
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
    
    @objc func editCollectionView1() {
        let storyboard: UIStoryboard = UIStoryboard(name: "EditSelf", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "EditSelf") as! EditSelf
        viewController.setPlayer(player: self.player!)
        viewController.setTitleText(titleText: "config. 1")
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
    
    @objc func editCollectionView2() {
        let storyboard: UIStoryboard = UIStoryboard(name: "EditSelf", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "EditSelf") as! EditSelf
        viewController.setPlayer(player: self.player!)
        viewController.setTitleText(titleText: "config. 2")
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let dataDecoded: Data = Data(base64Encoded: self.player!.getAvatar(), options: .ignoreUnknownCharacters)!
        let decodedimage = UIImage(data: dataDecoded)
        self.avatarImageView.image = decodedimage
        
        self.usernameLabel.text = self.player!.getUsername()
        
        self.eloLabel.text = self.player!.getElo()
        self.rankLabel.text = self.player!.getRank()
        self.displacementLabel.text = String(abs(Int(self.player!.getDisp())!))
        
        let disp: Int = Int(self.player!.getDisp())!
        
        if(disp >= 0){
            if #available(iOS 13.0, *) {
                let image = UIImage(systemName: "arrow.up")!
                self.displacementImage.image = image
                self.displacementImage.tintColor = .green
            }
        }
        else {
            if #available(iOS 13.0, *) {
                let image = UIImage(systemName: "arrow.down")!
                self.displacementImage.image = image
                self.displacementImage.tintColor = .red
            }
        }
        
        self.tschessElementMatrix0 = self.player!.getConfig0()
        self.tschessElementMatrix1 = self.player!.getConfig1()
        self.tschessElementMatrix2 = self.player!.getConfig2()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let totalContentHeight = self.contentView.frame.size.height - 8
        
        self.splitViewHeight0.constant = totalContentHeight/3
        self.splitViewHeight1.constant = totalContentHeight/3
        self.splitViewHeight2.constant = totalContentHeight/3
        
        self.configCollectionView0.bounces = false
        self.configCollectionView0.alwaysBounceVertical = false
        self.configCollectionViewHeight0.constant = configCollectionView0.contentSize.height
        
        
        self.configCollectionView1.bounces = false
        self.configCollectionView1.alwaysBounceVertical = false
        self.configCollectionViewHeight1.constant = configCollectionView1.contentSize.height
        
        
        self.configCollectionView2.bounces = false
        self.configCollectionView2.alwaysBounceVertical = false
        self.configCollectionViewHeight2.constant = configCollectionView2.contentSize.height
        
        
        
    }
    
    @objc func renderElementCollectionView() {
        self.avatarImageView.removeGestureRecognizer(self.updatePhotoGesture!)
        self.view.removeGestureRecognizer(self.swipeRightGesture!)
        self.view.removeGestureRecognizer(self.swipeLeftGesture!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.configCollectionView0.reloadData()
        self.configCollectionView1.reloadData()
        self.configCollectionView2.reloadData()
    }
}

//MARK: - UICollectionViewDataSource
extension Config: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.configCollectionView0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ConfigCollectionViewCell
            
            if (indexPath.row % 2 == 0) {
                if (indexPath.row / 8 == 0) {
                    //cell.backgroundColor = UIColor(red: 220/255.0, green: 0/255.0, blue: 70/255.0, alpha: 0.65)
                    cell.backgroundColor = .black
                    //cell.backgroundColor = .black
                    //cell.alpha = 0.01
                } else {
                    //cell.backgroundColor = UIColor(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 0.88)
                    cell.backgroundColor = .white
                    //cell.alpha = 1
                }
            } else {
                if (indexPath.row / 8 == 0) {
                    //cell.backgroundColor = UIColor(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 0.88)
                    cell.backgroundColor = .white
                    //cell.alpha = 1
                } else {
                    //cell.backgroundColor = UIColor(red: 220/255.0, green: 0/255.0, blue: 70/255.0, alpha: 0.65)
                    cell.backgroundColor = .black
                    //cell.backgroundColor = .black
                    //cell.alpha = 0.01
                }
            }
            
            let x = indexPath.row / 8
            let y = indexPath.row % 8
            
            if(self.tschessElementMatrix0![x][y] != nil){
                cell.imageView.image = self.tschessElementMatrix0![x][y]!.getImageDefault()
            } else {
                cell.imageView.image = nil
            }
            cell.imageView.bounds = CGRect(origin: cell.bounds.origin, size: cell.bounds.size)
            cell.imageView.center = CGPoint(x: cell.bounds.size.width/2, y: cell.bounds.size.height/2)
            return cell
        }
        if collectionView == self.configCollectionView1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ConfigCollectionViewCell
            
            if (indexPath.row % 2 == 0) {
                if (indexPath.row / 8 == 0) {
                    //cell.backgroundColor = UIColor(red: 220/255.0, green: 0/255.0, blue: 70/255.0, alpha: 0.65)
                    cell.backgroundColor = .black
                } else {
                    //cell.backgroundColor = UIColor(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 0.88)
                    cell.backgroundColor = .white
                }
            } else {
                if (indexPath.row / 8 == 0) {
                    //cell.backgroundColor = UIColor(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 0.88)
                    cell.backgroundColor = .white
                } else {
                    //cell.backgroundColor = UIColor(red: 220/255.0, green: 0/255.0, blue: 70/255.0, alpha: 0.65)
                    cell.backgroundColor = .black
                }
            }
            
            let x = indexPath.row / 8
            let y = indexPath.row % 8
            
            if(self.tschessElementMatrix1![x][y] != nil){
                cell.imageView.image = self.tschessElementMatrix1![x][y]!.getImageDefault()
            } else {
                cell.imageView.image = nil
            }
            cell.imageView.bounds = CGRect(origin: cell.bounds.origin, size: cell.bounds.size)
            cell.imageView.center = CGPoint(x: cell.bounds.size.width/2, y: cell.bounds.size.height/2)
            return cell
        }
        //if collectionView == self.configCollectionView2 {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ConfigCollectionViewCell
        
        if (indexPath.row % 2 == 0) {
            if (indexPath.row / 8 == 0) {
                //cell.backgroundColor = UIColor(red: 220/255.0, green: 0/255.0, blue: 70/255.0, alpha: 0.65)
                cell.backgroundColor = .black
            } else {
                //cell.backgroundColor = UIColor(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 0.88)
                cell.backgroundColor = .white
            }
        } else {
            if (indexPath.row / 8 == 0) {
                //cell.backgroundColor = UIColor(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 0.88)
                cell.backgroundColor = .white
            } else {
                //cell.backgroundColor = UIColor(red: 220/255.0, green: 0/255.0, blue: 70/255.0, alpha: 0.65)
                cell.backgroundColor = .black
            }
        }
        
        let x = indexPath.row / 8
        let y = indexPath.row % 8
        
        if(self.tschessElementMatrix2![x][y] != nil){
            cell.imageView.image = self.tschessElementMatrix2![x][y]!.getImageDefault()
        } else {
            cell.imageView.image = nil
        }
        cell.imageView.bounds = CGRect(origin: cell.bounds.origin, size: cell.bounds.size)
        cell.imageView.center = CGPoint(x: cell.bounds.size.width/2, y: cell.bounds.size.height/2)
        return cell
        
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension Config: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsAcross: CGFloat = 8
        let dim = collectionView.frame.width / cellsAcross
        return CGSize(width: dim, height: dim)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension Config: UICollectionViewDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 1:
            //print("fairy")
            let storyboard: UIStoryboard = UIStoryboard(name: "Fairy", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "Fairy") as! Fairy
            viewController.setPlayer(player: self.player!)
            UIApplication.shared.keyWindow?.rootViewController = viewController
        default:
            StoryboardSelector().home(player: self.player!)
        }
    }
    
}





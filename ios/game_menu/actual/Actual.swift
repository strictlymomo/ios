//
//  ViewControllerGameMenu.swift
//  ios
//
//  Created by Matthew on 7/27/19.
//  Copyright © 2019 bahlsenwitz. All rights reserved.
//

import UIKit

class Actual: UIViewController, UITabBarDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var displacementLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: Properties
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var eloLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tabBarMenu: UITabBar!
    @IBOutlet weak var rankDirectionImage: UIImageView!
    
    var actualTable: ActualTable?
    
    var player: Player?
    
    public func setPlayer(player: Player){
        self.player = player
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarMenu.delegate = self
        actualTable = children.first as? ActualTable
        actualTable!.setPlayer(player: self.player!)
        //actualTable!.setIndicator(indicator: self.activityIndicator!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let dataDecoded: Data = Data(base64Encoded: self.player!.getAvatar(), options: .ignoreUnknownCharacters)!
        let decodedimage = UIImage(data: dataDecoded)
        self.avatarImageView.image = decodedimage
        self.rankLabel.text = self.player!.getRank()
        self.usernameLabel.text = self.player!.getUsername()
        self.eloLabel.text = self.player!.getElo()
        self.displacementLabel.text = String(abs(Int(self.player!.getDisp())!))
        
        let disp: Int = Int(self.player!.getDisp())!
        
        if(disp >= 0){
            if #available(iOS 13.0, *) {
                let image = UIImage(systemName: "arrow.up")!
                self.rankDirectionImage.image = image
                self.rankDirectionImage.tintColor = .green
            }
        }
        else {
            if #available(iOS 13.0, *) {
                let image = UIImage(systemName: "arrow.down")!
                self.rankDirectionImage.image = image
                self.rankDirectionImage.tintColor = .red
            }
        }
        
        self.activityIndicator.isHidden = true
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 0:
            StoryboardSelector().home(player: self.player!)
        default:
            StoryboardSelector().historic(player: self.player!)
        }
    }
    
    @objc func onDidReceiveData(_ notification: NSNotification) {
        let gameMenuSelectionIndex = notification.userInfo!["actual_selection"] as! Int
        let gameModel = self.actualTable!.getGameMenuTableList()[gameMenuSelectionIndex]
        let action = notification.userInfo!["action"] as! String
        let gameList = self.actualTable!.getGameMenuTableList() //TODO: why do you need this???
        if(action == "review") {
            //StoryboardSelector().review(player: self.player!, gameModel: gameModel, gameList: gameList)
            return
        }
        if(action == "rescind") {
            //StoryboardSelector().cancel(player: self.player!, gameModel: gameModel, gameList: gameList)
            return
        }
        let tschessElementMatrix = [[TschessElement?]](repeating: [TschessElement?](repeating: nil, count: 8), count: 8)
        let gamestate = Gamestate(
            gameModel: gameModel,
            tschessElementMatrix: tschessElementMatrix
        )
        gamestate.setPlayer(player: self.player!)
        PollingAgent().execute(id: self.actualTable!.getGameMenuTableList()[gameMenuSelectionIndex].getIdentifier(), gamestate: gamestate) { (result, error) in
            if(error != nil || result == nil){
                return
            }
            let gameModel = self.actualTable!.getGameMenuTableList()[gameMenuSelectionIndex]
            StoryboardSelector().chess(gameModel: gameModel, player: gamestate.getPlayer(), gamestate: result!)
        }
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        StoryboardSelector().home(player: self.player!)
    }
}


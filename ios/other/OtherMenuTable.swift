//
//  OtherMenuTable.swift
//  ios
//
//  Created by Matthew on 1/19/20.
//  Copyright © 2020 bahlsenwitz. All rights reserved.
//

import UIKit

class OtherMenuTable: UITableViewController {
    
    let DATE_TIME: DateTime = DateTime()
    
    var gameMenuTableList: [Game] = [Game]()
    var gameModel: Game?
    var label: UILabel?
    
    public var pageFromWhichContentLoads: Int
    
    required init?(coder aDecoder: NSCoder) {
        self.pageFromWhichContentLoads = 0
        super.init(coder: aDecoder)
    }
    
    func getGameMenuTableList() -> [Game] {
        return gameMenuTableList
    }
    
    public func setGameModel(gameModel: Game) {
        self.gameModel = gameModel
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameMenuTableList.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OtherMenuCell", for: indexPath) as! OtherMenuCell
        
        let gameTableMenuItem = gameMenuTableList[indexPath.row]
        
        let dataDecoded: Data = Data(base64Encoded: gameTableMenuItem.getOpponentAvatar(), options: .ignoreUnknownCharacters)!
        let decodedimage = UIImage(data: dataDecoded)
        cell.avatarImageView.image = decodedimage
        //cell.eloLabel.text = gameTableMenuItem.getOpponentElo()
        cell.usernameLabel.text = gameTableMenuItem.getUsernameOpponent()
        //cell.usernameLabel.textColor = UIColor.black
        
        
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YY"
        var yayayaya = formatter.string(from: DATE_TIME.toFormatDate(string: gameTableMenuItem.endDate))
        yayayaya.insert("'", at: yayayaya.index(yayayaya.endIndex, offsetBy: -2))
        cell.terminalDateLabel.text = yayayaya //should be terminated date, not the created date
        
    
        let winnerInt: Int = gameTableMenuItem.winnerInt
        
        if(winnerInt == 1){
            cell.contentView.backgroundColor = Colour().getWin()
        }
        if(winnerInt == -1){
            cell.contentView.backgroundColor = Colour().getLoss()
        }
        if(winnerInt == 0){
            cell.contentView.backgroundColor = Colour().getDraw()
        }
        
        let oddsInt: Int = gameTableMenuItem.odds
        
        if(oddsInt >= 0){
            cell.oddsLabel.text = "+"
        } else {
            cell.oddsLabel.text = "-"
        }
        
        cell.displacementLabel.text = String(abs(gameTableMenuItem.disp))
        
        let disp: Int = gameTableMenuItem.disp
        
        if(disp >= 0){
            if #available(iOS 13.0, *) {
                let image = UIImage(systemName: "arrow.up")!
                cell.displacementImage.image = image
                cell.displacementImage.tintColor = .green
            }
        }
        else {
            if #available(iOS 13.0, *) {
                let image = UIImage(systemName: "arrow.down")!
                cell.displacementImage.image = image
                cell.displacementImage.tintColor = .red
            }
        }
        
        
        
        
        //cell.displacementLabel.text = gameTableMenuItem.disp
        
        //cell.eloLabel.textColor = UIColor.black
        //if(gameTableMenuItem.winner == self.gameModel!.getUsernameOpponent()){
            
            //
            
            //if(gameMenuTableList[indexPath.row].getDrawProposer().contains("TIMEOUT")){
                //cell.actionLabel.text = "timeout"
                //gameMenuTableList[indexPath.row].setOutcome(outcome: "TIMEOUT")
            //} else {
                //cell.actionLabel.text = "win"
                //gameMenuTableList[indexPath.row].setOutcome(outcome: "WIN")
            //}
//        }
//        else if(gameTableMenuItem.winner == "DRAW"){
//            //cell.actionLabel.text = "draw"
//            cell.contentView.backgroundColor = Colour().getDraw()
//            gameMenuTableList[indexPath.row].setOutcome(outcome: "DRAW")
//        } else {
//
//            if(gameMenuTableList[indexPath.row].getDrawProposer().contains("TIMEOUT")){
//                //cell.actionLabel.text = "timeout"
//                gameMenuTableList[indexPath.row].setOutcome(outcome: "TIMEOUT")
//            } else {
//                //cell.actionLabel.text = "loss"
//                gameMenuTableList[indexPath.row].setOutcome(outcome: "LOSS")
//            }
//            cell.contentView.backgroundColor = Colour().getLoss()
//
//
//        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let discoverSelectionDictionary = ["challenge_menu_game_selection": indexPath.row]
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: "ChallengeMenuTableView"),
            object: nil,
            userInfo: discoverSelectionDictionary)
    }
    
    override open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.gameMenuTableList.count - 1 {
            self.pageFromWhichContentLoads += 1
            self.fetchMenuTableList()
        }
    }
    
    func fetchMenuTableList() {
//        let pageHistoric = PageHistoric()
//        pageHistoric.setName(name: self.gameModel!.getUsernameOpponent())
//        pageHistoric.setMatrixDeserializer(name: self.gameModel!.getUsernameOpponent())
//        pageHistoric.executeLeaderboard(gameModel: self.gameModel!, page: self.pageFromWhichContentLoads){ (result) in
//            if(result == nil){
//                self.renderShrug()
//                print("0 - 0")
//                return
//            }
//            print("1 - 1")
//            self.appendToLeaderboardTableList(additionalCellList: result!)
//        }
        DispatchQueue.main.async() {
            //self.activityIndicator!.isHidden = false
            //self.activityIndicator!.startAnimating()
            
        }
        let REQUEST_PAGE_SIZE: Int = 9
        let requestPageIndex: Int = 0
        let requestPayload = [
            "id": self.gameModel!.getOpponent().getId(),
            "index": requestPageIndex,
            "size": REQUEST_PAGE_SIZE
            ] as [String: Any]
        RequestHistoricOther().execute(requestPayload: requestPayload) { (result) in
            DispatchQueue.main.async() {
                //self.activityIndicator!.stopAnimating()
                //self.activityIndicator!.isHidden = true
            }
            if(result == nil){
                return
            }
            self.appendToLeaderboardTableList(additionalCellList: result!)
        }
    }
    
    func appendToLeaderboardTableList(additionalCellList: [Game]) {
        let currentCount = self.gameMenuTableList.count
        
        for game in additionalCellList {
            if(!self.gameMenuTableList.contains(game)){
                self.gameMenuTableList.append(game)
            }
        }
        if(currentCount != self.gameMenuTableList.count){
            //self.gameMenuTableList = self.gameMenuTableList.sorted(by: { $0.created! > $1.created! })
            DispatchQueue.main.async() {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let modifyAction = UIContextualAction(style: .normal, title:  "CHALLENGE", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Update action ...")
            let gameModel = self.gameMenuTableList[indexPath.row]
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Challenge", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "Challenge") as! Challenge
            viewController.setPlayer(player: self.player!)
            viewController.setGameModel(gameModel: gameModel)
            UIApplication.shared.keyWindow?.rootViewController = viewController
            success(true)
        })
        if #available(iOS 13.0, *) {
            modifyAction.image = UIImage(systemName: "gamecontroller.fill")!
        }
        modifyAction.backgroundColor = .purple
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }
    
    var player: Player?
    
    
    public func setPlayer(player: Player){
        self.player = player
    }
    
    private func renderShrug(){  // this can exist in practice...
        DispatchQueue.main.async() {
            let frameSize: CGPoint = CGPoint(x: UIScreen.main.bounds.size.width*0.5, y: UIScreen.main.bounds.size.height*0.5)
            let label = UILabel(frame: CGRect(x: UIScreen.main.bounds.size.width*0.5, y: UIScreen.main.bounds.size.height*0.5, width: UIScreen.main.bounds.width, height: 40))
            label.textColor = UIColor.white
            label.center = frameSize
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.light)
            label.translatesAutoresizingMaskIntoConstraints = false
            let horizontalConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
            let verticalConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
            label.text = "¯\\_( ͡° ͜ʖ ͡°)_/¯"
            self.view.addSubview(label)
            self.view.addConstraints([horizontalConstraint, verticalConstraint])
        }
    }
}

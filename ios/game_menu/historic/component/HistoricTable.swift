//
//  GameTableViewController.swift
//  ios
//
//  Created by Matthew on 7/27/19.
//  Copyright © 2019 bahlsenwitz. All rights reserved.
//

import UIKit

class HistoricTable: UITableViewController {
    
    let DATE_TIME: DateTime = DateTime()
    
    var gameMenuTableList: [Game] = [Game]()
    var player: Player?
    var label: UILabel?
    
    public var pageFromWhichContentLoads: Int
    
    required init?(coder aDecoder: NSCoder) {
        self.pageFromWhichContentLoads = 0
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.tableFooterView = UIView()
        
        self.fetchMenuTableList(id: self.player!.getId())
    }
    
    func getGameMenuTableList() -> [Game] {
        return gameMenuTableList
    }
    
    public func setPlayer(player: Player) {
        self.player = player
    }
    
    var activityIndicator: UIActivityIndicatorView?
    
    public func setIndicator(indicator: UIActivityIndicatorView){
        self.activityIndicator = indicator
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameMenuTableList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoricCell", for: indexPath) as! HistoricCell
        
        let gameTableMenuItem = gameMenuTableList[indexPath.row]
        cell.usernameLabel.text = gameTableMenuItem.getUsernameOpponent()
        
        let dataDecoded: Data = Data(base64Encoded: gameTableMenuItem.getOpponentAvatar(), options: .ignoreUnknownCharacters)!
        let decodedimage = UIImage(data: dataDecoded)
        cell.avatarImageView.image = decodedimage
        
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd.MM.YY"
//        var yayayaya = formatter.string(from: gameTableMenuItem.end!)
//        yayayaya.insert("'", at: yayayaya.index(yayayaya.endIndex, offsetBy: -2))
//        cell.terminalDateLabel.text = yayayaya //should be terminated date, not the created date
//
//        let dataDecoded: Data = Data(base64Encoded: gameTableMenuItem.getOpponentAvatar(), options: .ignoreUnknownCharacters)!
//        let decodedimage = UIImage(data: dataDecoded)
//        cell.avatarImageView.image = decodedimage
//
//        cell.usernameLabel.textColor = UIColor.black
//
//        if(gameTableMenuItem.winner == self.player!.getUsername()){
//
//            cell.contentView.backgroundColor = Colour().getWin()
//            if(gameMenuTableList[indexPath.row].getDrawProposer().contains("TIMEOUT")){
//                gameMenuTableList[indexPath.row].setOutcome(outcome: "TIMEOUT")
//            } else {
//                gameMenuTableList[indexPath.row].setOutcome(outcome: "WIN")
//            }
//        }
//        else if(gameTableMenuItem.winner == "DRAW"){
//            cell.contentView.backgroundColor = Colour().getDraw()
//            gameMenuTableList[indexPath.row].setOutcome(outcome: "DRAW")
//        } else {
//            cell.contentView.backgroundColor = Colour().getLoss()
//
//            if(gameMenuTableList[indexPath.row].getDrawProposer().contains("TIMEOUT")){
//                gameMenuTableList[indexPath.row].setOutcome(outcome: "TIMEOUT")
//            } else {
//                gameMenuTableList[indexPath.row].setOutcome(outcome: "LOSS")
//            }
//        }
        
        //cell.usernameLabel.text = gameTableMenuItem.getUsernameOpponent()
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
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let discoverSelectionDictionary: [String: Any] = ["historic_selection": indexPath.row]
        
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: "HistoricSelection"),
            object: nil,
            userInfo: discoverSelectionDictionary)
    }
    
    override open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(tableView.selectionCount < 13 && self.pageFromWhichContentLoads > 0){
            return
        }
        if indexPath.row == self.gameMenuTableList.count - 1 {
            self.pageFromWhichContentLoads += 1
            self.fetchMenuTableList(id: self.player!.getId())
        }
    }
    
    func appendToTableList(additionalCellList: [Game]) {
        let currentCount = self.gameMenuTableList.count
        for game in additionalCellList {
            if(!self.gameMenuTableList.contains(game)){
                self.gameMenuTableList.append(game)
            }
        }
        if(currentCount != self.gameMenuTableList.count){
            //self.gameMenuTableList = self.gameMenuTableList.sorted(by: { $0.created! > $1.created! })
            DispatchQueue.main.async() {
                //self.activityIndicator!.stopAnimating()
                //self.activityIndicator!.isHidden = true
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchMenuTableList(id: String) {
//        let pageHistoric = PageHistoric()
//        pageHistoric.setName(name: self.player!.getUsername())
//        pageHistoric.setMatrixDeserializer(name: self.player!.getUsername())
//        pageHistoric.execute(id: self.player!.getId(), page: self.pageFromWhichContentLoads){ (result) in
//            if(result == nil){
//                return
//            }
//            let resultList: [Game] = result!
//            if(resultList.count == 0) {
//                self.renderShrug()
//                return
//            }
//            if(self.label != nil) {
//                self.label!.removeFromSuperview()
//            }
//            self.appendToTableList(additionalCellList: resultList)
//        }
        let REQUEST_PAGE_SIZE: Int = 9
        let requestPageIndex: Int = 0
        let requestPayload = [
            "id": self.player!.getId(),
            "index": requestPageIndex,
            "size": REQUEST_PAGE_SIZE
            ] as [String: Any]
        RequestHistoricSelf().execute(requestPayload: requestPayload) { (result) in
            DispatchQueue.main.async() {
                //self.activityIndicator!.stopAnimating()
                //self.activityIndicator!.isHidden = true
            }
            if(result == nil){
                return
            }
            self.appendToTableList(additionalCellList: result!)
        }
    }
    
    private func renderShrug(){  // thiis can exist in practice...
        DispatchQueue.main.async() {
        let frameSize: CGPoint = CGPoint(x: UIScreen.main.bounds.size.width*0.5, y: UIScreen.main.bounds.size.height*0.5)
        self.label = UILabel(frame: CGRect(x: UIScreen.main.bounds.size.width*0.5, y: UIScreen.main.bounds.size.height*0.5, width: UIScreen.main.bounds.width, height: 40))
        self.label!.center = frameSize
        self.label!.textAlignment = .center
        self.label!.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.light)
        self.label!.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: self.label!, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: self.label!, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        
            //self.activityIndicator!.stopAnimating()
            self.label!.text = "¯\\_( ͡° ͜ʖ ͡°)_/¯"
            self.view.addSubview(self.label!)
            self.view.addConstraints([horizontalConstraint, verticalConstraint])
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let gameTableMenuItem = gameMenuTableList[indexPath.row]
//        if(!gameTableMenuItem.inbound!){
//           return nil
//        }
        let modifyAction = UIContextualAction(style: .normal, title:  "REMATCH", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Update action ...")
            let gameModel = self.gameMenuTableList[indexPath.row]
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Challenge", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "Challenge") as! Challenge
            viewController.setPlayer(player: self.player!)
            viewController.setGameModel(gameModel: gameModel)
            UIApplication.shared.keyWindow?.rootViewController = viewController
            success(true)
        })
        if #available(iOS 13.0, *) { //xmark
            modifyAction.image = UIImage(systemName: "gamecontroller.fill")!
        }
        modifyAction.backgroundColor = .purple
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }
}

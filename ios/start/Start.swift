//
//  ViewController.swift
//  ios
//
//  Created by Matthew on 7/25/19.
//  Copyright © 2019 bahlsenwitz. All rights reserved.
//
import UIKit

class Start: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var recoverAccountButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var contentView: UIView!
    //MARK: Properties
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var buttonCreate: UIButton!
    
    
    
    @IBOutlet weak var easterEggImageView: UIImageView!
    @IBOutlet weak var easterEggLabel: UILabel!
    var easterEggCounter: Int?
    
    var deviceId: String?
    let dateTime: DateTime = DateTime()
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    var usernameTextString: String?
    @IBOutlet weak var passwordTextField: UITextField!
    var passwordTextString: String?
    
    @IBAction func loginButtonClick(_ sender: UIButton) {
        self.usernameTextString = usernameTextField.text!
        self.passwordTextString = passwordTextField.text!
        
        self.dismissKeyboard()
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        self.buttonLogin.isHidden = true
        self.buttonCreate.isHidden = true
        self.usernameTextField.isHidden = true
        self.passwordTextField.isHidden = true
        
        let updated = dateTime.currentDateString()
        
        let requestPayload = ["name":usernameTextString!,"password":passwordTextString!,"device":deviceId!,"updated":updated]
        LoginTask().execute(requestPayload: requestPayload) { (result, error) in
            if let result = result {
                StoryboardSelector().home(player: result)
            }
        }
    }
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.isHidden = true
        
        self.deviceId = UIDevice.current.identifierForVendor?.uuidString
        self.easterEggCounter = 0
        
        easterEggLabel.isHidden = true
        
        usernameTextField.delegate = self
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "username",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordTextField.delegate = self
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "password",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        easterEggImageView.alpha = 0.75
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
       
    }
    
   
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateViewMoving(up: true, moveValue: self.contentView.frame.size.height + 16)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(up: false, moveValue: self.contentView.frame.size.height + 16)
    }
    
    func animateViewMoving(up: Bool, moveValue: CGFloat){
        let movementDuration: TimeInterval = 0.2
        let movement: CGFloat = (up ? -moveValue : moveValue)
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    //MARK: Actions
    
    
    func okHandler(action: UIAlertAction) {
        StoryboardSelector().start()
    }
    
    @IBAction func createButtonClick(_ sender: UIButton) {
        usernameTextString = usernameTextField.text!
        passwordTextString = passwordTextField.text!
        
        self.dismissKeyboard()
        
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        self.buttonLogin.isHidden = true
        self.buttonCreate.isHidden = true
        self.usernameTextField.isHidden = true
        self.passwordTextField.isHidden = true
        
        let updated = dateTime.currentDateString()
        let api = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let requestPayload = [
            "name": usernameTextString!,
            "password": passwordTextString!,
            "device": deviceId!,
            "updated": updated,
            "created": updated,
            "api": api
        ]
        PlayerCreate().execute(requestPayload: requestPayload) { (result, error) in
            if let result = result {
             
                StoryboardSelector().home(player: result)
            }
        }
    }
    
    func testBoardState() -> [[String]] {
        
        var row_0 = [String](repeating: "", count: 8)
        var row_1 = [String](repeating: "", count: 8)
        var row_2 = [String](repeating: "", count: 8)
        var row_3 = [String](repeating: "", count: 8)
        var row_4 = [String](repeating: "", count: 8)
        var row_5 = [String](repeating: "", count: 8)
        var row_6 = [String](repeating: "", count: 8)
        var row_7 = [String](repeating: "", count: 8)
        
        row_0[0] = "WhiteRook_x"
        row_0[1] = "WhiteKnight"
        row_0[2] = "WhiteBishop"
        row_1[5] = "WhiteGrasshopper"
        row_0[4] = "WhiteKing_x"
        //row_0[5] = "WhiteBishop"
        row_0[6] = "WhiteKnight"
        row_0[7] = "WhiteRook_x"

        row_1[0] = "WhitePawn_x"
        row_1[1] = "WhitePawn_x"
        row_1[2] = "WhitePawn_x"
        row_1[3] = "WhitePawn_x"
        //row_1[4] = "WhitePawn_x"
        //row_1[5] = "WhitePawn_x"//
        row_1[6] = "WhitePawn_x"
        row_1[7] = "WhitePawn_x"
        
        row_1[5] = "WhiteGrasshopper"
        row_2[4] = "BlackPawn_x"
        row_4[4] = "BlackPawn_x"
        //row_6[4] = "BlackKing_x"
        
        row_3[1] = "WhiteQueen"
        //row_3[2] = "WhiteBishop"
//
//
//        row_1[2] = "BlackGrasshopper"
//        row_2[1] = "WhitePawn_x"
//        row_4[1] = "WhitePawn_x"
//        row_6[1] = "WhiteKing_x"
        
        row_6[0] = "BlackPawn_x"
        row_6[1] = "BlackPawn_x"
        row_6[2] = "BlackPawn_x"
        row_6[3] = "BlackPawn_x"
        //row_6[4] = "BlackPawn_x"
        //row_6[5] = "BlackPawn_x"//
        row_6[6] = "BlackPawn_x"
        row_6[7] = "BlackPawn_x"

        row_7[0] = "BlackRook_x"
        row_7[1] = "BlackKnight"
        row_7[2] = "BlackBishop"
        //row_7[3] = "BlackQueen"
        row_7[4] = "BlackKing_x"
        //row_7[5] = "BlackBishop"
        row_7[6] = "BlackKnight"
        row_7[7] = "BlackRook_x"
        
        return [row_7, row_6, row_5, row_4, row_3, row_2, row_1, row_0]
    }
    
}

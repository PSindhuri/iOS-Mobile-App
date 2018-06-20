//
//  signUpViewController.swift
//  Moma_Final_Project
//
//  Created by Sindhuri Punyamurthula on 11/19/16.
//  Copyright © 2016 Sindhuri. All rights reserved.
//

/************************************************************
                SIGN UP VIEW CONTROLLER
            Desc: This view controller consists of
            all the details regarding signing up a new user.
            It directly takes user to dashboard once signed up.
            It is designed to be easy for user.
 *************************************************************/

import UIKit

class signUpViewController: UIViewController
{

    @IBOutlet weak var passwdSec2Req: UILabel!
    @IBOutlet weak var passwdSec1Req: UILabel!
    @IBOutlet weak var passwordReq: UILabel!
    @IBOutlet weak var usernameReq: UILabel!
    var loginSuccess = false
    //SignUp done button
    @IBAction func su_doneButton(_ sender: AnyObject)
    {
        if su_userName.text == ""
        {
            usernameReq.isHidden=false
        }
        if su_Password.text == ""{
            passwordReq.isHidden=false
        }
        if su_superHero.text == ""{
            passwdSec1Req.isHidden=false
        }
        if su_roleModel.text == ""{
            passwdSec2Req.isHidden=false
        }
        if (su_userName.text=="" || su_Password.text=="" || su_superHero.text=="" || su_roleModel.text=="")
        {
            loginSuccess = false
            print("signUpdebug(SUVC): Missing one of required fields")
        }
        else {
            loginSuccess=true
            insertLoginDetails()
            if loginSuccess{
                performSegue(withIdentifier: "signUpDone", sender: nil)
            }
        }
    }
    @IBOutlet weak var su_roleModel: UITextField!
    @IBOutlet weak var su_superHero: UITextField!
    @IBOutlet weak var su_Password: UITextField!
    @IBAction func cancelSignUp(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var su_userName: UITextField!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        usernameReq.isHidden=true
        passwordReq.isHidden=true
        passwdSec1Req.isHidden=true
        passwdSec2Req.isHidden=true
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        let myTap=UITapGestureRecognizer(target:self, action:#selector(ViewController.closeKeyboard))
        view.addGestureRecognizer(myTap) //Recognizes the tap

        // Do any additional setup after loading the view.
    }
    
    func closeKeyboard()
    {
        view.endEditing(true)
    }
    func keyboardShow(notification: NSNotification)
    {
        print("signUpdebug(SUVC): showing keyboard")
        UIView.animate(withDuration: 0.2, animations: {
            self.view.frame.origin.y = (0-60)
        })
    }
    
    func keyboardHide(notification: NSNotification)
    {
        print("signUpdebug(SUVC): hiding keyboard")
        UIView.animate(withDuration: 0.2, animations: {
            self.view.frame.origin.y=0
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            if ident == "signUpDone" {
                if loginSuccess != true {
                    return false
                }
            }
        }
        return true
    }
    //create a new row in the Login datbase
    func insertLoginDetails()
    {
        let user=su_userName.text
        let password=su_Password.text
        let superhero=su_superHero.text
        let rolemodel=su_roleModel.text
        let loginObj=loginClass(username: user!, password: password!, superhero: superhero!, rolemodel: rolemodel!)
        print("signUpdebug(SUVC): calling insert login")
        let dbInsertLogin = LoginDatabaseAccess()
        let b=dbInsertLogin.addLogin(dbLoginRecord:loginObj)
        
        if b == -1
        {
            print("signUpdebug(SUVC): not inserted login")
        }
        else{
            print("signUpdebug(SUVC): inserted login")
        }
    
    }//end of insertLoginDetails

}// end of class

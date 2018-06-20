//
//  ViewController.swift
//  Moma_Final_Project
//
//  Created by Sindhuri Punyamurthula on 11/19/16.
//  Copyright © 2016 Sindhuri. All rights reserved.
//


/************************************************************
           LOGIN PAGE/VIEW CONTROLLER 
           Desc: This view controller consists of
                 all the login page buttons, labels and functionality
 
 
*************************************************************/
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    var first:Int=0
    var logSuc = false
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var userNameText: UITextField!
    var logCount = 5 //Some random value. Could be anything. Chose 5
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.black
        super.viewDidLoad()
        errorLabel.isHidden=true
        if logCount == 5{
            checkFirstTime()
        }
        else if logCount == 0{
            self.navigationController?.isNavigationBarHidden = true;
            self.navigationController?.isToolbarHidden = true;
            print("logindebug(VC): logging out and remaining silent!")
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        let myTap=UITapGestureRecognizer(target:self, action:#selector(ViewController.closeKeyboard))
        view.addGestureRecognizer(myTap) //Recognizes the tap

        
        
    }//viewdidload
    
    @IBAction func loginGoButton(_ sender: Any) {
        let verifyTable = LoginDatabaseAccess()
        let ret = verifyTable.getAllUsers()
        if(ret == nil)
        {
            print("logindebug(VC): In loginGoButton trying to verify but found nil")
            errorLabel.isHidden=false
            Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.disable), userInfo: nil, repeats: true);
        }
        else
        {
            if(ret?[0]?.username == userNameText.text && ret?[0]?.password == passwordText.text){
                logSuc = true
                performSegue(withIdentifier: "loginToDashboard", sender: nil)
            }
            else{
                logSuc = false
                errorLabel.isHidden=false
                print("logindebug(VC): Error in login info seen! Staying put")
            }
        }
    }
    
    func disable() {
        errorLabel.isHidden=true
    }
    
    func closeKeyboard()
    {
        view.endEditing(true)
    }
    func keyboardShow(notification: NSNotification)
    {
        print("logindebug(VC): showing the keyboard")
            UIView.animate(withDuration: 0.2, animations: {
                self.view.frame.origin.y = (0-200)
            })
    }
    
    func keyboardHide(notification: NSNotification)
    {
        print("logindebug(VC): hiding the keyboard")
        UIView.animate(withDuration: 0.2, animations: {
                self.view.frame.origin.y=0
            })
            
        
    }

    override func viewDidAppear(_ animated: Bool) {
            }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            if ident == "loginToDashboard" {
                if logSuc != true {
                    return false
                }
            }
        }
        return true
    }
    
    func checkFirstTime()
    {
        print("logindebug(VC): Checking first")
        let LoginCheck=LoginDatabaseAccess()
       let ret=LoginCheck.getAllUsers()
        if ret==nil
        {
            print("logindebug(VC): nil, hence doing nothing")
        }
        else
        {
            print("logindebug(VC): not nil. Calling transition()")
            transition()
        }
    
    
    }
    func transition()
    {
        print("logindebug(VC): transitioning")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "dashboardTableViewController") as! dashboardTableViewController
        self.present(vc, animated: true, completion: nil)
        
    }

   override func prepare(for segue: UIStoryboardSegue, sender: Any?)
   {
        if (segue.identifier == "loginToDashboard")
        {
            print("logindebug(VC): seg")
        }
    }

}//end of viewcontroller


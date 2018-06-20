//
//  editTableViewController.swift
//  Moma_Final_Project
//
//  Created by Phani Potharaju on 11/23/16.
//  Copyright © 2016 Sindhuri. All rights reserved.
//

/************************************************************
              EDIT TABLEVIEW CONTROLLER
              Desc: This view controller consists of
                    all the expenses and their related information such as 
                    Title, amount, montly due,reminder settings, card used 
                    and website used for RushPay!* functionality.
                    * RushPay! is a feature that user can use to rush and pay if its urgent.
 *************************************************************/

import UIKit

class editTableViewController: UIViewController, UIPickerViewDelegate{
    @IBOutlet weak var timePicker: UIPickerView!
    @IBOutlet weak var rushPayLabel: UILabel!
    var locy:Int=0
    var editMode:Int=0
    var insertMode:Int=0
    var duePickerData:Array<String> = []
    var uniqueKeyData=[Int:String]()
    var remSet = ""
    var uniqueKey = 0
    var timepickerData=[["01","02","03","04","05","06","07","08","09","10","11","12"],["00","05","10","15","20","25","30","35","40","45","50","55"],["AM","PM"]] //UIPickerview has been made normal picker as I was seeing issues with datePicker in Xcode 8.1
    var i = 0
    var noRemCount = 0
    var yesRemCount = 0
    @IBOutlet weak var titleEdit: UITextField!
    @IBOutlet weak var edit_Amount: UITextField!
    @IBOutlet weak var editTitle: UITextField!
    @IBOutlet weak var duePicker: UIPickerView!
    
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cardUsed: UITextField!
    @IBOutlet weak var webSiteUsed: UITextField!
    
    @IBOutlet weak var yesRemButton: UIButton!
    @IBOutlet weak var noRemButton: UIButton!
    
    @IBAction func yesRemAction(_ sender: Any) {
        if(noRemCount >= 0){
            yesRemButton.isSelected = true
            noRemButton.isSelected = false
            remSet = ""
            timePicker.isUserInteractionEnabled=false
            print("editTabledebug(ETVC): No pressed repeatedly. No action. Picker state: Enabled")
        }
        noRemCount = noRemCount + 1
    }
    //setting reminder here
    
    @IBAction func noRemAction(_ sender: Any) {
        if(yesRemCount >= 0){
            noRemButton.isSelected = true
            yesRemButton.isSelected = false
            remSet = "Set"
            timePicker.isUserInteractionEnabled=true
            print("editTabledebug(ETVC): Yes pressed repeatedly. No action. Picker state: Enabled")
        }
        yesRemCount = yesRemCount + 1
    }
   
    var totalTime:String = ""
    var minString="00"
    var hoursString="01"

    //when savebutton is pressed
    @IBAction func saveButtonPressed(_ sender: AnyObject)
    {
        print("editTabledebug(ETVC): Saving all values for a particular expense")
        
        saveDet()
    }// save close
    
    /***********************functionality of Save Button() ***********************/
    
    func saveDet()
    {
        
        print("editTabledebug(ETVC): saving details")
        print("editTabledebug(ETVC): editval:\(editMode)")
        print("editTabledebug(ETVC): insertMode:\(insertMode)")
        let enteredAmount = edit_Amount.text
        let enteredDue = duePicker.selectedRow(inComponent: 0)
        let enteredTimeHours = timePicker.selectedRow(inComponent: 0)
        let enteredTimeMins = timePicker.selectedRow(inComponent: 1)
        var enteredTimeSlot = ""
        var mins = ""
        var hours = 0
        if(timePicker.selectedRow(inComponent: 2) == 0)
        {
            enteredTimeSlot = "AM"
        }
        else if(timePicker.selectedRow(inComponent: 2) == 1)
        {
            enteredTimeSlot = "PM"
        }
        let enteredCardUsed = cardUsed.text
        let enteredWebSite = webSiteUsed.text
        switch(enteredTimeMins)
        {
        case 0:
            mins = "00"
        case 1:
            mins = "05"
        case 2:
            mins = "10"
        case 3:
            mins = "15"
        case 4:
            mins = "20"
        case 5:
            mins = "25"
        case 6:
            mins = "30"
        case 7:
            mins = "35"
        case 8:
            mins = "40"
        case 9:
            mins = "45"
        case 10:
            mins = "50"
        case 11:
            mins = "55"
        default:
            print("editTabledebug(ETVC): No Value Selected");
        }
        //hours=enteredTimeHours+1
        hours=enteredTimeHours+1
        if(enteredTimeSlot == "PM"&&hours<12)
        {
            hours = hours + 12
        }
        if(enteredTimeSlot=="AM"&&hours==12)
        {
            hours=00
        }
        let todayDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: todayDate)
        
        let year =  String(describing: components.year!)+"-"
        let month = String(describing: components.month!)+"-"
        let day = String(describing: enteredDue+1)
        let currentDate = year+month+day+" "
        print("editTabledebug(ETVC): entered date is:\(currentDate)")
        totalTime = String(currentDate) + String(hours) + ":" + String(mins)
        uniqueKeyData[uniqueKey]=titleEdit.text
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = dateFormatter.date(from: totalTime)
        print("editTabledebug(ETVC): enteredDue is:\(enteredDue+1)")
        print("editTabledebug(ETVC): cardused is:\(enteredCardUsed!)")
        print("editTabledebug(ETVC): websiteused is:\(enteredWebSite!)")
        print("editTabledebug(ETVC): enteredAmount is:\(enteredAmount!)")
        let selectedDate = date
        print("editTabledebug(ETVC): selectedDate is:\(selectedDate!)")
        let delegate = UIApplication.shared.delegate as? AppDelegate
        for key in uniqueKeyData.keys
        {
            //reminder is set only if remSet is "Set".
            if(remSet == "Set")
            {
                delegate?.scheduleNotification2(at: selectedDate!, title: titleEdit.text!,identifier: uniqueKeyData[key]!)
                NotificationCenter.default.post(name: .reload, object: nil)
            }
            else{
                print("editTabledebug(ETVC): User pressed No. Not setting reminder!")
            }
        }

        let newtime:String=String(hours)+":"+String(mins)
        let newDue = duePicker.selectedRow(inComponent: 0)
        var dueDate=""
        if newDue==1
        {
            dueDate="2nd"
            
        }
        else if newDue==2
        {
            dueDate="3rd"
        }
        else if newDue==3
        {
            dueDate="4th"
        }
        else if newDue==0
        {
            dueDate="1st"
        }
        else
        {
            dueDate=String(String(newDue+1)+"th")
        }

        let newr=tablerow
        
        if yesRemButton.isSelected==true{
            newr.p_YesNo="Yes"
        }
        else  if noRemButton.isSelected==true{
            newr.p_YesNo="No"
        }

        newr.p_type=titleEdit.text!
        newr.p_amount=Double(enteredAmount!)!
        newr.p_card=enteredCardUsed!
        newr.p_website=enteredWebSite!
        newr.p_dueDate=String(describing: dueDate)
        newr.p_time=newtime
        let dbAccessSave = DatabaseAccess()
        let a=dbAccessSave.updatePayment(name: tablerow.p_type, newPay: newr)
        if a==true
        {
            print("editTabledebug(ETVC): successful update to datebase")
        }
        
        uniqueKey = uniqueKey + 1
        print("editTabledebug(ETVC): uniqueKey is \(uniqueKey)")

    }// end of saveDet
    
    var selectedRow = dashboard_payment()
    var tablerow = dashboard_payment()
    
    override func viewDidLoad()
    {
       /*********/
        super.viewDidLoad()
        self.navigationController?.isToolbarHidden = true
        self.navigationItem.title="Edit"
        self.duePicker.isUserInteractionEnabled = true
        rushPayLabel.isHidden = true

        let notificationName = Notification.Name("editNotification")
       
        NotificationCenter.default.addObserver(self, selector: #selector(editTableViewController.saveDet), name: notificationName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(editTableViewController.keyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editTableViewController.keyboardHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        for i in 1..<32
        {
            duePickerData.append(String(i))
        }
        
        self.duePicker.delegate=self
        self.timePicker.delegate=self
        print("editTabledebug(ETVC): details mode print")
        
        titleEdit.text=tablerow.p_type
        let edit_amount = tablerow.p_amount
        let date=tablerow.p_dueDate
        let time=tablerow.p_time
        let yesNo=tablerow.p_YesNo
        if yesNo=="No"
        {
            yesRemButton.isSelected=false
            noRemButton.isSelected=true
            remSet = "Set"
            timePicker.isUserInteractionEnabled=true
        }
        else if yesNo=="Yes"
        {
            yesRemButton.isSelected=true
            noRemButton.isSelected=false
            remSet=""
            timePicker.isUserInteractionEnabled=false
        }
        print("editTabledebug(ETVC): HEYY")
        print("editTabledebug(ETVC): Date and time for this is:\(date) and \(time) ***************")
        
        let strRounded=String(format:"%.2f",edit_amount)
        edit_Amount.text=strRounded
        let card_used = tablerow.p_card
        cardUsed.text=card_used
        let website_used = tablerow.p_website
        webSiteUsed.text=website_used
        fetchPickerData(payObj: tablerow)
        let myTap=UITapGestureRecognizer(target:self, action:#selector(editTableViewController.closeKeyboard))
        view.addGestureRecognizer(myTap) //Recognizes the tap
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardShow(notification: NSNotification)
    {
        
        if titleEdit.isEditing==true||edit_Amount.isEditing==true
        {
           print("editTabledebug(ETVC): keyboardShow function entered")
            UIView.animate(withDuration: 0.2, animations: {
                self.view.frame = self.view.frame.offsetBy(dx: 0, dy: 0)
            })
         }
        else{
            print("editTabledebug(ETVC): showing")
            UIView.animate(withDuration: 0.2, animations: {
            self.view.frame.origin.y = (0-250)
            })
        }
    }
    
    func keyboardHide(notification: NSNotification)
    {
        
    if titleEdit.isEditing==true||edit_Amount.isEditing==true
        {
            print("editTabledebug(ETVC): keyboardHide function entered")
            UIView.animate(withDuration: 0.2, animations: {
                self.view.frame = self.view.frame.offsetBy(dx: 0, dy: 0)
            })
            
        }
    else{
        print("editTabledebug(ETVC): hiding the keyboard")
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.frame.origin.y=0
        })

        }
    }
    
    //Functionality for RushPay!
    @IBAction func editPayNowPressed(_ sender: Any)
    {
        print("editTabledebug(ETVC): RushPay! function entered")
        if (webSiteUsed.text=="")
        {
            Timer.scheduledTimer(timeInterval: 7, target: self, selector: #selector(self.enable), userInfo: nil, repeats: true);
            rushPayLabel.isHidden = false
            print("editTabledebug(ETVC): Did nothing for website as its nil")
        }
        else{
            let website = "http://"+webSiteUsed.text!
            if let url = NSURL(string: website){
                UIApplication.shared.open(url as URL, options: [:], completionHandler: {
                (success) in print("editTabledebug(ETVC): Open Website success")
                })
            }
        }
    }
    
    func enable(){
        rushPayLabel.isHidden = true
    }
    
    func numberOfComponentsInPickerView(_ pickerView:UIPickerView)->Int{
        if pickerView.tag == 0
        {
            return 1
        }
        if pickerView.tag == 1
        {
            return 3
        }
        return 1
    }
    
    func pickerView(_ pickerView:UIPickerView,numberOfRowsInComponent component:Int)->Int{
        if pickerView.tag == 0{
        return duePickerData.count
        }
        if pickerView.tag == 1{
            return timepickerData[component].count
        }
        return 1
    }
    func pickerView(_ pickerView:UIPickerView,titleForRow row:Int,forComponent component:Int)->String? {

        if pickerView.tag == 0{

        return duePickerData[row]
        }
        if pickerView.tag == 1
        {
            return timepickerData[component][row]
        }
        return duePickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let mystring:NSAttributedString?=nil
        if(pickerView.tag == 0){
        return NSAttributedString(string: duePickerData[row], attributes: [NSForegroundColorAttributeName:UIColor.yellow])
        }
        else if(pickerView.tag == 1){
            return NSAttributedString(string: timepickerData[component][row], attributes: [NSForegroundColorAttributeName:UIColor.green])
        }
        return mystring
    }

   // When add is pressed in Dashboard ViewController, a row is inserted in Dashboard_Paymenttable
   func insertNew()
   {
    
    let enteredTimeHours = timePicker.selectedRow(inComponent: 0)
    let enteredTimeMins = timePicker.selectedRow(inComponent: 1)
    var enteredTimeSlot = ""
    var mins = ""
    var hours = 0
    if(timePicker.selectedRow(inComponent: 2) == 0)
    {
        enteredTimeSlot = "AM"
    }
    else if(timePicker.selectedRow(inComponent: 2) == 1)
    {
        enteredTimeSlot = "PM"
    }
    
    switch(enteredTimeMins)
    {
    case 0:
        mins = "00"
    case 1:
        mins = "05"
    case 2:
        mins = "10"
    case 3:
        mins = "15"
    case 4:
        mins = "20"
    case 5:
        mins = "25"
    case 6:
        mins = "30"
    case 7:
        mins = "35"
    case 8:
        mins = "40"
    case 9:
        mins = "45"
    case 10:
        mins = "50"
    case 11:
        mins = "55"
    default:
        print("editTabledebug(ETVC): No Value Selected");
    }
    hours=enteredTimeHours
    if(enteredTimeSlot == "PM"&&hours<12)
    {
        hours = hours + 12
    }
    if(enteredTimeSlot=="AM"&&hours==12)
    {
        hours=00
    }
    
    let newtime:String=String(hours)+":"+String(mins)
    let newAmount = edit_Amount.text
    let newType=titleEdit.text
    let newDue = duePicker.selectedRow(inComponent: 0)
    let newWebsite=webSiteUsed.text
    let newCard=cardUsed.text
    var dueDate="nil"
    if newDue==1
    {
        dueDate="2nd"
        
    }
    else if newDue==2
    {
        dueDate="3rd"
    }
    else if newDue==3
    {
        dueDate="4th"
    }
    else if newDue==0
    {
        dueDate="1st"
    }
    else
    {
        dueDate=String(String(newDue+1)+"th")
    }
    
    let newlyAddedRow=dashboard_payment(p_website:newWebsite!,p_card:newCard!,p_type:newType!,p_amount:Float(newAmount!)!,p_dueDate:String(dueDate),p_time:newtime,id:3)
    print("editTabledebug(ETVC): calling insert")
    let dbInsert = DatabaseAccess()
    let a=dbInsert.addPay(dbPayment:newlyAddedRow!)
    if a == -1
    {
        print("editTabledebug(ETVC): not inserted")
    }
    else{
        print("editTabledebug(ETVC): inserted changes into database")
    }
   }//end of insert
    
    
    //for fetching Picker data to load into ViewController
    func fetchPickerData(payObj:dashboard_payment)
    {
        
        let pickerTime=payObj.p_time
        let pickerDate=payObj.p_dueDate
        print("Picker Due date is:\(pickerDate)")
        
        var mins:Int = 0
        var hours:Int = 0
        var ampmString = 0
        //extracting hours and minutes
        let a=pickerTime
        var count=0
        for char in a.characters
        {
           if(char==":")
            {
            let range1 = a.startIndex..<(a.index(a.startIndex, offsetBy: count))
            self.hoursString=a.substring(with: range1)
            let range2 = (a.index(a.startIndex, offsetBy: count+1)..<a.endIndex)
            self.minString=a.substring(with: range2)
            }
           else
           {
            count=count+1
           }

        }
        
        print("editTabledebug(ETVC): minString is :\(self.minString)")
        print("editTabledebug(ETVC): hourString is :\(self.hoursString)")
        
        switch(self.minString)
        {
        case "00":
            mins = 0
        case "05":
            mins = 1
        case "10":
            mins = 2
        case "15":
            mins = 3
        case "20":
            mins = 4
        case "25":
            mins = 5
        case "30":
            mins = 6
        case "35":
            mins = 7
        case "40":
            mins = 8
        case "45":
            mins = 9
        case "50":
            mins = 10
        case "55":
            mins = 11
        default:
            print("editTabledebug(ETVC): switch default case: No Value Selected");
        }
         hours=Int(self.hoursString)!
        if(hours>12)
        {
            hours=hours-12
            ampmString=1
        }
        else if(hours == 00)
        {
            ampmString = 0
        }
        else if(hours == 12)
        {
            ampmString = 1
        }
        else
        {
            ampmString=0
        }

        if(hours == 00)
            {
                timePicker.selectRow(11, inComponent: 0, animated: false)
                timePicker.selectRow(mins, inComponent: 1, animated: false)
                timePicker.selectRow(ampmString, inComponent: 2, animated: false)
            }
            else{
                timePicker.selectRow(hours-1, inComponent: 0, animated: false)
                timePicker.selectRow(mins, inComponent: 1, animated: false)
                timePicker.selectRow(ampmString, inComponent: 2, animated: false)
        }
        if pickerDate == ""
        {
            print("editTabledebug(ETVC): pickerDate found nil, doing nothing")
        }
        else{
            let dueIndex = pickerDate.index(pickerDate.endIndex, offsetBy: -2)
            let newPickerDate = pickerDate.substring(to: dueIndex)
            print("newPickerDate: \(newPickerDate)")
            duePicker.selectRow(Int(newPickerDate)!-1, inComponent: 0, animated: false)
        }
        

    }//end of fetch picker data

    func closeKeyboard()
    {
        view.endEditing(true)
    }
}// End of Class

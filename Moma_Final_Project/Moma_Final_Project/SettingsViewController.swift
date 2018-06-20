//
//  SettingsViewController.swift
//  Moma_Final_Project
//
//  Created by Sindhuri Punyamurthula on 12/5/16.
//  Copyright © 2016 Sindhuri. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate {

   @IBOutlet weak var settingsRemPicker: UIPickerView!
   
    var remPickerData=[["01","02","03","04","05","06","07","08","09","10","11","12"],["00","05","10","15","20","25","30","35","40","45","50","55"],["AM","PM"]]
    
    @IBOutlet weak var mustLabel: UILabel!
    
    @IBOutlet weak var yesRemButton: UIButton!
    @IBOutlet weak var noRemButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var doneLabel: UILabel!
    var dailyRemSet=""
    var noPressCount = 0
    var yesPressCount = 0
    var totalTime:String = ""
    var minString="00"
    var hoursString="01"
    
    let appDelegate = UIApplication.shared.delegate
        as! AppDelegate
    
    @IBAction func yesRemAction(_ sender: Any)->Void {
        if(toggleRemButton())
        {
            print("settingsDebug(SVC): yesAction:toggling the saveButton")
        }
        if(yesPressCount >= 0){
            yesRemButton.isSelected = true
            noRemButton.isSelected = false
            dailyRemSet="Set"
            settingsRemPicker.isUserInteractionEnabled=true
            print("settingsDebug(SVC): Yes pressed repeatedly. No action. Picker state: Enabled")
        }
        else{
        
        if (yesRemButton.isSelected == false)
        {
            yesRemButton.isSelected = true
            settingsRemPicker.isUserInteractionEnabled=true
            
            noRemButton.isSelected = false
        }
        else if(yesRemButton.isSelected == true)
        {
            yesRemButton.isSelected = false
            settingsRemPicker.isUserInteractionEnabled=false
            dailyRemSet=""
            noRemButton.isSelected = false
        }
        }
        yesPressCount = yesPressCount + 1
    }
    @IBAction func noRemAction(_ sender: Any)->Void {
        if(toggleRemButton())
        {
            print("settingsDebug(SVC): NoAction: toggling the saveButton")
        }
        if(noPressCount >= 0){
            noRemButton.isSelected = true
            yesRemButton.isSelected = false
            dailyRemSet=""
            settingsRemPicker.isUserInteractionEnabled=false
            print("settingsDebug(SVC): No pressed repeatedly. No action. Picker state: disabled")
        }
        else{
        
        if (noRemButton.isSelected == false)
        {
            noRemButton.isSelected = true
            settingsRemPicker.isUserInteractionEnabled = false
            yesRemButton.isSelected = false
        }
        else if(noRemButton.isSelected == true)
        {
            noRemButton.isSelected = false
            settingsRemPicker.isUserInteractionEnabled = true
            yesRemButton.isSelected = false
        }
        }
        noPressCount = noPressCount + 1
    }
    @IBAction func slEditingBegan(_ sender: Any) {
        saveButton.isEnabled=true
        mustLabel.isHidden=true
        saveButton.backgroundColor=UIColor.green
    }

    
    @IBAction func settings_SaveClick(_ sender: AnyObject)
    {
        if setting_SpendingLimit.text==""
        {
            saveButton.isEnabled=true
            saveButton.backgroundColor=UIColor.green
            mustLabel.isHidden=false
        }
        else{
            mustLabel.isHidden=true
        let spending_limit=Double(setting_SpendingLimit.text!)
        let dbtot=TotalDatabaseAccess()
        let retTot=dbtot.getAllExpenses()
        let row=retTot?[0]
        let mon=row?.month
        print("settingsDebug(SVC): row is tot :\(row)")
        row?.spendingLimit=spending_limit!
        var fullTime:String = ""
        let changedHours = settingsRemPicker.selectedRow(inComponent: 0)
        let changedMins = settingsRemPicker.selectedRow(inComponent: 1)
        var changedTimeSlot = ""
        var mins = ""
        var hours = 0
        if(settingsRemPicker.selectedRow(inComponent: 2) == 0)
        {
            changedTimeSlot = "AM"
        }
        else if(settingsRemPicker.selectedRow(inComponent: 2) == 1)
        {
            changedTimeSlot = "PM"
        }
        switch(changedMins)
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
            print("No Value Selected");
        }
       
        hours=changedHours+1
        if(changedTimeSlot == "PM"){
            if(hours < 12)
            {
            hours = hours + 12
            }
            else if(hours == 12)
            {
                hours = 12
            }
        }
        if(changedTimeSlot == "AM"){
            if(hours == 12)
            {
                hours=00
            }
        }
        let cDate = String(describing: NSDate())
        print("settingsDebug(SVC): currentDate cDate:\(cDate)")
        let index1 = cDate.index(cDate.endIndex, offsetBy: -14)
        let substring1 = cDate.substring(to: index1)
        print("settingsDebug(SVC): substring is:\(substring1)")
        fullTime = substring1 + String(hours) + ":" + String(mins)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = dateFormatter.date(from: fullTime)
        let selectedDate = date
        print("settingsDebug(SVC): selectedDate sent is:\(selectedDate)")
        if(dailyRemSet == "Set"){
            let delegate = UIApplication.shared.delegate as? AppDelegate
            delegate?.scheduleNotification(at: selectedDate!)
            NotificationCenter.default.post(name: .reload, object: nil)
        }
        else
        {
           print("settingsDebug(SVC): user selected No. So not setting reminders")
        }
           saveButton.isHidden=true
            doneLabel.isHidden=false
     
        closeKeyboard()
       
            if yesRemButton.isSelected==true{
                row?.yesNo="Yes"
            }
            if noRemButton.isSelected==true{
                row?.yesNo="No"
            }
            let remTimeForTable=String(hours) + ":" + String(mins)
            row?.dailyRem=remTimeForTable
            let a=dbtot.updateTotal(month: mon!, newTotal: row!)
            if a==true
            {
                print("settingsDebug(SVC): successful update of total from settings")
            }
            
            
        }//end of else text=""
        
    }
    @IBOutlet weak var setting_SpendingLimit: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationName = Notification.Name("settingsNotification")
        //self.navigationItem.backBarButtonItem
        NotificationCenter.default.addObserver(self, selector: #selector(SettingsViewController.settings_SaveClick), name: notificationName, object: nil)
        self.settingsRemPicker.delegate=self
        saveButton.isHidden=false
        doneLabel.isHidden=true
        mustLabel.isHidden=true
        noRemButton.isSelected=false
        yesRemButton.isSelected=false
        
        let myTap=UITapGestureRecognizer(target:self, action:#selector(editTableViewController.closeKeyboard))
        view.addGestureRecognizer(myTap)
        let tRet = toggleRemButton()
        print("settingsDebug(SVC): initially toggled, ret: \(tRet)")
        
        let db=TotalDatabaseAccess()
        let ret=db.getAllExpenses()
        if ret==nil
        {
            print("settingsDebug(SVC): nil check for setting")
            setting_SpendingLimit.text=""
            let db=TotalDatabaseAccess()
            let date = NSDate()
            let calendar = NSCalendar.current
            let components = calendar.dateComponents(in: .current, from: date as Date)
            //let year1 =  components.year
            let month1 = components.month
            let day1 = components.day
            let tot=Total(month: String(describing: month1), day: String(describing: day1), totalSpent: 0.0, spendingLimit: 0.0, balanceLeft: 0.0, lastMonthBal: 0.0, dailyRem: "", id: 1)
            let a = db.addTotal(dbTotalRecord: tot)
            if a == -1
            {
                print("not inserted new settings total rows")
            }
            
        }
        else
        {
        let row2=ret!
        let row1=row2[0]
        let sl=row1.spendingLimit
        print("settingsDebug(SVC): row is tot:\(row1)")
        let strRounded=String(format:"%.2f",sl)
        setting_SpendingLimit.text=strRounded
            fetchPickerData(payObj:row1)
            let yesno = row1.yesNo
            if yesno == "No"
            {
                noRemButton.isSelected = true
                settingsRemPicker.isUserInteractionEnabled = false
                yesRemButton.isSelected = false
                dailyRemSet = ""
            }
            if yesno == "Yes"
            {
                yesRemButton.isSelected = true
                settingsRemPicker.isUserInteractionEnabled = true
                noRemButton.isSelected = false
                dailyRemSet = "Set"
            }
        }
        
    }//view did load

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(_ pickerView:UIPickerView)->Int{
        
        return 3
    }
    
    func pickerView(_ pickerView:UIPickerView,numberOfRowsInComponent component:Int)->Int{
        return remPickerData[component].count
    }
    func pickerView(_ pickerView:UIPickerView,titleForRow row:Int,forComponent component:Int)->String? {
        return remPickerData[component][row]
       
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
            return NSAttributedString(string: remPickerData[component][row], attributes: [NSForegroundColorAttributeName:UIColor.cyan])
    }

    func toggleRemButton()->Bool{
        if(noRemButton.isSelected == true && saveButton.isHidden == true)
        {
            doneLabel.isHidden=true
            saveButton.isHidden=false
            return true
        }
        if(yesRemButton.isSelected == true && saveButton.isHidden == true)
        {
            doneLabel.isHidden=true
            saveButton.isHidden=false
            return true
        }
        return false
    }
    func closeKeyboard()
    {
        view.endEditing(true)
    }
    
    
    
    
        
    func fetchPickerData(payObj:Total)
    {
        
        let pickerTime=payObj.dailyRem
     
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
        
        print("SettingTabledebug(ETVC): minString is :\(self.minString)")
        print("SettingTabledebug(ETVC): hourString is :\(self.hoursString)")
        
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
            settingsRemPicker.selectRow(11, inComponent: 0, animated: false)
            settingsRemPicker.selectRow(mins, inComponent: 1, animated: false)
            settingsRemPicker.selectRow(ampmString, inComponent: 2, animated: false)
        }
        else{
        settingsRemPicker.selectRow(hours-1, inComponent: 0, animated: false)
        settingsRemPicker.selectRow(mins, inComponent: 1, animated: false)
        settingsRemPicker.selectRow(ampmString, inComponent: 2, animated: false)
        }
        
    }//end of fetch picker data

}//end

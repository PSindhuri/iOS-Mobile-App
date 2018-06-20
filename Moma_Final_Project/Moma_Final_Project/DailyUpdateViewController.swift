//
//  DailyUpdateViewController.swift
//  Moma_Final_Project
//
//  Created by Sindhuri Punyamurthula on 12/5/16.
//  Copyright © 2016 Sindhuri. All rights reserved.
//

import UIKit

class DailyUpdateViewController: UIViewController {
    
    @IBOutlet weak var daily_title: UITextField!

    @IBOutlet weak var daily_amount: UITextField!
    
    @IBOutlet weak var dailyUpdate_SaveClick: UIButton!
    
    
    @IBOutlet weak var expenseTitle: UILabel!
    
    @IBOutlet weak var allDoneLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    var dailyData=[String:String]()

    @IBAction func daily_SaveClick(_ sender: AnyObject)
    {
        print("PHANI::: \(dailyData)")
        
        expenseTitle.text = "Title cannot be empty"
        amountLabel.text = "Amount cannot be empty"
        expenseTitle.isHidden = true
        amountLabel.isHidden = true

        if(daily_title.text==""||daily_amount.text=="")
        {
            if daily_title.text==""
            {
                expenseTitle.isHidden=false
                amountLabel.isHidden=true
            }
            if daily_amount.text==""
            {
                amountLabel.isHidden=false
                expenseTitle.isHidden=true
            }
            if(daily_title.text==""&&daily_amount.text=="")
            {
                amountLabel.isHidden=false
                expenseTitle.isHidden=false
            }
        }

        else
        {
            if let value = dailyData[daily_title.text!]
            {
                if value == daily_amount.text{
                    print("dailyDebug(DUVC): Both Daily amount and Daily title are present. Doing nothing!!")
                    expenseTitle.text = "Both values have already been entered"
                    amountLabel.text = "Both values have already been entered"
                    expenseTitle.isHidden = false
                    amountLabel.isHidden = false
                }
                
            }//end of if
            else{

                Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.enable), userInfo: nil, repeats: true);
                allDoneLabel.isHidden=false
                amountLabel.isHidden=true
                expenseTitle.isHidden=true
                dailyUpdate_SaveClick.isHidden=false
                closeKeyboard()
                dailyData[daily_title.text!] = daily_amount.text
                insertTotalRow()
                insertSummary()
            }
        }//end of else
        
        
    }//end of dailysave
    
    func enable(){
        allDoneLabel.isHidden=true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         expenseTitle.isHidden=true
        amountLabel.isHidden=true
        allDoneLabel.isHidden=true
        dailyUpdate_SaveClick.isHidden=false
        let myTap=UITapGestureRecognizer(target:self, action:#selector(editTableViewController.closeKeyboard))
        view.addGestureRecognizer(myTap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func insertTotalRow()
    {
        let amount=Double(daily_amount.text!)
        let db=TotalDatabaseAccess()
        let ret=db.getAllExpenses()
        let row=ret![0]
        let mon=row.month
        row.totalSpent=row.totalSpent+amount!
        let bal=row.spendingLimit-row.totalSpent
        row.balanceLeft=bal
        let a = db.updateTotal(month: mon, newTotal: row)
        if a==true
        {
            print("dailyDebug(DUVC): updated daily total")
        }
        else
        {
            print("dailyDebug(DUVC): not updated daily total")
            
        }
    }
    
    func insertSummary()
    {
        let calendarDict=[1:"January",
                          2:"February",
                          3:"March",
                          4:"April",
                          5:"May",
                          6:"June",
                          7:"July",
                          8:"August",
                          9:"Septempber",
                          10:"October",
                          11:"November",
                          12:"December"]
        
        let date = NSDate()
        let calendar = NSCalendar.current
        let components = calendar.dateComponents(in: .current, from: date as Date)
        _ = components.year
        let month1 = components.month
        let day1 = components.day
        print("dailyDebug(DUVC): todays day is:\(day1)")
        let dbsum=SummaryDatabaseAccess()
        let amount=Double(daily_amount.text!)
        let db=TotalDatabaseAccess()
        let ret=db.getAllExpenses()
        let row=ret![0]
        row.totalSpent=row.totalSpent+amount!
        let bal=row.spendingLimit-row.totalSpent
        row.balanceLeft=bal
        let sl=row.spendingLimit
        let month=calendarDict[month1!]
        print("dailyDebug(DUVC): dict is:\(month)")
        let day=String(describing: day1!)
        //let totalSpent=row!.totalSpent+amount!
        let totalSpent=amount!
        let bal1=row.spendingLimit-row.totalSpent-amount!
        let balanceLeft=bal1
        let title1=daily_title.text
        let title:String=String(describing: title1!)
        let titlenew=title
        let ins_Summaryrow=Summary(month: month!, day: day, totalSpent: totalSpent, spendingLimit: sl, balanceLeft: balanceLeft, title: titlenew, id: 2)
        let ins=dbsum.addSummary(dbTotalRecord: ins_Summaryrow!)
        if ins == -1
        {
            print("dailyDebug(DUVC): summary not created total no rows added")
        }
        else
        {
            print("dailyDebug(DUVC): summary rows added to tot")
            
        }
        let newlyUpdatedTable=dbsum.getAllExpenses()
        print("dailyDebug(DUVC): all expenses now *")
        for it in newlyUpdatedTable!
        {
            print("dailyDebug(DUVC): \(it.title)")
        }
    }
    
    //close keyboard
    func closeKeyboard()
    {
        view.endEditing(true)
    }
    
        
}//end



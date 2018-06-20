//
//  SummaryViewController.swift
//  Moma_Final_Project
//
//  Created by Sindhuri Punyamurthula on 12/5/16.
//  Copyright © 2016 Sindhuri. All rights reserved.
//

import UIKit

struct defaultsKeys
{
    static let lastmonth = "0.0"
}


class SummaryCustomTableViewCell: UITableViewCell {
    
        @IBOutlet weak var dayLb: UILabel!
    
    @IBOutlet weak var titleLb: UILabel!
    
    @IBOutlet weak var amountLb: UILabel!
    
    func loadCellValues(title: String, day: String, amount: String)
        {
            titleLb?.text=title
            dayLb?.text=day
            amountLb?.text=amount
    }
}

class SummaryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
   
    var ret_sumTable=[Summary()]
    var str_lastMonth:String=""
    var amountSpent:String=""
    var balance=""
    var firstRow=Total()

    @IBOutlet weak var summary_spendingLimit: UITextField!

    @IBOutlet weak var summary_balance: UITextField!
    @IBOutlet weak var summary_totalSpent: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        let myTap=UITapGestureRecognizer(target:self, action:#selector(editTableViewController.closeKeyboard))
        view.addGestureRecognizer(myTap)


        tableView.delegate=self
        tableView.dataSource=self
        let nib = UINib(nibName: "SummaryCustomTableViewCell", bundle: nil)
        
        self.tableView.register(nib, forCellReuseIdentifier: "summary_ProCell")
        let db_sum=SummaryDatabaseAccess()
         let ret_sum=db_sum.getAllExpenses()
        print("summaryDebug(SuVC): return for retriving expenses:\(ret_sum)")
        self.ret_sumTable=(ret_sum!).reversed()
        let db=TotalDatabaseAccess()
        let ret=db.getAllExpenses()
        if ret==nil
        {
            summary_spendingLimit.text=""
            summary_balance.text=""
            summary_totalSpent.text=""
         }
        else
        {
            let row2=ret![0]
            self.firstRow=row2
            let last=self.firstRow.lastMonthBal
            print("LAST MONTH BAL:\(last)")
            self.str_lastMonth=String(format:"%.2f",last)
            //summary details
            summary_spendingLimit.text=self.str_lastMonth
            self.amountSpent=String(format:"%.2f",self.firstRow.totalSpent)
            self.balance=String(format:"%.2f",self.firstRow.balanceLeft)
            summary_totalSpent.text=self.amountSpent
            summary_balance.text=self.balance

        }//end of else
        
        //setting val
        defaults.setValue(self.balance, forKey: defaultsKeys.lastmonth)
        defaults.synchronize()

    }//view did load

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("summaryDebug(SuVC): Count value is:\(ret_sumTable.count)")
        return ret_sumTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
      
        let cell:SummaryCustomTableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: "summary_ProCell") as? SummaryCustomTableViewCell!)!
        let myrow=ret_sumTable[indexPath.row]
        var day1:String=String(myrow.day)
        let amount1:String=String(myrow.totalSpent)
        let title1:String=String(myrow.title)
        let mon:String=String((myrow.month))!
        let index1 = mon.index(mon.endIndex, offsetBy: -5)
        let substring1 = mon.substring(to: index1)
        if(day1 == "1")
        {
            day1 = day1+"st"
        }
        else if(day1 == "2")
        {
            day1 = day1+"nd"
        }
        else if(day1 == "3")
        {
            day1 = day1+"rd"
        }
        else 
        {
            day1 = day1+"th"
        }
        let dayMonth = day1+" "+substring1
        print("summaryDebug(SuVC): \(dayMonth)")
        cell.textLabel?.text=dayMonth+": Paid $"+amount1+" for "+title1
        cell.textLabel?.adjustsFontSizeToFitWidth=false
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.contentView.backgroundColor = UIColor.lightGray

    }
    func closeKeyboard()
    {
        view.endEditing(true)
    }

}//end



//
//  dashboardTableViewController.swift
//  Moma_Final_Project
//
//  Created by Sindhuri Punyamurthula on 11/21/16.
//  Copyright © 2016 Sindhuri. All rights reserved.
//

//DashBoard ViewController logic
//Contains of all features like 
//Showing recurring expenses with images and check marks in the table
//User can select check mark to indicate payment done. Changes to green on success.
//User can swipe left on table view cell to see both Edit and Delete options.
//Confirmation needed for delete option and Check mark(paid) option
//Features like Settings, Summary, Daily updates, and Add Rows can be found in DashBoard VC as well.

import UIKit
import SQLite

extension Notification.Name
{
    static let reload = Notification.Name("reload")
}

class dashboardTableViewController: UITableViewController,TickButtonCellDelegate
{
    var row_param=0
    var paid=0
    var count = 0
    @IBOutlet weak var editButton: UIButton!
    var indPath: NSIndexPath!
    var indPath2: NSIndexPath!
    var paymentTable=[dashboard_payment()]
    var amountSpent=0
    var paidNum=0
    var firstTimeCount=0
    var loginCount = 1
    var sampleString = ""
    
    override func viewDidLoad()
    {

        super.viewDidLoad()
        self.navigationController?.isToolbarHidden = false
        tableView.allowsSelection = false
        checkFirstDayOfMonth()
        dbNilOrNot()
        // for adding images
        let photo1=UIImage(named: "Rent")
        let photo2=UIImage(named: "insurance")
        let photo3=UIImage(named: "creditbills")
        let photo4=UIImage(named:"groceries")
        let photo_default=UIImage(named:"default_dashboard")
        for rec in self.paymentTable
        {
            if rec.p_type=="Rent"
            {
                rec.pic=photo1
            }
            else if rec.p_type=="Insurance"
            {
                rec.pic=photo2
            }
            
            else if rec.p_type=="Credit Bills"
            {
                rec.pic=photo3
            }
            else if rec.p_type=="Groceries"
            {
                rec.pic=photo4
            }
            else
            {
                rec.pic=photo_default
            }

        }

        // Observer for reloading the table view
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData(_:)), name: .reload, object: nil)
        
        
        
    }//end of viewload
    override func viewDidAppear(_ animated:Bool=true) {
       
            print("dashBoarddebug(DBVC): calling appear")
            self.navigationController?.isToolbarHidden = false;
        

    }

    func reloadTableData(_ notification: Notification)
    {
        print("dashBoarddebug(DBVC): Table View Reload Started after notifcation")
        tableView.reloadData()
        print("dashBoarddebug(DBVC): Table View Reload ended after notifcation")
    }
    
    func callSegueFromCell() {
            let dataobject = indPath2
            let selectedRow = self.paymentTable[(dataobject?.row)!]
            self.performSegue(withIdentifier: "ShowDetail", sender:selectedRow)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return paymentTable.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "DashboardCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! dashboardPrototypeCellTableViewCell
        
    
    
        // Fetches the appropriate payment type for the data source layout.
        let payment = self.paymentTable[indexPath.row]
        
        cell.payment_type.text = payment.p_type
        let tableAmount=payment.p_amount
        let strRounded=String(format:"%.2f",tableAmount)
        cell.payment_amount.text = strRounded
        cell.editButton.isHidden = true
        cell.payment_dueDate.text = payment.p_dueDate
        cell.PayRoomImage.image=payment.pic
               // print("paid before click is:\(paid)")
        let status=payment.paidOrNot
        print("dashBoarddebug(DBVC): while uploading status is:\(status)")
        let NotPic=UIImage(named:"Non-Paid")
        let paidPic=UIImage(named:"Paid")
        if status=="NotPaid"
        {
            cell.tickButton.setBackgroundImage(NotPic, for: .normal)
            paidNum=0
        /******tick button***/
        if cell.tickButtonDelegate == nil
        {
            cell.tickButtonDelegate=self
        }
        /*******************/
        }//end of if cell
        
        
        else  if status=="Paid"
        {
           // print("dashBoarddebug(DBVC):doing to convert to not paid")
            
            cell.tickButton.setBackgroundImage(paidPic, for: .normal)
            paidNum=1
            if cell.tickButtonDelegate == nil
            {
                cell.tickButtonDelegate=self
            }
        }
        return cell
    }//end of tablerowfor
    

    func cellTapped(cell: dashboardPrototypeCellTableViewCell)
    {
        print("dashBoarddebug(DBVC): button")
        self.showAlertForRow(row: tableView.indexPath(for: cell)!.row)

    }
    //alert for check mark (paid/unpaid) feature
    func showAlertForRow(row: Int) {
        self.row_param=row
        let alert = UIAlertController(
            title: "Updating Paid..",
            message: "Are you sure you paid?",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (test) -> Void in
            print("dashBoarddebug(DBVC): added action alert")
            self.changeToPaid(row:self.row_param)
        }))

        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (test) -> Void in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(
            alert,
            animated: true,
            completion: nil)
    }
    
    func changeToPaid(row: Int)
    {
        
        print("dashBoarddebug(DBVC): function change to paid on alert yes")
        
        
        let paidItem = self.paymentTable[row]
        if paidItem.paidOrNot=="NotPaid"
        {
            print("dashBoarddebug(DBVC): because not paid")
        
            paidItem.paidOrNot="Paid"
            let Itemtype=paidItem.p_type
            let dbPaidSave = DatabaseAccess()
            let a=dbPaidSave.updatePayment(name: Itemtype, newPay: paidItem)
            if a==true
            {
                print("dashBoarddebug(DBVC): successful update of paid")
            }

            let db=TotalDatabaseAccess()
            let ret=db.getAllExpenses()
            let row=ret![0]
            let mon=row.month
            row.totalSpent=row.totalSpent+paidItem.p_amount
            let bal=row.spendingLimit-row.totalSpent
            row.balanceLeft=bal
            //row.lastMonthBal=bal
            let obj = db.updateTotal(month: mon, newTotal: row)
            if obj==true
            {
                print("dashBoarddebug(DBVC): updated daily total")
            }
            else
            {
                print("dashBoarddebug(DBVC): not updated daily total")
                
            }
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
            let month=calendarDict[month1!]
            let day1 = components.day
            
            print("dailyDebug(DUVC): todays day is:\(day1)")
            
            let dbsum=SummaryDatabaseAccess()
            let ins_Summaryrow=Summary(month: String(describing: month!), day: String(describing: day1!), totalSpent: paidItem.p_amount, spendingLimit: row.spendingLimit, balanceLeft: bal, title: Itemtype, id: 2)
            let ins=dbsum.addSummary(dbTotalRecord: ins_Summaryrow!)
            if ins == -1
            {
                print("dailyDebug(DUVC): summary not created total no rows added")
            }
            else
            {
                print("dailyDebug(DUVC): summary rows added to tot")
                
            }
        }//end of if
        self.tableView.reloadData()
 
    }//changed to paid

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        //Edit Action logic
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Edit") { (action: UITableViewRowAction , indexPath ) -> Void in
            self.indPath2 = indexPath as NSIndexPath!
            self.callSegueFromCell()
        }
        
        //Delete Action logic
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Delete") { (action: UITableViewRowAction , indexPath ) -> Void in
            
            self.indPath=indexPath as NSIndexPath!
            let alert = UIAlertController(title: "Deleting..", message: "Are you sure you want to delete?", preferredStyle: .actionSheet)
            let delAction = UIAlertAction(title: "Delete", style: .destructive, handler: self.delRow)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: self.cancelOp)
            alert.addAction(delAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        editAction.backgroundColor = UIColor.blue
        deleteAction.backgroundColor = UIColor.red
        return [deleteAction,editAction]
    }
    func delRow(alertAction: UIAlertAction!)
    {
        let db=DatabaseAccess()
        let name=self.paymentTable[indPath.row].p_type
        let result=db.deletePayment(byName: name)
        if result==true
        {
            print("dashBoarddebug(DBVC): deleted the row in db")
        }
        self.paymentTable.remove(at: indPath.row)
        tableView.deleteRows(at: [indPath as IndexPath], with: .fade)
        
    }
    func cancelOp(alertAction: UIAlertAction!)
    {
        print("dashBoarddebug(DBVC): Called cancelOp. So, nothing hapened")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        print("dashBoarddebug(DBVC): Entered prepare for segue func")
        if segue.identifier == "ShowDetail" {
            
            let editDetailViewController = segue.destination as! editTableViewController
            // Get the cell that generated this segue.
                let indexPath = indPath2
                print("dashBoarddebug(DBVC): \(indexPath?.row as Any)")
                let selectedRow = paymentTable[(indexPath?.row)!]
             editDetailViewController.editMode=1
                print ("dashBoarddebug(DBVC): selectedRow is sent")
                editDetailViewController.tablerow = selectedRow
        }
        else if segue.identifier == "AddDetail" {
            let insertDetailViewController = segue.destination as! editTableViewController
            insertDetailViewController.insertMode = 1
        }
        else if segue.identifier == "lgFromFB"{
            let logoutViewController = segue.destination as! ViewController
            loginCount = 0
            logoutViewController.logCount = loginCount
        }
    }

    //for edit table unwind
    @IBAction func back(unwindSegue:UIStoryboardSegue)
    {
        
        if let source = unwindSegue.source as? editTableViewController
        {
            if source.editMode==1
            {
            source.saveDet()
            print("dashBoarddebug(DBVC): Calling source save det")
            source.editMode=0
            }
            else if source.insertMode==1
            {
                source.insertNew()
                print("dashBoarddebug(DBVC): calling insert")
                source.insertMode=0
            }
            self.navigationController?.isToolbarHidden = false;
        }
        self.viewDidLoad()
        self.tableView.reloadData()
        print("dashBoarddebug(DBVC): loaded all table contents")
    }
//    
//    //for summary table
//    
//    
//    @IBAction func backFromSummary(unwindSegue:UIStoryboardSegue)
//    {
//        
//
//    }
//    
//    
//  
    
    // if its the first day of the month, it resets all values to zero
    // only last month balance is only shown in summary.
    func checkFirstDayOfMonth()
    {
        if self.firstTimeCount==0
        {
        print("dashBoarddebug(DBVC): checking first date")
        let date = NSDate()
        let calendar = NSCalendar.current
        let components = calendar.dateComponents(in: .current, from: date as Date)
        //let year1 =  components.year
        //let month1 = components.month
        let day1 = components.day
        if day1==1
        {
            let db=DatabaseAccess()
            let res=db.updatePaymentOnFirst()
            if res==true
            {
                print("dashBoarddebug(DBVC): updated all row to zeros")
            }
            
            let tot=TotalDatabaseAccess()
            let val=tot.getAllExpenses()
            if val == nil
            {
                print("nil returned tot")
            }
            else
            {
                print("entering else")
                let row=val?[0]
                let bal=row?.balanceLeft
                row?.lastMonthBal=bal!
               let a=tot.addTotal(dbTotalRecord: row!)
                if a == -1
                {
                    print(" updated last month failed")
                }
            }

            let resTot=tot.updateTotalOnFirst()
            if resTot==true
            {
                print("dashBoarddebug(DBVC): deleted all row to zeros")
            }
            
            let sum=SummaryDatabaseAccess()
            let resSum=sum.deleteSummaryOnFirst()
            if resSum==true
            {
                print("dashBoarddebug(DBVC): deleted all row to zeros")
            }
                self.firstTimeCount=1
         
            }
        else{
            print("dashBoarddebug(DBVC): not required")
            
            }
            
        }

    }//end of check first day of month
    
    func dbNilOrNot()
    {
        print("nil or not")
        
        let dbAccess = DatabaseAccess()
        
        //inserting in sql call func insert
        
        let ret=dbAccess.getPays()
        if ret?.isEmpty==true
        {
            print("empty")
        
         //Pre-populated recurring expenses. User can delete if unnecessary through deleteAction
         let rent=dashboard_payment(p_type:"Rent",p_amount:Float(0.0),id:1)
         let Ins=dashboard_payment(p_type:"Insurance",p_amount:Float(0.0),id:2)
         let credit=dashboard_payment(p_type:"Credit Bills",p_amount:Float(0.0),id:2)
         let groceries=dashboard_payment(p_type:"Groceries",p_amount:Float(0.0),id:1)
         let gym=dashboard_payment(p_type:"Gym",p_amount:Float(0.0),id:2)
         let a=dbAccess.addPay(dbPayment: rent!)
         let b=dbAccess.addPay(dbPayment: Ins!)
         let c=dbAccess.addPay(dbPayment: credit!)
         let d=dbAccess.addPay(dbPayment: groceries!)
         let e=dbAccess.addPay(dbPayment: gym!)
         if(a == -1)
         {
         print("inserted")
         }
         if(b == -1)
         {
         print("inserted")
         }
         if(c == -1)
         {
         print("inserted")
         }
         if(d == -1)
         {
         print("inserted")
         }
         if(e == -1)
         {
         print("inserted")
         }
            let firstTable=DatabaseAccess()
            let rows=firstTable.getPays()
            self.paymentTable=rows!
        }
        else{
        
            self.paymentTable=ret!
        }
        
        
    }//end of dbNil
  
}//end of class

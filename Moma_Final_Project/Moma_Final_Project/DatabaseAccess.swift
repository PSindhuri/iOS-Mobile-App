//
//  DatabaseAccess.swift
//  Moma_Final_Project
//
//  Created by Sindhuri Punyamurthula on 11/29/16.
//  Copyright © 2016 Sindhuri. All rights reserved.
//

// SQLite Database code for DashBoard ViewController and EditTableViewController
// Saves details of recurring expenses. (For eg: all details of Rent)
import Foundation
import SQLite



class DatabaseAccess
{
    var db:Connection?
    
    let payT=Table("payT")
    let dbType = Expression<String>("payType")
    let dbAmount = Expression<Double>("payAmount")
    let dbDueDate = Expression<String>("payDueDate")
    let dbPcard = Expression<String>("payPcard")
    let dbWebsite = Expression<String>("payWebsite")
    let dbPaidOrNot=Expression<String>("paidOrNot")
    let dbtime=Expression<String>("payTime")
    let dbYesNo=Expression<String>("YesNo")
    let id = Expression<Int>("id")
    
    
    init()
    {
        print("dbAccessDebug(DBS): entered init")
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true).first!
        do{
            print("dbAccessDebug(DBS): trying to connect")
            db=try Connection("\(path)/Datapayment_S.db")
            print(db as Any)
        }
            
        catch{
            db=nil
            print("dbAccessDebug(DBS): unable to open db")
            
        }
       createDatabase()
        
    }//end of init
    
    func createDatabase()
       {
            do {
    
                try db!.run(payT.create(ifNotExists: true)
                { t in
                    t.column(dbType, unique: true)
                    t.column(dbAmount)
                    t.column(dbDueDate)
                    t.column(dbPcard)
                    t.column(dbWebsite)
                    t.column(dbPaidOrNot)
                    t.column(dbtime)
                    t.column(dbYesNo)
                  t.column(id, primaryKey: true)
               })
        print("dbAccessDebug(DBS): done creation of sample")
        }
            catch{
                print("dbAccessDebug(DBS): Error")
        }
    }//end of create

    func addPay(dbPayment:dashboard_payment)-> Int64?
    {
        do {
            print("dbAccessDebug(DBS): inserting")
       let insert = payT.insert(or: .replace,dbType <- dbPayment.p_type,
                                      dbAmount <- Double(dbPayment.p_amount),
                                      dbDueDate <- dbPayment.p_dueDate ,
                                      dbPcard <- dbPayment.p_card,
                                      dbPaidOrNot<-dbPayment.paidOrNot,
                                      dbtime<-dbPayment.p_time,
                                      dbYesNo<-dbPayment.p_YesNo,
                                      dbWebsite <- dbPayment.p_website)
             let id = try db!.run(insert)
             print("dbAccessDebug(DBS): done insertion")
             print(insert.asSQL())
             return id
 
        }
            
        catch {
            print("dbAccessDebug(DBS): Insert failed")
            return -1
          }
       
        
    }//addPay end
            
  
    func find(byName name:String) throws -> dashboard_payment?
    {
        
        let query = payT.filter( dbType == name)
        if let result = try db!.pluck(query)
        {
            let pay = dashboard_payment(
                p_website: result[dbWebsite],
                p_card: result[dbPcard],
                p_type: result[dbType],
                p_amount: Float(result[dbAmount]),
                p_dueDate: result[dbDueDate],
                p_time:result[dbtime],
                p_YesNo:result[dbYesNo],
                id: result[id])
               // paidOrNot:result[paidOrNot])
            return pay
        }
        
        return nil
    }//end of find
    
    
    
    func deletePayment(byName name:String) -> Bool
    {
        do
        {
                let query = payT.filter(dbType == name)
                if try db!.run(query.delete())>0
                {
                    return true
                }
        }
        catch
        {
            print("dbAccessDebug(DBS): Delete failed")
        }
        return false
    }

    func updatePayment(name:String, newPay: dashboard_payment) -> Bool {
        let selectedPayRow = payT.filter( dbType == name)
        do {
            let update = selectedPayRow.update([
                dbType <- newPay.p_type,
                dbAmount <- Double(newPay.p_amount),
                dbDueDate <- newPay.p_dueDate ,
                dbPcard <- newPay.p_card,
                dbWebsite <- newPay.p_website,
                dbtime<-newPay.p_time,
                dbYesNo<-newPay.p_YesNo,
               dbPaidOrNot<-newPay.paidOrNot])
            if try db!.run(update) > 0 {
                print("dbAccessDebug(DBS): Updated Database")
                return true
            }
        } catch {
            print("dbAccessDebug(DBS): Update failed with error:\(error)")
        }
        return false
    }
    
    
    func updatePaymentOnFirst() -> Bool {
        do {
            let update = payT.update([
                dbPaidOrNot<-"NotPaid"])
            if try db!.run(update) > 0 {
                print("dbAccessDebug(DBS): updated on first")
                return true
            }
        } catch {
            print("dbAccessDebug(DBS): Update failed for first with error:\(error)")
        }
        
        return false
    }
  
    func getPays() -> [dashboard_payment]?
    {
        print("getPays")
       var payrecords:[dashboard_payment]=[]
        
        do {
            for record in  try (db?.prepare(payT))!
            {
                
                payrecords.append(dashboard_payment(
                    
                    p_website: record[dbWebsite],
                    p_card: record[dbPcard],
                    p_type: record[dbType],
                    p_amount: Float(record[dbAmount]),
                    p_dueDate: record[dbDueDate],
                    paidOrNot:record[dbPaidOrNot],
                    p_time:record[dbtime],
                    p_YesNo:record[dbYesNo],
                    id: record[id])!)
            }
            return payrecords
        } catch {
            print("dbAccessDebug(DBS): Select failed")
        }
        
        return nil
    }
    
    
    
    
    
}//end of db




















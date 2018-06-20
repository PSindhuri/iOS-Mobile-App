
//  Total.swift
//  Moma_Final_Project
//
//  Created by Sindhuri Punyamurthula on 12/3/16.
//  Copyright © 2016 Sindhuri. All rights reserved.
//


// Class and SQLite Database access code to save details in SettingsViewController
// and save monthly total balance.

import Foundation
import SQLite
//import CSQLite
import UIKit
class Total
{
    var month:String=""
    var day:String=""
    var totalSpent:Double=0
    var spendingLimit:Double=0
    var balanceLeft:Double=0
    var lastMonthBal:Double=0
    var dailyRem:String=""
    var yesNo:String="No"

    var id:Int?=nil
    init()
    {
        month=""
        day=""
        totalSpent=0
        spendingLimit=0
        balanceLeft=0
        id=nil
        lastMonthBal=0
        dailyRem=""
        yesNo="No"
    }
    init(month:String="",day:String="",totalSpent:Double=0,spendingLimit:Double=0,balanceLeft:Double=0,lastMonthBal:Double=0,dailyRem:String="",yesNo:String="No",id:Int?=nil)
   {
    self.month=month
    self.day=day
    self.totalSpent=totalSpent
    self.spendingLimit=spendingLimit
    self.balanceLeft=balanceLeft
    self.id=id
    self.lastMonthBal=lastMonthBal
    self.dailyRem=dailyRem
    self.yesNo=yesNo
    
    }
    
}//end of class Total



/*****************************DATABASE LOGIC ********************/

class TotalDatabaseAccess
{
    
    //let instance = DatabaseAccess()
    var db:Connection?
    
    let totalT=Table("totalT")
    let dbMonth = Expression<String>("Month")
    let dbDay = Expression<String>("Day")
    let dbTotalSpent = Expression<Double>("TotalSpent")
    let dbSpendingLimit = Expression<Double>("SpendingLimit")
    let dbBalanceLeft = Expression<Double>("BalanceLeft")
    let dbLastMonthBal = Expression<Double>("LastMonthBal")
    let dbDailyrem = Expression<String>("DailyReminder")
     let dbyesNo = Expression<String>("YesNo")
    let id = Expression<Int>("id")
    
    
    init()
    {
        print("totalDebug(TS): entered init total")
        //local path.
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true).first!
        do
        {
            print("totalDebug(TS): trying to connect total")
            db=try Connection("\(path)/Total_S.db")
            print(db as Any)
        }
            
        catch
        {
            db=nil
            print("totalDebug(TS): unable to open db total")
        }
        createDatabase()
        
    }//init ends here
    
    //Creates a DataBase when connection is successful
    func createDatabase()
    {
        do {
            
            try db!.run(totalT.create(ifNotExists: true)
            { t in
                t.column(dbMonth, unique: true)
                t.column(dbDay)
                t.column(dbTotalSpent)
                t.column(dbSpendingLimit)
                t.column(dbBalanceLeft)
                t.column(dbLastMonthBal)
                t.column(dbDailyrem)
                t.column(dbyesNo)
                t.column(id, primaryKey: true)
            })
            print("totalDebug(TS): done Total creation")
        }
        catch{
            print("totalDebug(TS): could not create Total ")
        }
    }//end of create

    // Adds total amount to the dataBase
    func addTotal(dbTotalRecord:Total)-> Int64?
    {
        do {
            print("totalDebug(TS): inserting total")
            let insert = totalT.insert(or: .replace,dbMonth <- dbTotalRecord.month,
                                       dbDay <- dbTotalRecord.day,
                                       dbTotalSpent <- Double(dbTotalRecord.totalSpent) ,
                                       dbSpendingLimit <- Double(dbTotalRecord.spendingLimit),
                                       dbBalanceLeft <- Double(dbTotalRecord.balanceLeft),
                                       dbLastMonthBal<-Double(dbTotalRecord.lastMonthBal),
                                       dbDailyrem<-dbTotalRecord.dailyRem,
                                        dbyesNo<-dbTotalRecord.yesNo
                                         )
            let id = try db!.run(insert)
            print("totalDebug(TS): done insertion total")
            print(insert.asSQL())
            return id
            
        }
            
        catch {
            print("totalDebug(TS): insert failed total")
            return -1
        }
        
        
    }//addTotal end

    func find(byMonth month:String) throws -> Total?
    {
        
        let query = totalT.filter( dbMonth == month)
        if let result = try db!.pluck(query)
        {
            let totDetail = Total(
                month: result[dbMonth],
                day: result[dbDay],
                totalSpent: result[dbTotalSpent],
                spendingLimit: result[dbSpendingLimit],
                balanceLeft: result[dbBalanceLeft],
                lastMonthBal:result[dbLastMonthBal],
                dailyRem:result[dbDailyrem],
                yesNo:result[dbyesNo],
                id: result[id])
            return totDetail
        }
        
        return nil
    }//end of find
    
    
    func updateTotal(month:String, newTotal: Total) -> Bool {
        let selectedTotalRow = totalT.filter( dbMonth == month)
        do {
            let update = selectedTotalRow.update([
                dbMonth <- newTotal.month,
                dbDay <- newTotal.day,
                dbTotalSpent <- newTotal.totalSpent ,
                dbSpendingLimit <- newTotal.spendingLimit,
                dbBalanceLeft <- newTotal.balanceLeft,
                dbLastMonthBal<-newTotal.lastMonthBal,
                dbDailyrem<-newTotal.dailyRem,
                dbyesNo<-newTotal.yesNo])
            if try db!.run(update) > 0 {
                print("totalDebug(TS): updated total")
                return true
            }
        } catch {
            print("totalDebug(TS): total Update failed: \(error)")
        }
        
        return false
    }// end of updateTotal
    
    
    func updateTotalOnFirst() -> Bool {
        // let selectedPayRow = payT.filter( dbType == name)
        do {
            let update = totalT.update([
                dbTotalSpent <- 0.0 ,
                dbBalanceLeft <- 0.0])
            if try db!.run(update) > 0 {
                print("totalDebug(TS): updated on first")
                return true
            }
        } catch {
            print("totalDebug(TS): update failed for first: \(error)")
        }
        
        return false
    }//end of updateTotalOnFirst entry
 
    func getAllExpenses() -> [Total]?
    {
        var payrecords:[Total]=[]
        
        do {
            for record in  try (db?.prepare(totalT))!
            {
                
                payrecords.append(Total(
                    
                    month: record[dbMonth],
                    day: record[dbDay],
                    totalSpent: record[dbTotalSpent],
                    spendingLimit: record[dbSpendingLimit],
                    balanceLeft: record[dbBalanceLeft],
                    lastMonthBal:record[dbLastMonthBal],
                    dailyRem:record[dbDailyrem],
                    yesNo:record[dbyesNo],
                    id: record[id]))
                return payrecords
            }
        } catch {
            print("totalDebug(TS): select failed for login")
        }
        
        return nil
    } //end of GetAllExpenses.
    
}//end of db



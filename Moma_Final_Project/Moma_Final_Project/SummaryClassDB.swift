
// SummaryClassDB.swift
//  Moma_Final_Project
//
//  Created by Sindhuri Punyamurthula on 12/3/16.
//  Copyright © 2016 Sindhuri. All rights reserved.
//

import Foundation
import SQLite

import UIKit
class Summary
{
    var month:String=""
    var day:String=""
    var totalSpent:Double=0
    var spendingLimit:Double=0
    var balanceLeft:Double=0
    var title:String=""
    var id:Int?=nil
   
    
    init()
    {
        self.month=""
        self.day=""
        self.totalSpent=0
        self.spendingLimit=0
        self.balanceLeft=0
        self.title=""
        self.id=nil
        
        
    }
    
    init?(month:String="",day:String="",totalSpent:Double=0,spendingLimit:Double=0,balanceLeft:Double=0,title:String="",id:Int=0)
    {
        self.title = title
        self.month=month
        self.day=day
        self.totalSpent=totalSpent
        self.spendingLimit=spendingLimit
        self.balanceLeft=balanceLeft
        self.id=id
        
    }
    
    
}//end of class Total



/*****************************DATABASE LOGIC ********************/


class SummaryDatabaseAccess
{
    
    
    var db:Connection?
    let sumT=Table("sumT")
    let dbMonth = Expression<String>("Month")
    let dbDay = Expression<String>("Day")
    let dbTotalSpent = Expression<Double>("TotalSpent")
    let dbSpendingLimit = Expression<Double>("SpendingLimit")
    let dbBalanceLeft = Expression<Double>("BalanceLeft")
    let dbTitle=Expression<String>("Title")
    let id = Expression<Int>("id")
    
    
    init()
    {
        print("entered init total")
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true).first!
        do{
            print("trying to connect total")
            db=try Connection("\(path)/Summary_S.db")
            print(db as Any)
        }
            
        catch
        {
            db=nil
            print("unable to open db total")
            
        }
        createDatabase()
        
    }//init
    
    func createDatabase()
    {
        
        do {
            
            try db!.run(sumT.create(ifNotExists: true)
            { t in
                t.column(dbMonth)
                t.column(dbDay)
                t.column(dbTotalSpent)
                t.column(dbSpendingLimit)
                t.column(dbBalanceLeft)
                t.column(dbTitle)
                t.column(id, primaryKey: true)
            })
            print("done summary creation")
        }
        catch{
            print("could not create summary ")
        }
    }//end of create
    
    
    
    
    
    func addSummary(dbTotalRecord:Summary)-> Int64?
    {
        do {
            print("inserting summary")
            let insert = sumT.insert(or: .replace,dbMonth <- dbTotalRecord.month,
                                       dbDay <- dbTotalRecord.day,
                                       dbTotalSpent <- Double(dbTotalRecord.totalSpent) ,
                                       dbSpendingLimit <- Double(dbTotalRecord.spendingLimit),
                                       dbBalanceLeft <- Double(dbTotalRecord.balanceLeft),
                                       dbTitle<-dbTotalRecord.title)
            let id = try db!.run(insert)
            print("done insertion summary")
            print(insert.asSQL())
            return id
            
        }
            
        catch {
            print("Insert failed summary")
            return -1
        }
        
        
    }//addSummary end
    
    
    
    
    func find(byMonth month:String) throws -> Summary?
    {
        
        let query = sumT.filter( dbMonth == month)
        if let result = try db!.pluck(query)
        {
            let sumDetail = Summary(
                month: result[dbMonth],
                day: result[dbDay],
                totalSpent: result[dbTotalSpent],
                spendingLimit: result[dbSpendingLimit],
                balanceLeft: result[dbBalanceLeft],
                title:result[dbTitle],
                id: result[id])
            return sumDetail
        }
        
        return nil
    }//find
    
    
    func updateSummary(month:String, newSummary: Summary) -> Bool {
        let selectedTotalRow = sumT.filter( dbMonth == month)
        do {
            let update = selectedTotalRow.update([
                dbMonth <- newSummary.month,
                dbDay <- newSummary.day,
                dbTotalSpent <- newSummary.totalSpent ,
                dbSpendingLimit <- newSummary.spendingLimit,
                dbBalanceLeft <- newSummary.balanceLeft,
                dbTitle<-newSummary.title])
            if try db!.run(update) > 0 {
                print("updated summary")
                return true
            }
        } catch {
            print("summary Update failed: \(error)")
        }
        
        return false
    }
    
    
    func deleteSummaryOnFirst() -> Bool {
        do {
            // let query = totalT.filter(dbType == name)
            if try db!.run(sumT.delete())>0
            {
                return true
            }
        }
        catch
        {
            print("Delete total on first failed")
        }
        return false
    }

    
    
    func getAllExpenses() -> [Summary]?
    {
        var payrecords:[Summary]=[]
        
        do {
            for record in  try (db?.prepare(sumT))!
            {
                
                payrecords.append(Summary(
                    
                    month: record[dbMonth],
                    day: record[dbDay],
                    totalSpent: record[dbTotalSpent],
                    spendingLimit: record[dbSpendingLimit],
                    balanceLeft: record[dbBalanceLeft],
                    title:record[dbTitle],
                    id: record[id])!)
            }
            return payrecords
        } catch {
            print("Select failed for summary")
        }
        
        return nil
    }
    

    
}//end of db



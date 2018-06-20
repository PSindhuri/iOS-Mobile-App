//
//  Login.swift
//  Moma_Final_Project
//
//  Created by Sindhuri Punyamurthula on 12/3/16.
//  Copyright © 2016 Sindhuri. All rights reserved.
//


// Class and SQLite Database code for saving Login details in ViewController and SignUpViewController.

import Foundation
import SQLite
//import CSQLite
import UIKit
class loginClass
{
    var username:String=""
    var password:String=""
    var superhero:String=""
    var rolemodel:String=""
    var firstTime:Int=0
    var id:Int?=nil
    init(username:String="",password:String="",superhero:String="",rolemodel:String="",firstTime:Int=1,id:Int=0)
    {
        self.username=username
        self.password=password
        self.superhero=superhero
        self.rolemodel=rolemodel
        self.firstTime=firstTime
        self.id=id
        
    }
    
    
}//end of class login



/*****************************DATABASE LOGIC ********************/


class LoginDatabaseAccess
{
    
    //let instance = DatabaseAccess()
    var db:Connection?
    
    let loginT=Table("loginT")
    let dbUsername = Expression<String>("Username")
    let dbPassword = Expression<String>("Password")
    let dbsuperHero = Expression<String>("SuperHero")
    let dbroleModel = Expression<String>("RoleModel")
    let dbfirstTime = Expression<Int>("FirstTime")
    let id = Expression<Int>("id")
    
    
    init()
    {
        print("loginDebug(LS): entered init")
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true).first!
        do{
            print("loginDebug(LS): trying to connect")
            db=try Connection("\(path)/Login_S.db")
           
            print("loginDebug(LS): \(db as Any)")
        }
            
        catch{
            db=nil
            print("loginDebug(LS): unable to open db")
            
        }
        createDatabase()
        
    }//init
    
    func createDatabase()
    {
        do {
            
            try db!.run(loginT.create(ifNotExists: true)
            { t in
                t.column(dbUsername, unique: true)
                t.column(dbPassword)
                t.column(dbsuperHero)
                t.column(dbroleModel)
                t.column(dbfirstTime)
                t.column(id, primaryKey: true)
            })
            print("loginDebug(LS): done login creation")
        }
        catch{
            print("loginDebug(LS): could not create login ")
        }
    }//end of create

    func addLogin(dbLoginRecord:loginClass)-> Int64?
    {
        do {
            print("loginDebug(LS): inserting login in addLogin")
            let insert = loginT.insert(or: .replace,dbUsername <- dbLoginRecord.username,
                                     dbPassword <- dbLoginRecord.password,
                                     dbsuperHero <- dbLoginRecord.superhero ,
                                     dbroleModel <- dbLoginRecord.rolemodel,
                                     dbfirstTime <- Int(dbLoginRecord.firstTime))
            let id = try db!.run(insert)
            print("loginDebug(LS): done insertion login using addLogin")
            print(insert.asSQL())
            return id
            
        }
            
        catch {
            print("loginDebug(LS): Insert failed")
            return -1
        }
        
        
    }//addLogin end

    func find(byName name:String) throws -> loginClass?
    {
        
        let query = loginT.filter( dbUsername == name)
        if let result = try db!.pluck(query)
        {
            let logDetail = loginClass(
                username: result[dbUsername],
                password: result[dbPassword],
                superhero: result[dbsuperHero],
                rolemodel: result[dbroleModel],
                firstTime: Int(result[dbfirstTime]),
                id: result[id])
            return logDetail
        }
        
        return nil
    }// end of find
    
    
    func updateLogin(name:String, newLogin: loginClass) -> Bool {
        let selectedLoginRow = loginT.filter( dbUsername == name)
        do {
            let update = selectedLoginRow.update([
                dbUsername <- newLogin.username,
                dbPassword <- newLogin.password,
                dbsuperHero <- newLogin.superhero ,
                dbroleModel <- newLogin.rolemodel,
                dbfirstTime <- newLogin.firstTime])
            if try db!.run(update) > 0 {
                print("loginDebug(LS): updated login")
                return true
            }
        } catch {
            print("loginDebug(LS): Login Update failed with error: \(error)")
        }
        
        return false
    }//end of updateLogin
 
    func getAllUsers() -> [loginClass?]?
    {
        var payrecords:[loginClass]=[]
        
        do {
            for record in  try (db?.prepare(loginT))!
            {
                
                payrecords.append(loginClass(
                    
                    username: record[dbUsername],
                    password: record[dbPassword],
                    superhero: record[dbsuperHero],
                    rolemodel: record[dbroleModel],
                    firstTime: Int(record[dbfirstTime]),
                    id: record[id]))
                return payrecords
            }
        } catch {
            print("loginDebug(LS): Select failed for login")
        }
        
        return nil
    }//end of getAllUsers
    
    
}//end of db



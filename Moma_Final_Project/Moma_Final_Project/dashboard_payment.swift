//
//  dashboard_payment.swift
//  Moma_Final_Project
//
//
//  Copyright © 2016 Sindhuri. All rights reserved.
//

import UIKit

//Class for saving recurring details and it is used in EditTableViewController and DashBoardViewController
class dashboard_payment
{
    
    var p_type:String=""
    var p_amount:Double=0.0
    var p_dueDate:String=""
    
    var p_card:String=""
    var p_website:String=""
    var pic:UIImage?
    var paidOrNot:String="NotPaid"
    var p_time:String=""
    var p_YesNo:String="No"
    var id:Int? = nil
   
    init?(p_website:String="",p_card:String="",p_type:String="",p_amount:Float=0.0,p_dueDate:String="",pic:UIImage?=nil)
    {
        self.p_type=p_type
        self.p_amount=Double(p_amount)
        self.p_dueDate=p_dueDate
        self.pic=pic
        self.p_card=p_card
        self.p_website=p_website
       
    }
    
    init?(p_website:String="",p_card:String="",p_type:String="",p_amount:Float=0.0,p_dueDate:String="",paidOrNot:String="NotPaid",p_time:String="",p_YesNo:String="No",id:Int=0)
     {
        self.p_type=p_type
        self.p_amount=Double(p_amount)
        self.p_dueDate=p_dueDate
        self.id=id
        self.p_card=p_card
        self.p_website=p_website
        self.paidOrNot=paidOrNot
        self.p_time=p_time
        self.p_YesNo=p_YesNo
        
    }

    init()
    {
        self.p_type=""
        self.p_amount=0.0
        self.p_dueDate=""
        
        self.p_card=""
        self.p_website=""
        self.pic=nil
        self.paidOrNot="NotPaid"
        self.p_time=""
        self.id = nil
        self.p_YesNo="No"
        
        
    }
   
}

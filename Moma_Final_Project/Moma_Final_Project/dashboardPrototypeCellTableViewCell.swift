//
//  dashboardPrototypeCellTableViewCell.swift
//  Moma_Final_Project
//
//  Created by Sindhuri Punyamurthula on 11/21/16.
//  Copyright © 2016 Sindhuri. All rights reserved.
//

import UIKit

// DashBoard View çell for DashBoard ViewController Table
class dashboardPrototypeCellTableViewCell: UITableViewCell {
    @IBOutlet weak var tickButton: UIButton!
    @IBOutlet weak var PayRoomImage: UIImageView!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var payment_type: UILabel!

    @IBOutlet weak var payment_dueDate: UILabel!

    @IBOutlet weak var payment_amount: UILabel!
    
            var tickButtonDelegate: TickButtonCellDelegate?
           // var notPaidTickButtonDelegate: NotPaidTickButtonCellDelegate?
        
    @IBAction func buttonTap(_ sender: AnyObject)
    {
    
    
     if let delegate = tickButtonDelegate
     {
        delegate.cellTapped(cell: self)
     }
        
        /*if let delegate = notPaidTickButtonDelegate
        {
            delegate.greenTickCellTapped(cell: self)
        }*/
        
    }
    
}

protocol TickButtonCellDelegate //to change from not paid to paid
{
    func cellTapped(cell: dashboardPrototypeCellTableViewCell)
}

/*protocol NotPaidTickButtonCellDelegate //to change from paid to not paid
{
    func greenTickCellTapped(cell: dashboardPrototypeCellTableViewCell)
}*/


//        var delegate:MyCustomCellDelegator!
//        @IBOutlet weak var myButton:UIButton?
        
        
        
//    @IBAction func buttonPressed(sender:AnyObject){
//            let mydata = "Anydata you want to send to the next controller"
//            if(self.delegate != nil){ //Just to be safe.
//                self.delegate.callSegueFromCell(myData: mydata as AnyObject)
//            }
//        }
    

/*
    weak var delegate : MWSwipeableTableViewCellDelegate?
    var animationOptions : UIViewAnimationOptions = [.allowUserInteraction, .beginFromCurrentState]
    var animationDuration : TimeInterval = 0.5
    var animationDelay : TimeInterval = 0
    var animationSpingDamping : CGFloat = 0.5
    var animationInitialVelocity : CGFloat = 1
    private weak var leftWidthConstraint : NSLayoutConstraint!
    private weak var rightWidthConstraint : NSLayoutConstraint!
    
    var buttonWidth :CGFloat = 80 {
        didSet(val) {
            if let r = self.rightWidthConstraint {
                r.constant = self.buttonWidth
            }
            if let l = self.leftWidthConstraint {
                l.constant = self.buttonWidth
            }
        }
    }
    private weak var panRecognizer : UIPanGestureRecognizer!
    private weak var buttonCancelTap : UITapGestureRecognizer!
    
    private var beginPoint : CGPoint = CGPoint.zero
    weak var rightButton : UIButton! {
        willSet(val) {
            if let r = self.rightButton {
                r.removeFromSuperview()
            }
            if let b = val {
                self.addSubview(b)
                b.addTarget(self, action: Selector(("didTapButton:")), for: .touchUpInside)
                b.translatesAutoresizingMaskIntoConstraints = false
                self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[v]-(0)-|", options: [], metrics: nil, views: ["v":b]))
                self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "[v]-(0)-|", options: [], metrics: nil, views: ["v":b]))
                let wc = NSLayoutConstraint(item: b, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.buttonWidth)
                b.addConstraint(wc)
                self.rightWidthConstraint = wc
                self.sendSubview(toBack: b)
            }
        }
    }
    weak var leftButton : UIButton! {
        willSet(val) {
            if let l = self.leftButton {
                l.removeFromSuperview()
            }
            if let b = val {
                self.addSubview(b)
                b.addTarget(self, action: Selector(("didTapButton:")), for: .touchUpInside)
                b.translatesAutoresizingMaskIntoConstraints = false
                self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[v]-(0)-|", options: [], metrics: nil, views: ["v":b]))
                self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(0)-[v]", options: [], metrics: nil, views: ["v":b]))
                let wc = NSLayoutConstraint(item: b, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.buttonWidth)
                b.addConstraint(wc)
                self.leftWidthConstraint = wc
                self.sendSubview(toBack: b)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    private func commonInit() {
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(dashboardPrototypeCellTableViewCell.didPan(sender:)))
        print("P5::: \(pan)")
        pan.delegate = self
        self.addGestureRecognizer(pan)
        self.panRecognizer = pan
        
        let tap = UITapGestureRecognizer(target: self, action: Selector(("didTap:")))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        self.buttonCancelTap = tap
        
        self.contentView.backgroundColor = UIColor.clear
    }
    
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let tap = gestureRecognizer as? UITapGestureRecognizer {
            if tap == self.buttonCancelTap {
                return self.contentView.frame.origin.x != 0
            }
            else {
                return super.gestureRecognizerShouldBegin(gestureRecognizer)
            }
        }
        else if let pan = gestureRecognizer as? UIPanGestureRecognizer {
            let trans = pan.translation(in: self)
            if abs(trans.x) > abs(trans.y) {
                return true
            }
            else if self.contentView.frame.origin.x != 0 {
                return true
            }
            else {
                return false
            }
        }
        else {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
    }
    
    
    func didTap(sender : UITapGestureRecognizer) {
        UIView.animate(withDuration: self.animationDuration, delay: self.animationDelay, usingSpringWithDamping: self.animationSpingDamping, initialSpringVelocity: self.animationInitialVelocity, options: self.animationOptions, animations: { () -> Void in
            self.contentView.frame.origin.x = 0
            }, completion: nil)
    }
    
    func didPan(sender: UIPanGestureRecognizer) {
        switch sender.state
        {
        case .began:
            print("P1:::")
            self.delegate?.swipeableTableViewCellDidRecognizeSwipe(cell: self)
            
            self.beginPoint = sender.location(in: self)
            self.beginPoint.x -= self.contentView.frame.origin.x
            
        case .changed:
            let now = sender.location(in: self)
            let distX = now.x - self.beginPoint.x
            print("P2:::")
            if distX <= 0 {
                let d = max(distX,-(self.contentView.frame.size.width-self.buttonWidth))
                if d > -self.buttonWidth*2 || self.rightButton != nil || self.contentView.frame.origin.x > 0 {
                    self.contentView.frame.origin.x = d
                }
                else {
                    sender.isEnabled = false
                    sender.isEnabled = true
                }
            }
            else {
                let d = min(distX,self.contentView.frame.size.width-self.buttonWidth)
                if d < self.buttonWidth*2 || self.leftButton != nil || self.contentView.frame.origin.x < 0 {
                    self.contentView.frame.origin.x = d
                }
                else {
                    sender.isEnabled = false
                    sender.isEnabled = true
                }
            }
            
        default:
            print("P3:::")
            delegate?.swipeableTableViewCellDidRecognizeSwipe(cell: self)
            let offset = self.contentView.frame.origin.x
            
            if offset > self.buttonWidth && self.leftButton != nil {
                UIView.animate(withDuration: self.animationDuration, delay: self.animationDelay, usingSpringWithDamping: self.animationSpingDamping, initialSpringVelocity: self.animationInitialVelocity, options: self.animationOptions, animations: { () -> Void in
                    self.contentView.frame.origin.x = self.buttonWidth
                    }, completion: nil)
            }
            else if -offset > self.buttonWidth && self.rightButton != nil {
                UIView.animate(withDuration: self.animationDuration, delay: self.animationDelay, usingSpringWithDamping: self.animationSpingDamping, initialSpringVelocity: self.animationInitialVelocity, options: self.animationOptions, animations: { () -> Void in
                    self.contentView.frame.origin.x = -self.buttonWidth
                    }, completion: nil)
            }
            else {
                UIView.animate(withDuration: self.animationDuration, delay: self.animationDelay, usingSpringWithDamping: self.animationSpingDamping, initialSpringVelocity: self.animationInitialVelocity, options: self.animationOptions, animations: { () -> Void in
                    self.contentView.frame.origin.x = 0
                    }, completion: nil)
            }
        }
    }
    

    func closeButtonsIfShown(animated:Bool = true) -> Bool {
        if self.contentView.frame.origin.x != 0 {
            if animated {
                UIView.animate(withDuration: self.animationDuration, delay: self.animationDelay, usingSpringWithDamping: self.animationSpingDamping, initialSpringVelocity: self.animationInitialVelocity, options: self.animationOptions, animations: { () -> Void in
                    self.contentView.frame.origin.x = 0
                    self.panRecognizer.isEnabled = false
                    self.panRecognizer.isEnabled = true
                    }, completion: nil)
            }
            else {
                self.contentView.frame.origin.x = 0
                self.panRecognizer.isEnabled = false
                self.panRecognizer.isEnabled = true
                
            }
            return true
        }
        else {
            return false
        }
    }
    
    func didTapButton(sender:UIButton!)
    {
        if let d = delegate {
            if let l = self.leftButton {
                if sender == l {
                    d.swipeableTableViewCellDidTapLeftButton(cell: self.delegate as! dashboardPrototypeCellTableViewCell)
                }
            }
            if let r = self.rightButton {
                if sender == r {
                    d.swipeableTableViewCellDidTapRightButton(cell: self.delegate as! dashboardPrototypeCellTableViewCell)
                }
            }
        }
       self.closeButtonsIfShown(animated:true)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool)
    {
        let showing = self.contentView.frame.origin.x != 0
        if !showing {
            super.setHighlighted(highlighted, animated: animated)
            self.rightButton?.alpha = showing || !highlighted ? 1 : 0
            self.leftButton?.alpha = showing || !highlighted ? 1 : 0
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        let showing = self.contentView.frame.origin.x != 0
        if !showing {
            super.setSelected(selected, animated: animated)
            self.rightButton?.alpha = showing || !selected ? 1 : 0
            self.leftButton?.alpha = showing || !selected ? 1 : 0
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}


    /******************************************************************************************/


//    class MWSwipeableTableViewCell: UITableViewCell {
//            }


    /*********************************************************************************************/
*/



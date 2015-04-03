//
//  ViewController.swift
//  XKCD
//
//  Created by Shah on 3/18/15.
//  Copyright (c) 2015 COMP4977. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var percent: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var selectedDate: UILabel!
    @IBOutlet weak var slider: UISlider!
    var year: Int = 0
    var computedYear: Double = 0.0
    
    override func viewDidLoad() 
    { 
        super.viewDidLoad()
        
        let flags: NSCalendarUnit = .DayCalendarUnit | .MonthCalendarUnit | .YearCalendarUnit
        let date = NSDate()
        let components = NSCalendar.currentCalendar().components(flags, fromDate: date)
        
        year = components.year
        selectedDate.text = "\(year)"
        computedYear = Double(year)     
    }
    
    @IBAction func sliderMoved(sender: UISlider) 
    {
        var currentValue:Int = Int(sender.value)
        
        if currentValue > 96 { currentValue = 96 }
        
        var p: Double  = pow(Double(sender.value / 100), 3)
        var z: Double = (20.3444*p) + 3.0
        
        computedYear = (Double)(year) - ( exp(z) - exp(3) )
        if computedYear > 1.0
        {
            selectedDate.text = "Year \( Int (computedYear) ) AD"
        }
        else
        {
            selectedDate.text = "Year \( Int (computedYear) * -1) BC"
        }
        
        percent.text = "\(currentValue)%"
    }
    
    @IBAction func getEvents(sender: UIButton) 
    {
        textView.text = ""
        var cmptYear: Int = Int (computedYear)
        
        if cmptYear > 1 
        {
            var apiQry: NSString = "http://en.wikipedia.org/w/api.php?action=query&prop=extracts&format=json&titles=\(cmptYear)"         
            var endpoint = NSURL(string: apiQry)
        
            var data = NSData(contentsOfURL: endpoint!)
        
            if let json = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as? NSDictionary 
            {
                if let query = json["query"] as? NSDictionary 
                {
                    if let pages = query["pages"] as? NSDictionary
                    {
                        let html = pages.allValues[0].valueForKey("extract") as NSString
                    
                        var err : NSError?
                        var parser     = HTMLParser(html: html, error: &err)
                        if err != nil 
                        {
                            println(err)
                            exit(1)
                        }
                    
                        var bodyNode   = parser.body
                    
                        if let inputNodes = bodyNode?.findChildTags("li") 
                        {
                            for node in inputNodes 
                            {
                                textView.text = textView.text + node.contents + "\n\n"
                            }
                        }   
                    }
                
                }
            } 
            else 
            {
                textView.text = "Our whole universe was in a hot dense state,Then nearly fourteen billion years ago expansion started. Wait...The Earth began to cool,The autotrophs began to drool,Neanderthals developed tools,We built a wall (we built the pyramids),Math, science, history, unraveling the mystery,That all started with the big bang!"
            }
        }
        else
        {
            textView.text = "Our whole universe was in a hot dense state,Then nearly fourteen billion years ago expansion started. Wait...The Earth began to cool,The autotrophs began to drool,Neanderthals developed tools,We built a wall (we built the pyramids),Math, science, history, unraveling the mystery,That all started with the big bang!"
        }

    }

}


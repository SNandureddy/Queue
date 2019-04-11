//
//  DatePopOverVC.swift
//  Queue
//
//  Created by Apple on 15/03/19.
//  Copyright © 2019 Deftsoft. All rights reserved.
//

protocol TimeDelegate {
    func didSelectDate(date: String)
}

import UIKit

class DatePopOverVC: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet var dayCollection: [UIButton]!
    @IBOutlet var dateCollection: [UIButton]!
    
    //MARK: Selected Date
    var selectedDate = String()
    var dateArray = [Date]()
    var delegate: TimeDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDateArray()
    }
    
    private func getDateArray() {
        dateArray = [Date]()
        for index in 0..<7 {
            let date = Date().dateByAddingDays(inDays: index)
            dateArray.append(date)
            let dayStr = date.stringFromDate(format: .weekDay, type: .local)
            let dateStr = date.stringFromDate(format: .date, type: .local)
            dayCollection[index].setTitle(dayStr, for: .normal)
            dayCollection[index].setTitle(dayStr, for: .selected)
            dateCollection[index].setTitle(dateStr, for: .normal)
            dateCollection[index].setTitle(dateStr, for: .selected)
        }
        
        for index in 0..<dateArray.count {
            let dateStr = dateArray[index].stringFromDate(format: .daydm, type: .local)
            if dateStr == selectedDate {
                for day in dayCollection {
                    day.isSelected = false
                }
                for date in dateCollection {
                    date.isSelected = false
                }
                dayCollection[index].isSelected = true
                dateCollection[index].isSelected = true
                break
            }
        }
    }
    
    @IBAction func dateAction(_ sender: UIButton) {
        for day in dayCollection {
            day.isSelected = false
        }
        for date in dateCollection {
            date.isSelected = false
        }
        dayCollection[sender.tag-1].isSelected = true
        dateCollection[sender.tag-1].isSelected = true
        let dateStr = dateArray[sender.tag-1].stringFromDate(format: .daydm, type: .local)
        delegate.didSelectDate(date: dateStr)
    }
}

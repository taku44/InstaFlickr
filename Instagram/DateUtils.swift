//
//  DateUtils.swift
//  Instagram
//
//  Created by taku on 2016/07/31.
//  Copyright © 2016年 小林 卓司. All rights reserved.
//

import UIKit

class DateUtils {
    class func dateFromString(string: String, format: String) -> NSDate {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.dateFromString(string)!
    }
    
    class func stringFromDate(date: NSDate, format: String) -> String {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.stringFromDate(date)
    }
}

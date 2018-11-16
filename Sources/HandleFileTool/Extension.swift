//
//  Extension.swift
//  HandleFileTool
//
//  Created by moka-iOS on 2018/11/15.
//

import Foundation

extension String {
    var fullRange: NSRange {
        let nsstring = NSString(string: self)
        return NSMakeRange(0, nsstring.length)
    }
}


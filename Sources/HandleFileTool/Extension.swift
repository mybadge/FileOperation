//
//  Extension.swift
//  HandleFileTool
//
//  Created by moka-iOS on 2018/11/15.
//

import Foundation
import PathKit

extension String {
    var fullRange: NSRange {
        let nsstring = NSString(string: self)
        return NSMakeRange(0, nsstring.length)
    }
}


extension Path {
    /// 要操作的根路径
    var operationRootPath: Path? {
        if let rootPath = FilePathSearchRule().search(in: self.string).first {
            return Path(rootPath)
        }
        return nil
    }
    
}

//
//  FileSearchProcess.swift
//  CommandLine
//
//  Created by Shangpin on 2019/4/19.
//

import Foundation
import PathKit

public class FileSearchProcess: NSObject {
    let p: Process
    
    /// 查找包含某些内容的文件
    ///
    /// - Parameters:
    ///   - path: 路径下
    ///   - searchStr: 要查找的字符串
    init(path: String, searchStr: String) {
        /**
         *  /usr/bin/grep -rn ": SPViewController" /usr/username/path/
         */
        p = Process()
        p.launchPath = "/usr/bin/grep"
        var args = [String]()
        args.append("-rn")
        args.append(searchStr)
        args.append(path)
        p.arguments = args
    }
    
    func execute() -> Set<String> {
        let pipe = Pipe()
        p.standardOutput = pipe
        
        let fileHandler = pipe.fileHandleForReading
        p.launch()
        
        let data = fileHandler.readDataToEndOfFile()
        if let string = String(data: data, encoding: .utf8) {
            return Set(string.components(separatedBy: "\n").dropLast())
        } else {
            return []
        }
    }
}


public class FileModifyProcess: NSObject {
    let p: Process

    init(path: String, originalStr: String, modifyStr: String) {
        
        ///sed -i "" "s/originalStr/modifyStr/g" /usr/username/path/
        p = Process()
        p.launchPath = "/usr/bin/sed"
        var args = [String]()
        args.append("-i")
        args.append("")
        args.append("s/\(originalStr)/\(modifyStr)/g")
        args.append(path)
        p.arguments = args
    }
    
    func execute() -> Set<String> {
        let pipe = Pipe()
        p.standardOutput = pipe
        
        let fileHandler = pipe.fileHandleForReading
        p.launch()
        
        let data = fileHandler.readDataToEndOfFile()
        if let string = String(data: data, encoding: .utf8) {
            return Set(string.components(separatedBy: "\n").dropLast())
        } else {
            return []
        }
    }
}



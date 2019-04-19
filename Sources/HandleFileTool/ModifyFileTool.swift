//
//  ModifyFileTool.swift
//  CommandLineKit
//
//  Created by 赵志丹 on 2019/4/19.
//

import Foundation
import PathKit
import Rainbow

struct ModifyFileTool {
    /// 必须为项目的根目录, 需要根据根目录去修改工程文件
    let executionPath: Path
    let originalStr: String
    let replaceStr: String
    let extensions: [String]
    init(executionPath: String, originalStr: String, replaceStr: String, extensions: [String] = []) {
        self.executionPath = Path(executionPath)
        self.originalStr = originalStr
        self.replaceStr = replaceStr
        self.extensions = extensions
    }

    func searchFile(search: String) {
        let rootPath = executionPath
        //"/Users/shangp/workspace/compony/ShangpinApp/ShangPin/ShangPin/ShangPin"
        let proces = FileSearchProcess(path: rootPath.string, searchStr: search)
        let sets = proces.execute()
        //print("\(sets)".blue)
        let needHandArr = sets.compactMap { $0.components(separatedBy: ":").first }.compactMap({Path($0)})
        //print(needHandArr)

        /// 这里应该循环
        guard let fileName = needHandArr.last else {
            return
        }
        handleModifyFile(file: fileName)
    }


    func handleModifyFile(file: Path) {
        let searchStr = file.lastComponentWithoutExtension
        let proces = FileSearchProcess(path: executionPath.string, searchStr: searchStr)
        let sets = proces.execute().compactMap({ Path($0) })
        print("\(sets)".blue)

        let needReplaceStr = searchStr
        let replacedStr = needReplaceStr.replacingOccurrences(of: originalStr, with: replaceStr)
        var trupes: [ReplaceTrupe] = []
        trupes.append((needReplaceStr+".h", replacedStr+".h"))
        trupes.append((needReplaceStr+".m", replacedStr+".m"))
        trupes.append((needReplaceStr+"*", replacedStr+"*"))
        trupes.append((needReplaceStr+".", replacedStr+"."))
        trupes.append((needReplaceStr+"$", replacedStr))

        

        sets.forEach { (path) in
            let replaceProcess = FileReplaceProcess(path: path.string, replaces: trupes)
            let arr = replaceProcess.execute()
            print("arr=\(arr)")
        }

        /**
         需要处理的：
         1、#import "SPRechargeResultViewController.h"
         2、4CFDFF391D781A8300BEDFD5 /* SPRechargeResultViewController.h */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.c.h; path = SPRechargeResultViewController.h; sourceTree = "<group>"; };
         3、4CFDFF551D781A8300BEDFD5 /* SPRechargeResultViewController.m in Sources */ = {isa = PBXBuildFile; fileRef = 4CFDFF3A1D781A8300BEDFD5 /* SPRechargeResultViewController.m */; };
         4、SPRechargeResultViewController *comfirmVC = [[SPRechargeResultViewController alloc] initWithPayConfirmationModel:checkModel];
         5、@interface SPRechargeResultViewController ()
         6、@implementation SPRechargeResultViewController
         7、SPRechargeResultViewController *comfirmVC = SPRechargeResultViewController.new;
         */

        // TODO 处理完之后, 修改文件名


        // TODO 修改工程文件

    }
}

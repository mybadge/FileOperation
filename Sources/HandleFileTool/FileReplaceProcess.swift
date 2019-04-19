//
//  FileReplaceProcess.swift
//  CommandLine
//
//  Created by 赵志丹 on 2019/4/19.
//

import Foundation

typealias ReplaceTrupe = (original: String, replce: String)

/// 替换 命令
public class FileReplaceProcess: NSObject {
    let p: Process


    /**
     参考 https://wiki.jikexueyuan.com/project/shell-learning/sed-search-and-replace.html
     * 替换与查找
     在 s 命令里以 g 结尾表示的是：全局性，意即“替代文本取代正则表达式中每一个匹配的”。如果没有设置 gsed 指挥取代第一个匹配的。

     鲜为人知的是：可以在结尾指定数字，只是第 n 个匹配出现才要被取代：
     sed ‘s/Tom/Lisy/2’ < Test.txt 仅匹配第二个 Tom
     通过给 sed 增加一个-e 选项的方式能让 sed 接受多个命令。
     sed -e ‘s/foo/bar/g’ -e ‘s/chicken/cow/g’ myfile.txt 1>myfile2.txt
     用 shell 命令将 test.log 文件中第 3-5 行的第 2 个“filter”替换成“haha”
     sed -i '3,5s/filter/haha/2' test.log
     */

    init(path: String, replaces: [ReplaceTrupe]) {

        ///sed -i "" "s/originalStr/modifyStr/g" /usr/username/path/
        p = Process()
        p.launchPath = "/usr/bin/sed"
        var args = [String]()
        args.append("-i")
        args.append("")
        replaces.forEach { (trupe) in
            args.append("-e")
            args.append("s/\(trupe.original)/\(trupe.replce)/g")
        }

        args.append(path)
        p.arguments = args
    }

    init(path: String, originalStr: String, replaceStr: String) {

        ///sed -i "" "s/originalStr/modifyStr/g" /usr/username/path/
        p = Process()
        p.launchPath = "/usr/bin/sed"
        var args = [String]()
        args.append("-i")
        args.append("")
        args.append("s/\(originalStr)/\(replaceStr)/g")
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

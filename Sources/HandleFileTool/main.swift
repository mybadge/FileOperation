//
//  Main.swift
//  HandleFileTool
//
//  Created by moka-iOS on 2018/11/15.
//

import Foundation
import CommandLineKit
import Rainbow

let cli = CommandLineKit.CommandLine()

let projectOption = StringOption(
    shortFlag: "p", longFlag: "project", helpMessage: "Path to the project.")
let excludePathsOption = MultiStringOption(shortFlag: "e", longFlag: "exclude", helpMessage: "Excluded paths which should not search in.")
let resourceExtensionsOption = MultiStringOption(shortFlag: "r", longFlag: "resource-extensions", helpMessage: "Extensions to search.")
let fileExtensionsOption = MultiStringOption(shortFlag: "f", longFlag: "file-extensions", helpMessage: "File extensions to search with.")
let help = BoolOption(shortFlag: "h", longFlag: "help",
                      helpMessage: "Prints a help message.")

cli.addOptions(projectOption, resourceExtensionsOption, fileExtensionsOption, help)
cli.formatOutput = { s, type in
    var str: String
    switch(type) {
    case .error:
        str = s.red.bold
    case .optionFlag:
        str = s.green.underline
    case .optionHelp:
        str = s.lightBlue
    default:
        str = s
    }

    return cli.defaultFormat(s: str, type: type)
}

do {
    try cli.parse()
} catch {
    cli.printUsage(error)
    exit(EX_USAGE)
}

if help.value {
    cli.printUsage()
    exit(EX_OK)
}

let project = projectOption.value ?? "."
let resourceExtensions = resourceExtensionsOption.value ?? ["mp3", "jpg", "png", "m4a"]
let fileExtensions = fileExtensionsOption.value ?? ["swift", "m", "mm", "xib", "storyboard"]
let excludedPaths = excludePathsOption.value ?? []

let rootPath = "/Users/moka/WorkSpace/得到/精英日课的副本"

let tool = HandleFileTool.init(executionPath: rootPath, extensions: resourceExtensions)

//tool.moveFile()
tool.deleteEmptyDic()
//tool.nativeMoveFile()

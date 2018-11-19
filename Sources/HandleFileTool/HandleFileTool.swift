
import Foundation
import PathKit
import Rainbow

struct HandleFileTool {
    let executionPath: Path
    let extensions: [String]
    init(executionPath: String, extensions: [String]) {
        self.executionPath = Path(executionPath)
        self.extensions = extensions
    }
    
    /// 移动文件
    public func moveFile() {
        let find = ExtensionFindProcess(path: executionPath.string, extensions: self.extensions, excluded: [])
        print("path= \(executionPath.string)")
        guard let result = find?.execute(), result.count > 0 else {
            print("没有找到文件, 要操作的文件".red)
            return
        }
        for p in result {
            handleName(p)
            print((p + "\n").green)
        }
    }
    
    /// 删除空文件夹
    public func deleteEmptyDic() {
        do {
            let childPaths = try executionPath.children()
            print("childPaths=\(childPaths)".green)
            
            let allFiles = try executionPath.recursiveChildren().filter({
                $0.isDirectory && (try! $0.children().count == 0)
            })
            for path in allFiles {
                print("\(path) 需要删除 \n".blue)
                try path.delete()
            }
        } catch {
            print("error=\(error)")
        }
    }
    
    public func nativeMoveFile() {
        for i in 1...10 {
            let name = "fileName\(i)"
            let newDir = Path(executionPath.string + "/" + name)
            if !newDir.isDirectory {
                try! newDir.mkdir()
                print("\(newDir)".blue)
            }
            
            if i % 2 == 0 {
                //let flieName = "fileName\(i-1)"
                let newFileDir = Path("/Users/moka/Desktop/首页切图")
                try! newDir.move(newFileDir)
            }
        }
        
    }
    
    
    func handleName(_ str: String) {
        let path = Path(str)
        let name = path.lastComponentWithoutExtension
        let result = FileNameSearchRule().search(in: name)
        
        guard let search = result.first else {
            print("没有可创建的新文件夹".red)
            return
        }
        let range = (name as NSString).range(of: search)
        let maxLen = range.location+range.length
        let dicName = String(name.prefix(maxLen))
        print("fileName=\(dicName)")
        guard let needDir = path.operationRootPath else {
            print("没有找到根目录".red)
            return
        }
        do {
            let newDir: Path = Path(needDir.string + dicName)
            
            if !newDir.isDirectory {
                try newDir.mkdir()
            }
            if newDir.isDirectory {
                FileMove.move(atPath: path.string, toPath: newDir.string)
            }
        } catch {
            print("error=\(error)".bold)
        }
    }
}

struct FileMove {
    /// 系统的File move 不能用,经常报 fileExist, 不得已用下面的方法.
    static func move(atPath: String, toPath: String) {
        if atPath == toPath {
            return
        }
        let p = Process()
        let pipe = Pipe()
        let fileHandler: FileHandle
        p.launchPath = "/usr/bin/MvMac"
        p.standardOutput = pipe
        fileHandler = pipe.fileHandleForReading
        
        let args = [atPath, toPath]
        p.arguments = args
        p.launch()
        
        let data = fileHandler.readDataToEndOfFile()
        if let string = String(data: data, encoding: .utf8), string.count > 0 {
            print("command error = \(string)".green)
        }
    }
}


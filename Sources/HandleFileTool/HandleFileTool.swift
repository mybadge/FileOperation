
import PathKit
import Cocoa

struct HandleFileTool {
    var text = "Hello, World!"
}


let fixtures = Path("/Users/moka/WorkSpace/Moka/HandleFileTool/2M")

func main() {
    print("halll word")
    let path = fixtures
    
    print("path= \(path.string)")
    
    let find = ExtensionFindProcess(path: path.string, extensions: ["jpg", "png", "mp3"], excluded: [])
    
    guard let result = find?.execute() else {
        print("没有找到文件")
        return
    }
    for p in result {
        handleName(p)
        print(p + "\n")
    }
}


func handleName(_ str: String) {
    let path = Path(str)
    let name = path.lastComponentWithoutExtension
    let result = FileNameSearchRule().search(in: name)
    
    guard let search = result.first else {
        return
    }
    let range = (name as NSString).range(of: search)
    let maxLen = range.location+range.length
    let dicName = String(name.prefix(maxLen))
    print("fileName=\(dicName)")
    
    do {
        let newDic: Path = Path(fixtures.string + "/" + dicName + "/")
        
        if !newDic.isDirectory {
            try newDic.mkdir()
        }
        if newDic.isDirectory {
            //try path.move(newDic)
            //try path.move(newDic.parent())
            FileMove().move(atPath: path.string, toPath: newDic.string)
        }
        
    } catch {
        print("error=\(error)")
    }
}


class FileMove {
    let p = Process()
    let pipe = Pipe()
    let fileHandler: FileHandle
    init() {
        p.launchPath = "/usr/bin/MvMac"
        p.standardOutput = pipe
        fileHandler = pipe.fileHandleForReading
    }
    
    func move(atPath: String, toPath: String) {
        if atPath == toPath {
            return
        }
        let args = [atPath, toPath]
        p.arguments = args
        try! p.run()
        
        let data = fileHandler.readDataToEndOfFile()
        if let string = String(data: data, encoding: .utf8) {
            print("error = \(string)")
        }
    }
}


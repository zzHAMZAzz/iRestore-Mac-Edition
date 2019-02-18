//
//  ViewController.swift
//  iRestore Mac Edition
//
//  Created by Hamza on 11/02/2019.
//  Copyright © 2019 Hamza. All rights reserved.
//

import Cocoa
import SSZipArchive
import Alamofire
import SWXMLHash

// *****************
// vernumber.stringValue = latest version of FutureRestore
// latestFRurl.stringValue = latest url of FutureRestore
// downloadedversion.stringValue = current downloaded version of FutureRestore
// *****************


class ViewController: NSViewController {
    
    
    
    func futurerestoredl()
    {
        
        // Delete any existing files to avoid overwritting issues
        let fileManager = FileManager.default
        var paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDir = paths[0]
        
        do {
            try fileManager.removeItem(atPath: documentsDir.appendingFormat("/futurerestore-latest.zip"))
            try fileManager.removeItem(atPath: documentsDir.appendingFormat("/futurerestore-latest/"))
            try fileManager.removeItem(atPath: documentsDir.appendingFormat("/futurerestore/"))
            try fileManager.removeItem(atPath: documentsDir.appendingFormat("/futurerestore_macOS_v\(vernumber.stringValue).zip"))
        }
        catch let error as NSError {
            print("Error deleting files: \(error)")
        }
        // ---------------------------
        
        
        
        
        
        let destination = DownloadRequest.suggestedDownloadDestination()
        let urlString = latestFRurl.stringValue
        print("--- Starting Download of futurerestore() ---")
        Alamofire.download(urlString, to: destination).response { response in // method defaults to `.get`
            if (response.error != nil)
            {
                print(response.error)
                let errorresponse = response.error
                let responsetostring = errorresponse?.localizedDescription
                // Make Alert
                let alert = NSAlert.init()
                alert.messageText = "Error!"
                alert.informativeText = "I tried downloading Future Restore, but it failed. Error: " + responsetostring!
                alert.alertStyle = .warning
                alert.addButton(withTitle: "OK")
                alert.runModal()
                
            }
            else
            {
                let response = response.destinationURL
                let destinationstring = response?.absoluteString
                print("DEBUG: Downloaded to: " + destinationstring!)
                
                self.unzipFutureRestore()
                
            }
        }
        
    }
    
    func assetdl()
    {
        
        let destination = DownloadRequest.suggestedDownloadDestination()
        let urlString = "https://arxius.io/api/download/file?id=24061d3e"
        print("--- Starting Download of assetdl() ---")
        Alamofire.download(urlString, to: destination).response { response in // method defaults to `.get`
            if (response.error != nil)
            {
                print(response.error)
                let errorresponse = response.error
                let responsetostring = errorresponse?.localizedDescription
                // Make Alert
                let alert = NSAlert.init()
                alert.messageText = "Error!"
                alert.informativeText = "I tried downloading an asset, but it failed. Error: " + responsetostring!
                alert.alertStyle = .warning
                alert.addButton(withTitle: "OK")
                alert.runModal()
                
            }
            else
            {
                let response = response.destinationURL
                let destinationstring = response?.absoluteString
                print("DEBUG: Downloaded to: " + destinationstring!)
                
                // make asset executable
                
                var paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
                let documentsDir = paths[0]
                self.shell("cd " + documentsDir + "; chmod +x term.scpt")
                
            }
        }
        
    }
    
    
    func unzipFutureRestore()
    {
        var paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDir = paths[0]
        let zipPath = documentsDir.appendingFormat("/futurerestore_macOS_v\(vernumber.stringValue).zip")
        let unzipPath = documentsDir.appendingFormat("/futurerestore/")
        SSZipArchive.unzipFile(atPath: zipPath, toDestination: unzipPath)
        print ("DEBUG: zipPath = " + zipPath)
        print ("DEBUG: unzipPath = " + unzipPath)
        print ("Unzipped to " + unzipPath)
        let fileManager = FileManager()
        
        let success = fileManager.fileExists(atPath: unzipPath) as Bool
        
        if success == false {
            
            do {
                print("ERROR: UNZIP FAILED - Can't find unzipped files")
                
                // show alert if Download Failed
                
                let alert = NSAlert.init()
                alert.messageText = "Error!"
                alert.informativeText = "I tried unzipping FutureRestore, but it failed. Please restart the application, or ask for support."
                alert.alertStyle = .warning
                alert.addButton(withTitle: "OK")
                alert.runModal()
                
            }
        }
        if success == true {
            let alert = NSAlert.init()
            alert.messageText = "Done!"
            alert.informativeText = "I have succesfully downloaded and extracted FutureRestore!"
            alert.alertStyle = .warning
            alert.addButton(withTitle: "OK")
            alert.runModal()
            
            // make executable
            var paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentsDir = paths[0]
            let FRpath = documentsDir.appendingFormat("/futurerestore/")
            shell("cd " + FRpath + "; chmod +x futurerestore")
            
            // add version txt file
            
            let commando = vernumber.stringValue
            if let dir : NSString = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first as! NSString {
                
                do {
                    try commando.write(toFile: "\(dir)/futurerestore/version.txt", atomically: true, encoding: String.Encoding.utf8)
                }
                catch _ {
                    
                    print("Error creating version text file")
                }
            }
            
            getdownloadedFRversion()
        }
        
        
        
    }
    // Shell is used for chmod!
    func shell(_ command: String) -> String {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", command]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        
        return output
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ** HARD CODED TO DOWNLOAD v224 of FUTURERESTORE
        
        latestFRurl.stringValue = "https://github.com/s0uthwest/futurerestore/releases/download/224/futurerestore_macOS_v224.zip"
        vernumber.stringValue = "224"
   // checkforIRupdates()

        
        let fileManager = FileManager.default
        
        
        checkforIRupdates()
        
        var paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDir = paths[0]
        let FRpath = documentsDir.appendingFormat("/futurerestore/futurerestore")
        
        if fileManager.fileExists(atPath: FRpath) {
            print("File exists")
            getdownloadedFRversion()
        }
        else {
            // show alert to inform Download
            
            let alert = NSAlert.init()
            alert.messageText = "FutureRestore not found"
            alert.informativeText = "I can't seem to find FutureRestore, if this is your first time running the program, this is normal. I will now download and unzip FutureRestore to your Documents folder."
            alert.alertStyle = .informational
            alert.addButton(withTitle: "OK")
            alert.runModal()
            
            futurerestoredl()
        }
        
        let ASpath = documentsDir.appendingFormat("/term.scpt")
        if fileManager.fileExists(atPath: ASpath) {
            print("Script Asset File exists")
        }
        else {
            
            
            assetdl()
        }
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    //
    //  IPSW BUTTON FUNCTION
    //
    
    @IBOutlet weak var ipswField: NSTextField!
    @IBAction func IPSWButton(_ sender: NSButton) {
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose an IPSW";
        dialog.showsResizeIndicator    = false;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = false;
        dialog.canCreateDirectories    = false;
        dialog.allowsMultipleSelection = false;
        dialog.allowedFileTypes        = ["ipsw"];
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                let path = result!.path
                ipswField.stringValue = path
            }
        } else {
            // User clicked on "Cancel"
            return
        }
        
    }
    
    
    //
    // CHOOSE SEP
    //
    @IBOutlet weak var sepField: NSTextField!
    @IBAction func sepButton(_ sender: NSButton) {
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose a SEP Firmware";
        dialog.showsResizeIndicator    = false;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = false;
        dialog.canCreateDirectories    = false;
        dialog.allowsMultipleSelection = false;
        dialog.allowedFileTypes        = ["im4p"];
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                let path = result!.path
                sepField.stringValue = path
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    
    //
    // CHOOSE BUILD MANIFEST
    //
    @IBOutlet weak var bmField: NSTextField!
    @IBAction func bmButton(_ sender: NSButton) {
        
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose the BuildManifest";
        dialog.showsResizeIndicator    = false;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = false;
        dialog.canCreateDirectories    = false;
        dialog.allowsMultipleSelection = false;
        dialog.allowedFileTypes        = ["plist"];
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                let path = result!.path
                bmField.stringValue = path
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    
    //
    // SHSH2 Blob
    //
    @IBOutlet weak var shshField: NSTextField!
    @IBAction func shshButton(_ sender: NSButton) {
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose an SHSH2 Blob";
        dialog.showsResizeIndicator    = false;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = false;
        dialog.canCreateDirectories    = false;
        dialog.allowsMultipleSelection = false;
        dialog.allowedFileTypes        = ["shsh2"];
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                let path = result!.path
                shshField.stringValue = path
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    
    //
    // Baseband
    //
    @IBOutlet weak var bbField: NSTextField!
    @IBAction func bbButton(_ sender: NSButton) {
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose a BaseBand Firmware";
        dialog.showsResizeIndicator    = false;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = false;
        dialog.canCreateDirectories    = false;
        dialog.allowsMultipleSelection = false;
        dialog.allowedFileTypes        = ["bbfw"];
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                let path = result!.path
                bbField.stringValue = path
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    
    
    
    
    //
    // TOGGLES
    //
    
    
    
    @IBOutlet weak var sepButton: NSButton!
    @IBOutlet weak var bbButton: NSButton!
    
    
    
    @IBAction func bbTog(_ sender: NSButton) {
        if (bbTogOutlet.state == .on)
        {
            // if No Baseband is enabled
            latestBBtog.isEnabled = false
            latestBBtog.state = .off
            bbButton.isEnabled = false
            
            // show warning popup
            let alert = NSAlert.init()
            alert.messageText = "Warning"
            alert.informativeText = "Only use this option if you know what you are doing. Using this on devices that require baseband will cause a non working restore."
            alert.alertStyle = .warning
            alert.addButton(withTitle: "OK")
            alert.runModal()
            
            bbField.stringValue = "None"
        }
        else
        {
            latestBBtog.isEnabled = true
            bbButton.isEnabled = true
            bbField.stringValue = ""
        }
    }
    @IBOutlet var bbTogOutlet: NSButton!
    
    @IBAction func sepTog(_ sender: Any) {
        if (sepTogOutlet.state == .on)
        {
            sepButton.isEnabled = false
            sepField.stringValue = "Automatic"
        }
        else
        {
            sepButton.isEnabled = true
            sepField.stringValue = ""
        }
    }
    @IBOutlet var sepTogOutlet: NSButton!
    
    
    @IBAction func latestBBTog(_ sender: Any) {
        if (latestBBOutlet.state == .on)
        {
            bbButton.isEnabled = false
            bbField.stringValue = "Automatic"
        }
        else
        {
            bbButton.isEnabled = true
            bbField.stringValue = ""
        }
    }
    @IBOutlet var latestBBOutlet: NSButton!
    
    @IBOutlet weak var latestBBtog: NSButton!
    
    
    
    
    
    
    
    
    
    //
    //
    // GO BUTTON
    //
    //
    
    @IBOutlet var sepcommand: NSTextField!
    @IBOutlet var bbcommand: NSTextField!
    @IBAction func goButton(_ sender: NSButton) {
        
        
        
        
        
        if (sepField.stringValue == "Automatic")
        { sepcommand.stringValue = "--latest-sep "
        }
        else
        { sepcommand.stringValue = "-s \"" + sepField.stringValue + "\" "
        }
        if (bbField.stringValue == "Automatic")
        { bbcommand.stringValue = "--latest-baseband "}
        else if (bbField.stringValue == "None")
        { bbcommand.stringValue = "--no-baseband "
        }
        else
        { bbcommand.stringValue = "-b \"" + bbField.stringValue + "\" "
        }
        
        let program = "./futurerestore "
        let blob = "-t \"" + shshField.stringValue + "\" "
        
        let buildmanifest = "-p \"" + bmField.stringValue + "\" "
        let buildmanifest2 = "-m \"" + bmField.stringValue + "\" "
        let ipsw = "\"" + ipswField.stringValue + "\""
        
        
        
        let command = program + blob + bbcommand.stringValue + buildmanifest + sepcommand.stringValue + buildmanifest2 + ipsw
        
        
        
        print(command)
        
        var paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDir = paths[0]
        
        
        let commando = """
        #! /bin/bash
        cd ~/Documents/futurerestore/
        printf "******************************"
        printf "\n"
        printf "\n"
        printf "iRestore has generated the command: \n"
        echo "\(command)"
        printf "\n"
        printf "\n"
        printf "I will now run this command which will initiate FutureRestore. Good Luck!"
        sleep 3
        printf "\n Starting in 5 Seconds"
        printf "\n"
        printf "\n"
        printf "\n"
        printf "\n"
        printf "\n 5"
        sleep 1
        printf "\n 4"
        sleep 1
        printf "\n 3"
        sleep 1
        printf "\n 2"
        sleep 1
        printf "\n 1 \n"
        printf "****************************** \n"
        \(command)
        """
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first as! NSString {
            
            do {
                try commando.write(toFile: "\(dir)/temp.command", atomically: true, encoding: String.Encoding.utf8)
                
                shell("chmod u+x \(dir)/temp.command")
                shell("\(dir)/term.scpt \"\(dir)/temp.command\"")
            }
            catch _ {
                
                print("Error creating command")
            }
        }
        
        
    }
    
    @IBAction func help(_ sender: Any) {
        
        let alert = NSAlert.init()
        alert.messageText = "Info"
        alert.informativeText = """
        
        IPSW: The version you wish to restore to. Can be downloaded from https://ipsw.me
        
        SEP:Specify a custom version of SEP (stores passwords, TouchID, etc) to restore. Must be compatible with restore version.
        
        SEP Manifest: Required if you are using a custom SEP.
        
        SHSH2 Blob: The saved blob for the selected restore version.
        
        Baesband: Specify a custom version of baseband to restore. Must be compatible with restore version.
        
        Baseband Manifest: Required if you are using a custom baseband.
        
        
        ****************
        
        Your Downloaded FutureRestore Version: v\(downloadedversion.stringValue)
        
        """
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.runModal()
        
    }
    

    
    func getdownloadedFRversion()
    {
        var paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDir = paths[0]
        let path = documentsDir.appendingFormat("/futurerestore/version.txt")
        
        do {
            // Get the contents
            let contents = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)
            downloadedversion.stringValue = contents as String
        }
        catch let error as NSError {
            print("Error finding downloaded FutureRestore version: \(error)")
        }
        
    }
    
    
    func checkforIRupdates()
    {
        //
    
        let baseUrl = "https://zapier.com/engine/rss/4285659/iRestoreReleases/"
        let request = NSMutableURLRequest(url: NSURL(string: baseUrl)! as URL)
        let session = URLSession.shared
        request.httpMethod = "GET"
    
        var err: NSError?
    
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
    
            if data == nil {
                print("dataTaskWithRequest error: \(error)")
                return
            }
    
            let xml = SWXMLHash.parse(data!)
    
            if let definition = xml["rss"]["channel"]["item"]["description"].element?.text {
    
                let latestiRversion = definition
    
                let currentiRversion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
                let latestiRversion1 = String(latestiRversion.dropFirst())
    
                let latestiRversion2 = latestiRversion1.replacingOccurrences(of: ".", with: "")
                let currentiRversion2 = currentiRversion!.replacingOccurrences(of: ".", with: "")
    
                print("LATEST: \(latestiRversion2) - CURRENT: \(currentiRversion2)")
    
                DispatchQueue.main.async { // Correct
                    self.currentIR.stringValue = currentiRversion2
                    self.latestIR.stringValue = latestiRversion2
    
    
                    let DLd:Int = Int(self.currentIR.stringValue)!
                    let LTs:Int = Int(self.latestIR.stringValue)!
    
                    if DLd < LTs
                    {
                        print("iRESTORE UPDATE AVAILABLE")
    
    
    
                        let alert = NSAlert.init()
                        alert.messageText = "Update Availalbe!"
                        alert.informativeText = """
                        An update is available for iRestore - Mac Edition!
                        
                        Your version is v\(self.currentIR.stringValue)
                        The latest version is v\(self.latestIR.stringValue)
                        """
                        alert.alertStyle = .informational
                        alert.addButton(withTitle: "Visit Download Page")
                        alert.addButton(withTitle: "Later")
    
                        alert.beginSheetModal(for: self.view.window!, completionHandler: { (modalResponse) -> Void in
                            if modalResponse == NSApplication.ModalResponse.alertFirstButtonReturn {
                                guard let url = URL(string: "https://github.com/zzHAMZAzz/iRestore-Mac-Edition/releases/latest") else { return }
                                NSWorkspace.shared.open(url)
                            }
                        })
    
                    }
                    else
                    {
                    }
    
                }
            }
        }
        task.resume()
    
    
    }
    
    


    @IBOutlet var latestFRurl: NSTextField!
    @IBOutlet var downloadedversion: NSTextField!
    @IBOutlet var vernumber: NSTextField!
    


        
    
    
    

    
    @IBOutlet var currentIR: NSTextField!
    @IBOutlet var latestIR: NSTextField!}



//
//  Updater Functions.swift
//  iRestore Mac Edition
//
//  Created by Hamza on 18/02/2019.
//  Copyright © 2019 Hamza. All rights reserved.
//

// ****************
// These are functions that were used in the main controller but were removed for whatever reason.
// ****************










//
//
//
//
//
//

//func updateFR()
//{
//do {
//    let DLd:Int = Int(downloadedversion.stringValue)!
//    let LTs:Int = Int(vernumber.stringValue)!
//    
//    
//    if DLd < LTs
//    {
//        print("UPDATE AVAILABLE")
//        
//        
//        
//        let alert = NSAlert.init()
//        alert.messageText = "Update Availalbe!"
//        alert.informativeText = """
//        An update is available for FutureRestore!
//        
//        Your version is v\(downloadedversion.stringValue)
//        The latest version is v\(vernumber.stringValue)
//        """
//        alert.alertStyle = .informational
//        alert.addButton(withTitle: "Update Now")
//        alert.addButton(withTitle: "Later")
//        
//        alert.beginSheetModal(for: self.view.window!, completionHandler: { (modalResponse) -> Void in
//            if modalResponse == NSApplication.ModalResponse.alertFirstButtonReturn {
//                print("Update Now - PRESSED")
//                self.futurerestoredl()
//            }
//        })
//        
//    }
//    else
//    {
//    }
//    
//}
//catch{
//}
//}



//    func checkforFRupdates()
//    {
//
//        let baseUrl1 = "https://zapier.com/engine/rss/4285659/s0uthwestFRreleases/"
//        let request1 = NSMutableURLRequest(url: NSURL(string: baseUrl1)! as URL)
//        let session1 = URLSession.shared
//        request1.httpMethod = "GET"
//        var err1: NSError?
//
//        let task1 = session1.dataTask(with: request1 as URLRequest) {
//            (data, response, error) in
//
//            if data == nil {
//                print("dataTaskWithRequest error: \(error)")
//                return
//            }
//
//            let xml = SWXMLHash.parse(data!)
//
//            if let definition = xml["rss"]["channel"]["item"]["description"].element?.text {
//
//                let smth = definition
//
//
//
//                if let index = (smth.range(of: ",")?.lowerBound)
//                {
//                    let macOSlink = String(smth.prefix(upTo: index))
//                    print(macOSlink)
//                    DispatchQueue.main.async { // Correct
//                        self.latestFRurl.stringValue = macOSlink
//                        let ver = String(smth.suffix(3))
//                        self.vernumber.stringValue = ver
//                        print(ver)
//                        //   self.checkforFRupdates()
//                    }
//                }
//
//            }
//
//
//
//
//
//        }
//        task1.resume()
//
//
//    }

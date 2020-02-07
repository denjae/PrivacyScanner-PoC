//
//  CheckerHelper.swift
//  PrivacyScanner
//
//  Created by Dennis Jaeger on 17.01.20.
//  Copyright © 2020 Dennis Jaeger. All rights reserved.
//

import Foundation
import SwiftUI

//Funktion zum Berechnen des Durchschnitts aller Werte
func sumThreatments(_ comps: [ComponentList]) -> Float{
    var sumSeverity = Float()
    for components in comps.makeIterator() {
        sumSeverity += components.severity
    }
    return (sumThreats / sumSeverity)
}

//Funktion zum Neuladen der ComponentList
func reloadComponentList() -> [ComponentList] {
    sumThreats = 0
    
    func build(_ comp: ThreatmentComponent) -> ComponentList {
        return ComponentList(desc: comp.desc, color: comp.color(), severity: comp.severity)
    }
    
    return [
        FileVaultComponent(),
        IsPasswordComponent(),
        BookmarkSocialMediaComponent(),
        TwitterClientComponent(),
        GoogleTrackingComponent(),
        FacebookTrackingComponent(),
        DefaultBrowserComponent(),
        HTTPSComponent(),
        WhatsappComponent(),
        PasswordManagerComponent(),
        LocationServiceComponent(),
        AdblockerComponent(),
        AmazonAccountComponent(),
        FacebookWhatsappComboComponent(),
        ICloudComponent(),
        DropboxComponent(),
        ScieboComponent(),
        NextCloudComponent(),
        GoogleDriveComponent(),
        OneDriveComponent()
    ].map(build)
}


func findCredentials (searchString: String) -> Bool {
    return URLCredentialStorage.doesContain(searchString)
}


func getPercentage(_ value:CGFloat) -> String {
    let intValue = Int(ceil(value * 100))
    return "\(intValue) %"
}


func appChecker(path: String, severity: Float) -> Color {
    var error:NSError?
    let pathURL = NSURL (fileURLWithPath: path)
    
    if  pathURL.checkPromisedItemIsReachableAndReturnError(&error)  {
        sumThreats += severity
            return .red
    }
    else{
            return .green
    }
}

//Hilfsfunktion zur Kommunikation mit dem Terminal
func shell(launchPath: String, arguments: [String]) -> String{
    let task = Process()
    task.launchPath = launchPath
    task.arguments = arguments

    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()
    task.waitUntilExit()
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    var output = String(data: data, encoding: .utf8)!
    output.removeLast()
    output.removeLast()
    return output
}

private var urlSession:URLSession = {
    var newConfiguration:URLSessionConfiguration = .default
    newConfiguration.waitsForConnectivity = false
    newConfiguration.allowsCellularAccess = true
    return URLSession(configuration: newConfiguration)
}()

//Überprüfung, ob Google via HTTPS erreichbar ist
public func canReachGoogleHTTPS() -> Bool {
    let url = URL(string: "https://8.8.8.8")
    let semaphore = DispatchSemaphore(value: 0)
    var success = false
    let task = urlSession.dataTask(with: URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 2.0))
    { data, response, error in
        if error != nil
        {
            success = false
        }
        else
        {
            success = true
        }
        semaphore.signal()
    }

    task.resume()
    semaphore.wait()

    return success
}

//Suchen von Cookies
func findCookies(name: String) -> Bool {
let cookieJar = HTTPCookieStorage.shared
var isCookie = false
let fileManager = FileManager.default
let path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
let url = NSURL(fileURLWithPath: path)
let pathComponent = url.appendingPathComponent("Cookies")
let filePath = pathComponent?.path
let files = fileManager.enumerator(atPath: filePath ?? "file not found")

    for cookie in cookieJar.cookies! {
        if cookie.name.lowercased().contains(name.lowercased()) {
        isCookie = true
        break
        }
    }

    while let file = files?.nextObject() {
        let x = file as! String.UnicodeScalarLiteralType
        let searchString = name
        if x.lowercased().contains(searchString.lowercased()) {
            isCookie = true
            break
        }
    }
    return isCookie
}
   
func bookmarkChecker(bookmark: String) -> Bool {
    var format = PropertyListSerialization.PropertyListFormat.xml
    
    guard let path = URL(string: NSHomeDirectory()+"/Library/Safari/Bookmarks.plist"),
        let data = FileManager.default.contents(atPath: path.absoluteString),
        let file = (try? PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: &format) as? [String : Any])?.description.lowercased() else {
            return false
    }
    
    return file.contains(bookmark)
}

//
//  Checker.swift
//  PrivacyScanner
//
//  Copyright © 2019 Dennis Jaeger. All rights reserved.
//

import Foundation
import SwiftUI
import CoreLocation

var sumThreats = Float()

//Funktion zur Prüfung, ob FileVault aktiviert ist
   func getFileVaultState() -> Color{
    let output = shell(launchPath: "/usr/bin/env", arguments: ["fdesetup", "status"])
    if output.elementsEqual("FileVault is On") {
        return .green
        }
      if output.elementsEqual("FileVault is Off") {
        sumThreats += FileVaultComponent().severity
        return .red
      }
        else {
            return .white
        }
    }

//Ist ein Benutzerpasswort gesetzt?
func getPasswordState() -> Color {
    let secret = "Device has passcode set?".data(using: String.Encoding.utf8, allowLossyConversion: false)
    let attributes = [kSecClass as String:kSecClassGenericPassword, kSecAttrService as String:"LocalDeviceServices", kSecAttrAccount as String:"NoAccount", kSecValueData as String:secret!, kSecAttrAccessible as String:kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly] as [String : Any]
    let status = SecItemAdd(attributes as CFDictionary, nil)
    
    if status == 0 {
        sumThreats += IsPasswordComponent().severity
        return .red
    }
    else {
        return .green
    }
}

//Überprüfung, ob Bookmark zu sozialem Netz gesetzt ist
//TODO überprüft aktuell nur Safari Bookmarks.
func getFacebookUsage() -> Color {
    let facebook = "facebook"
    let insta = "instagram"
    
    if bookmarkChecker(bookmark: facebook) || bookmarkChecker(bookmark: insta)  {
        sumThreats += BookmarkSocialMediaComponent().severity
        return .red
    }
    else{
        return .green
    }
}

// Überprüfen, ob Twitter, Tweetbot- oder Twitterrific-Client installiert ist
func isTwitterClientInstalled() -> Color {
    var error:NSError?

    let tweetbotURL = NSURL (fileURLWithPath: "/Applications/Tweetbot.app")
    let twitterURL = NSURL (fileURLWithPath: "/Applications/Twitter.app")
    let twitterrificURL = NSURL (fileURLWithPath: "/Applications/Twitterrific.app")
    let tweetdeckURL = NSURL (fileURLWithPath: "/Applications/TweetDeck.app")
    
    if  tweetbotURL.checkResourceIsReachableAndReturnError(&error) || twitterURL.checkResourceIsReachableAndReturnError(&error) ||
        twitterrificURL.checkResourceIsReachableAndReturnError(&error) || tweetdeckURL.checkResourceIsReachableAndReturnError(&error)
    {
        sumThreats += TwitterClientComponent().severity
        return .red
    }
    else{
        return .green
    }
}

// Überprüfen, ob 1Password, LastPass oder MacPass installiert ist
func isPasswordmanagerInstalled() -> Color {
    var error:NSError?
    let onePasswordURL = NSURL (fileURLWithPath: "/Applications/1Password 7.app")
    let lastPassURL = NSURL (fileURLWithPath: "/Applications/Lastpass.app")
    let macPassURL = NSURL (fileURLWithPath: "/Applications/MacPass.app")
    
    if  onePasswordURL.checkResourceIsReachableAndReturnError(&error) || lastPassURL.checkResourceIsReachableAndReturnError(&error) ||
        macPassURL.checkResourceIsReachableAndReturnError(&error)
    {
        return .green
    }
    else{
        sumThreats += PasswordManagerComponent().severity
            return .red
    }
}

//Abfrage des Standard-Browsers
func defaultBrowser() -> Color {
    let defaultBrowser = LSCopyDefaultApplicationURLForContentType(kUTTypeHTML, .all, nil)
    let browserString = defaultBrowser.debugDescription
    if browserString.lowercased().contains("chrome"){
        sumThreats += DefaultBrowserComponent().severity
        return .red
    }
    if browserString.lowercased().contains("firefox"){
        sumThreats += (DefaultBrowserComponent().severity)*0.5
        return .yellow
    }
    if browserString.lowercased().contains("safari"){
        sumThreats += (DefaultBrowserComponent().severity)*0.5
        return .yellow
    }
    if browserString.lowercased().contains("opera"){
        sumThreats += (DefaultBrowserComponent().severity)*0.5
            return .yellow
        }
    if browserString.lowercased().contains("tor"){
        return .green
    }
    else {
        return Color.white
    }
    
}

//Überprüfung, ob LocationServices aktiviert sind oder nicht
func checkLocationServiceState() -> Color {
    if CLLocationManager.locationServicesEnabled() {
        sumThreats += LocationServiceComponent().severity
        return .red
    }
    else {
        return .green
    }
}


//Funktion zur Überprüfung ob Google genutzt wird
func findGoogleCredentials(searchString: String) -> Color {
    let google = "google"
   
    if findCredentials(searchString: google) || findCookies(name: google) {
                sumThreats += GoogleTrackingComponent().severity
                return .red
    }
    else { return .green }
}


//Überprüfung ob Anzeichen zur Nutzung von Amazon gefunden worden sind
func findAmazonCredentials() -> Color {
    let amazon = "amazon"

    if bookmarkChecker(bookmark: amazon) || findCredentials(searchString: amazon) || findCookies(name: amazon) {
            sumThreats += AmazonAccountComponent().severity
                return .red
            }
            else{ return .green }
}

//Wird Facebook genutzt?
func findFacebookCredentials() -> Color {
    let facebook = "facebook"
        
    if findCredentials(searchString: facebook) || findCookies(name: facebook) {
            sumThreats += FacebookTrackingComponent().severity
            return .red
            }
    else { return .green }
}

// Überprüfung ob ein Adblocker installiert ist
func adBlockerCheck() -> Color {
    var error:NSError?
    let uBlockURL = NSURL (fileURLWithPath: "/Applications/uBlock.app")
    let adBlockURL = NSURL (fileURLWithPath: "/Applications/Adblock.app")
    let abpURL = NSURL (fileURLWithPath: "/Applications/AdblockPlus.app")
    
    if  uBlockURL.checkResourceIsReachableAndReturnError(&error) || adBlockURL.checkResourceIsReachableAndReturnError(&error) ||
        abpURL.checkResourceIsReachableAndReturnError(&error)
    {
        return .green
    }
    else{
        sumThreats += AdblockerComponent().severity
        return .red
    }
}

//Check ob iCloud genutzt wird
func iCloudUsage() -> Color {
    if FileManager.default.ubiquityIdentityToken != nil {
        sumThreats += ICloudComponent().severity
        return .red
    }
    else {
        return .green
    }
}

//Überprüfung ob Facebook und WhatsApp in Kombination vorhanden sind
func facebookWhatsappCombo() -> Color {
    if getFacebookUsage() == .red && appChecker(path: "/Applications/WhatsApp.app", severity: WhatsappComponent().severity) == .red {
        sumThreats += FacebookWhatsappComboComponent().severity
        return .red
    }
    else{
        return .green
    }
}


//Überprüfung ob eine Seite via https erreichbar ist
func tryHttps () -> Color {
    if canReachGoogleHTTPS() {
        return .green
    }
    if !canReachGoogleHTTPS() {
        sumThreats += HTTPSComponent().severity
        return .red
    }
    else {
        return .white
    }
}

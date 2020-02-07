//
//  PrivacyThreatment.swift
//  PrivacyScanner
//
//  Created by Dennis Jaeger on 23.12.19.
//  Copyright © 2019 Dennis Jaeger. All rights reserved.
//

import Foundation
import SwiftUI

//Bewertung nach Bedrohungsmatrix als Konstanten
enum Severity: Float {
    case GERING = 0.2
    case MITTEL = 0.5
    case HOCH = 0.8
    case SEHR_HOCH = 1.0
}

//Interface oder Protokoll zur Implementierung konkreter Instanzen
protocol ThreatmentComponent {
    var severity: Float {get}
    var desc: String {get}
    func color() -> Color
}

struct ComponentList :Identifiable {
    var id = UUID()
    var desc = String()
    var color = Color.white
    var severity = Float()
}

//Filevault Komponente
class FileVaultComponent: ThreatmentComponent {
    func color() -> Color {
        return getFileVaultState()
    }
     var severity =  Severity.MITTEL.rawValue
     var desc = "Ist FileVault aktiviert?"
}

//Komponente, ob Passwort vergeben ist
class IsPasswordComponent: ThreatmentComponent {
    func color() -> Color {
        return getPasswordState()
    }
     var severity = Severity.GERING.rawValue
     var desc = "Ist ein Password für den Benutzeraccount vergeben?"
}

//Komponente, ob Lesezeichen zu social Media vorhanden sind
class BookmarkSocialMediaComponent: ThreatmentComponent {
    func color() -> Color {
        return getFacebookUsage()
    }
     var severity = Severity.SEHR_HOCH.rawValue
     var desc = "Keine Lesezeichen zu Instagram oder Facebook?"
}

//Ist Twitter-Client installiert?
class TwitterClientComponent: ThreatmentComponent {
    func color() -> Color {
        return isTwitterClientInstalled()
    }
     var severity = Severity.MITTEL.rawValue
     var desc = "Kein Twitter-Client installiert?"
}

//Sind Google-Cookies vorhanden?
class GoogleTrackingComponent: ThreatmentComponent {
    func color() -> Color {
        return findGoogleCredentials(searchString: "google")
    }
     var severity = Severity.SEHR_HOCH.rawValue
     var desc = "Kein Google-Tracking gemessen?"
}

//Sind Facebook-Cookies vorhanden?
class FacebookTrackingComponent: ThreatmentComponent {
    func color() -> Color {
        return findFacebookCredentials()
    }
     var severity = Severity.SEHR_HOCH.rawValue
     var desc = "Kein Facebook-Tracking gemessen?"
}

//Standard-Browser Komoponente
class DefaultBrowserComponent: ThreatmentComponent {
    func color() -> Color {
        return defaultBrowser()
    }
     var severity = Severity.HOCH.rawValue
     var desc = "Privater Standard-Browser ausgewählt?"
}

//Komponente HTTPS-Nutzung
class HTTPSComponent: ThreatmentComponent {
    func color() -> Color {
        return tryHttps()
    }
     var severity = Severity.MITTEL.rawValue
     var desc = "Wird HTTPS genutzt?"
}

//Komponente Whatsapp Installation
class WhatsappComponent: ThreatmentComponent {
    func color() -> Color {
        return appChecker(path: "/Applications/WhatsApp.app", severity: severity)
    }
     var severity = Severity.HOCH.rawValue
     var desc = "Kein WhatsApp-Messenger installiert?"
}

//Ist 1Password oder Keepass installiert
class PasswordManagerComponent: ThreatmentComponent {
    func color() -> Color {
        return isPasswordmanagerInstalled()
    }
     var severity = Severity.GERING.rawValue
     var desc = "Ist ein Passwort-Manager installiert?"
}

//Komponente Ortungsdienste
class LocationServiceComponent: ThreatmentComponent {
    func color() -> Color {
        return checkLocationServiceState()
    }
     var severity = Severity.MITTEL.rawValue
     var desc = "Sind Ortungsdienste deaktiviert?"
}

//Komponente, ob Adblocker installiert sind
class AdblockerComponent: ThreatmentComponent {
    func color() -> Color {
        return adBlockerCheck()
    }
     var severity = Severity.MITTEL.rawValue
     var desc = "Ist ein Adblocker im Browser installiert?"
}

class FacebookWhatsappComboComponent: ThreatmentComponent {
    func color() -> Color {
        return facebookWhatsappCombo()
    }
     var desc = "Keine Facebook- und WhatsApp-Kombination?"
     var severity = Severity.SEHR_HOCH.rawValue
}

//Komponente, ob Amazon-Konto vorhanden ist
class AmazonAccountComponent: ThreatmentComponent {
    func color() -> Color {
        return findAmazonCredentials()
    }
     var severity = Severity.HOCH.rawValue
     var desc = "Keine Anzeichen zur Nutzung von Amazon?"
}

//Cloud-Komponenten

//iCloud-Komponente
class ICloudComponent : ThreatmentComponent {
    func color() -> Color {
        return iCloudUsage()
    }
     var severity = Severity.HOCH.rawValue
     var desc = "Keine Nutzung von iCloud?"
}

//Dropbox-Komponente
class DropboxComponent : ThreatmentComponent {
    func color() -> Color {
        return appChecker(path: "/Applications/Dropbox.app", severity: severity)
    }
     var severity = Severity.SEHR_HOCH.rawValue
     var desc = "Keine Nutzung von Dropbox?"
}

//Sciebo-Komponente
class ScieboComponent : ThreatmentComponent {
    func color() -> Color {
        return appChecker(path: "/Applications/sciebo.app", severity: severity)
    }
     var severity = Severity.HOCH.rawValue
     var desc = "Keine Nutzung von Sciebo?"
}

//Nextcloud-Komponente
class NextCloudComponent : ThreatmentComponent {
    func color() -> Color {
        return appChecker(path: "/Applications/nextcloud.app", severity: severity)
    }
     var severity = Severity.GERING.rawValue
     var desc = "Keine Nutzung von nextcloud?"
}

//GoogleDrive-Komponente
class GoogleDriveComponent : ThreatmentComponent {
    func color() -> Color {
        return appChecker(path: "/Applications/Backup and Sync.app", severity: severity)
    }
     var severity = Severity.SEHR_HOCH.rawValue
     var desc = "Keine Nutzung von Google Drive?"
}

//OneDrive-Komponente
//TODO Severity checken
class OneDriveComponent : ThreatmentComponent {
    func color() -> Color {
        return appChecker(path: "/Applications/OneDrive.app", severity: severity)
    }
     var severity = Severity.SEHR_HOCH.rawValue
     var desc = "Keine Nutzung von OneDrive?"
}

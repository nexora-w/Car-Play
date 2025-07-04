//
//  AppIntent.swift
//  TDS Video
//
//  Created by Nexora on 25/03/2025.
//


import AppIntents


struct SaveToSharedDefaultsIntent: AppIntent {
    static var title: LocalizedStringResource = "Send URL to screen"
    
    @Parameter(title: "URL as String")
    var textToSave: String
    var isDiscoverable:Bool = true
    static var openAppWhenRun: Bool = false

    func perform() async throws -> some IntentResult {
        // Replace with your actual App Group ID
        let sharedDefaults = UserDefaults(suiteName: "group.net.Nexora.TDS-docs")
        sharedDefaults?.set(textToSave, forKey: "TDVideo-SharedURL")
        
        // Post cross-process notification
               let notificationName = "group.net.Nexora.TDS-docs.TDVideo-SharedURL"
               CFNotificationCenterPostNotification(
                   CFNotificationCenterGetDarwinNotifyCenter(),
                   CFNotificationName(notificationName as CFString),
                   nil,
                   nil,
                   true
               )

        return .result()
    }
}

//
//  WordViewApp.swift
//  WordView
//
//  Created by Phillip Le on 10/9/23.
//

import SwiftUI

@main
struct WordViewApp: App {
    var body: some Scene {

        WindowGroup {
            ContentView()
                .environmentObject(DictionaryViewModel())
        }
    }
}

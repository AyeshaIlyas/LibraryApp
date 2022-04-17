//
//  LibraryApp.swift
//  Library
//
//  Created by Ayesha Ilyas on 4/16/22.
//

import SwiftUI

@main
struct LibraryApp: App {
    var body: some Scene {
        WindowGroup {
            LibraryView()
                .environmentObject(LibraryModel())
        }
    }
}

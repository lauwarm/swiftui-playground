//
//  ContentView.swift
//  rss-xml-parser
//
//  Created by Fabian on 12.09.22.
//

import SwiftUI
import SWXMLHash

struct ContentView: View {
    
    @State private var selection: Tab = .list
    
    enum Tab {
        case featured
        case list
        case settings
    }

    var body: some View {
        TabView(selection: $selection) {
            ListView().tabItem {
                Label("Feed", systemImage: "list.bullet")
            }.tag(Tab.list)
            SettingsView().tabItem {
                Label("Settings", systemImage: "gearshape")
            }.tag(Tab.settings)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

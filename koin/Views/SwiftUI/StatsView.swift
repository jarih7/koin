//
//  StatsView.swift
//  koin
//
//  Created by Jaroslav Hampejs on 12/04/2021.
//

import SwiftUI

struct StatsView: View {
    //@State private var toggle = true
    
    /*
    var body: some View {
        List {
            Section(header: Text("first")) {
                Text("hele na to")
                Text("husté, že?")
                Toggle(isOn: $toggle) {
                    Text("Toggle this")
                }
            }
            
            Section(header: Text("second")) {
                Text("druhá část nastavení")
                Text("abcdefghijklmnop")
                Text("SwiftUI Settings")
            }
        }.listStyle(GroupedListStyle())
    }*/
    
    var body: some View {
        //TODO align top
        VStack {
            ChartView()
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}

//
//  ChartView.swift
//  koin
//
//  Created by Jaroslav Hampejs on 15/09/2021.
//

import SwiftUI

struct ChartView: View {
    let calendar = Calendar.current
    var date: Date = Date()
    var dateFormatter: DateFormatter = DateFormatter()
    
    init() {
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "EEE"
    }
    
    var body: some View {
        VStack {
            Label("LAST WEEK", systemImage: "bolt.fill").labelStyle(TitleOnlyLabelStyle()).frame(maxWidth: .infinity, alignment: .leading).font(.headline).padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
            VStack {
                HStack(alignment: .center, spacing: nil) {
                    ForEach(1...7, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 10).frame(maxWidth: .infinity, maxHeight: 300)
                    }
                }
                HStack(alignment: .center, spacing: nil) {
                    ForEach(1...7, id: \.self) { id in
                        Text("\(dateFormatter.string(from: calendar.date(byAdding: .day, value: id, to: date) ?? Date()))").frame(maxWidth: .infinity)
                    }
                }
            }.padding(15).background(Color(UIColor.secondarySystemBackground)).cornerRadius(10)
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}

//
//  ContentView.swift
//  Zaman
//
//  Created by Danyal Faheem on 25/01/2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PrayerTimesViewModel()
    
    var body: some View {
        MenuBarPopupView(viewModel: viewModel)
    }
}

#Preview {
    ContentView()
}

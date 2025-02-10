//
//  Home.swift
//  Little Lemon
//
//  Created by Bruno Juliani Martho on 07/02/25.
//

import SwiftUI

struct Home: View {
    let persistence = PersistenceController.shared

    var body: some View {
        TabView {
            Menu()
                .environment(\.managedObjectContext, persistence.container.viewContext)
                .tabItem {
                    Label("Menu", systemImage: "list.dash")
                }
            UserProfile()
                .tabItem {
                    Label("Profile", systemImage: "square.and.pencil")
                }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    Home()
}

//
//  UserProfile.swift
//  Little Lemon
//
//  Created by Bruno Juliani Martho on 07/02/25.
//

import SwiftUI

struct UserProfile: View {
    let firstName: String = UserDefaults.standard.string(forKey: kFirstName) ?? ""
    let lastName: String = UserDefaults.standard.string(forKey: kLastName) ?? ""
    let email: String = UserDefaults.standard.string(forKey: kEmail) ?? ""
    
    @Environment(\.presentationMode) var presentation
    var body: some View {
        VStack {
            Text("Personal information")
                .font(.headline)
                .padding(.bottom, 20)
            
            Image("profile-image-placeholder")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .padding(.bottom, 20)
            
            Text("First Name: \(firstName)")
                .padding(.bottom, 10)
            
            Text("Last Name: \(lastName)")
                .padding(.bottom, 10)
            
            Text("Email: \(email)")
                .padding(.bottom, 10)
            
            Button("Logout"){
                UserDefaults.standard.set(false, forKey: kIsLoggedIn)
                self.presentation.wrappedValue.dismiss()
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    UserProfile()
}

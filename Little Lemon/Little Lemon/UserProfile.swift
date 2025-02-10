//
//  UserProfile.swift
//  Little Lemon
//
//  Created by Bruno Juliani Martho on 07/02/25.
//

import SwiftUI

struct UserProfile: View {
    @State private var firstName: String = UserDefaults.standard.string(forKey: kFirstName) ?? ""
    @State private var lastName: String = UserDefaults.standard.string(forKey: kLastName) ?? ""
    @State private var email: String = UserDefaults.standard.string(forKey: kEmail) ?? ""
    @State private var showAlert = false
    
    @Environment(\.presentationMode) var presentation
    var body: some View {
        VStack {
            HStack {
                Text("Personal information")
                    .font(.headline)
                    .padding(.bottom, 20)
                
                Spacer()
            }
            
            HStack {
                Text("Avatar")
                    .font(.headline)
                    .padding(.bottom, 14)
                
                Spacer()
            }
            
            HStack {
                Image("profile-image-placeholder")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding(.bottom, 20)
                
                Spacer()
            }
            
            
            HStack {
                Text("First Name")
                    .font(.headline)
                    .padding(.bottom, 8)
                
                Spacer()
            }
            
            TextField("First Name", text: $firstName)
                .padding(4)
                .background(RoundedRectangle(cornerSize: .init(width: 8, height: 8)).fill(Color(.systemGray6))) .padding(.bottom, 8)
            
            HStack {
                Text("Last Name")
                    .font(.headline)
                    .padding(.bottom, 8)
                
                Spacer()
            }
            
            TextField("Last Name", text: $lastName)
                .padding(4)
                .background(RoundedRectangle(cornerSize: .init(width: 8, height: 8)).fill(Color(.systemGray6))) .padding(.bottom, 8)
            
            HStack {
                Text("Email")
                    .font(.headline)
                    .padding(.bottom, 8)
                
                Spacer()
            }
            
            TextField("Email", text: $email)
                .padding(4)
                .background(RoundedRectangle(cornerSize: .init(width: 8, height: 8)).fill(Color(.systemGray6))) .padding(.bottom, 8)
            
            Button("Logout"){
                UserDefaults.standard.set(false, forKey: kIsLoggedIn)
                self.presentation.wrappedValue.dismiss()
            }
            
            Spacer()
            
            Button(action: {
                UserDefaults.standard.set(firstName, forKey: kFirstName)
                UserDefaults.standard.set(lastName, forKey: kLastName)
                UserDefaults.standard.set(email, forKey: kEmail)
                showAlert = true
            }) {
                Text("Save changes")
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(8)
            }
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Changes Saved"),
                message: Text("Your changes have been successfully saved."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    UserProfile()
}

//
//  Onboarding.swift
//  Little Lemon
//
//  Created by Bruno Juliani Martho on 07/02/25.
//
let kFirstName = "first name key"
let kLastName = "last name key"
let kEmail = "email key"
let kIsLoggedIn = "kIsLoggedIn"

import SwiftUI

struct Onboarding: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var isLoggedIn = false
    
    var body: some View {
        VStack {
            NavigationLink(destination: Home(), isActive: $isLoggedIn) {
                EmptyView()
            }
            headerSection
                        
            TextField("First Name", text: $firstName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Last Name", text: $lastName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            
            Button("Register") {
                if(!firstName.isEmpty && !lastName.isEmpty && !email.isEmpty){
                    UserDefaults.standard.set(firstName, forKey: kFirstName)
                    UserDefaults.standard.set(lastName, forKey: kLastName)
                    UserDefaults.standard.set(email, forKey: kEmail)
                    UserDefaults.standard.set(true, forKey: kIsLoggedIn)
                    isLoggedIn = true
                }
            }.padding()
            
            Spacer()
        }.padding()
            .onAppear{
                let isLogged = UserDefaults.standard.bool(forKey: kIsLoggedIn)
                if(isLogged) {
                    isLoggedIn = true
                }
            }
    }
    
    var headerSection: some View {
        HStack{
            Text("LITTLE LEMON")
                .foregroundColor(.gray)
                .font(.system(size: 20))
                .bold()
            
            Image("profile-image-placeholder")
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 50, height: 50)
        }
    }
}

#Preview {
    Onboarding()
}

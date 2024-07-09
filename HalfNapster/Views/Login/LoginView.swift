//
//  LoginView.swift
//  HalfNapster
//
//  Created by Scott Daniel on 7/8/24.
//

import SwiftUI

struct LoginView: View 
{
    @State private var username = ""
    @State private var password = ""
    @State private var passwordVisible = false
    
    var body: some View
    {
        VStack {
            Form {
                TextField(text: $username, prompt: Text("Required")) {
                    Text("Username")
                }
             
                HStack {
                    if passwordVisible {
                        TextField(text: $password, prompt: Text("Required")) {
                            Text("Password")
                        }
                    }
                    else {
                        SecureField(text: $password, prompt: Text("Required")) {
                            Text("Password")
                        }
                    }
                    
                    Button {
                        passwordVisible.toggle()
                    } label: {
                        Image(systemName: passwordVisible ? "eye.fill" : "eye.slash.fill")
                    }
                }
            }
            
            Button("Submit") {
                
            }
        }
        .padding()
    }
}

#Preview {
    LoginView()
}

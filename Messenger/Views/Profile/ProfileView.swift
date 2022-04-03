//
//  ProfileView.swift
//  Messenger
//
//  Created by Florian Zitlau on 26.03.22.
//

import SwiftUI

struct ProfileView: View {
    
    func nothing() {
        
    }
    
    @StateObject private var ckUser = CKUserModel()
    
    var body: some View {
        VStack(spacing: 40) {
            
            VStack(spacing: 15) {
                ImageView()
                
                Menu {
                    Button("Foto aufnehmen", action: nothing)
                    Button("Foto auswählen", action: nothing)
                    Button("Foto löschen", action: nothing)
                } label: {
                    Text("change")
                        .fontWeight(.bold)
                }
            }
            
            
            VStack(spacing: 15){
                
                HStack {
                    Text(ckUser.userName)
                        .padding(.horizontal)
                        .frame(width: 300, height: 45, alignment: .leading)
                        .foregroundColor(.gray)
                        .background(Color.primary.opacity(0.1))
                        .cornerRadius(10)
                    
                    //Spacer(minLength: 0)
                }
                
                HStack {
                    Text("email")
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                        .frame(width: 300, height: 45, alignment: .leading)
                        .background(Color.primary.opacity(0.1))
                        .cornerRadius(10)
                    
                    //Spacer(minLength: 0)
                }
                
            }
            
            Button {
                //signout
            } label: {
                Text("sign out")
                    .padding(.horizontal)
                    .frame(width: 200, height: 45)
                    .foregroundColor(.white)
                    .background(Color.accentColor.opacity(0.7))
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 4)
            }

            
            
            Spacer()
        }
        .padding(.top)
    
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

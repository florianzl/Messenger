//
//  ImageView.swift
//  Messenger
//
//  Created by Florian Zitlau on 26.03.22.
//

import SwiftUI

struct ImageView: View {
    var body: some View {
        Image("florian")
            .resizable()
            .scaledToFill()
            .frame(width: 350, height: 350)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 5))
            .shadow(radius: 7)
            
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        ImageView()
    }
}

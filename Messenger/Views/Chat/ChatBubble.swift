//
//  ChatBubble.swift
//  Messenger
//
//  Created by Florian Zitlau on 26.03.22.
//

import SwiftUI

struct ChatBubble: Shape {
    var ourMsg: Bool
    
    func path(in rect: CGRect)-> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight, ourMsg ? .bottomLeft : .bottomRight], cornerRadii: CGSize(width: 15, height: 15))
        
        return Path(path.cgPath)
    }
}

//
//  ControlView.swift
//  Game2048
//
//  Created by 向松涛 on 2020/10/4.
//

import SwiftUI

struct ControlView: View {
    @EnvironmentObject var gameMananger: GameManager
    
    #if os(macOS)
    var FontSize: CGFloat = 18
    var Padding: CGFloat = 20
    #else
    var FontSize: CGFloat = 15
    var Padding: CGFloat = 15
    #endif
    
    var body: some View {
        HStack(){
            Section {
                Text("Join the numbers and get to the ") + Text("2048 tile!").bold()
            }.foregroundColor(Color(hex: "#776e65"))
            .font(.system(size: FontSize))
            
            Spacer()
            
            Button(action: {
                gameMananger.restart()
            }) {
                Text("New Game")
                    .padding(.horizontal, Padding)
                    .padding(.vertical, Padding / 2)
                    .foregroundColor(Color(hex: "#f9f6f2"))
                    .font(.system(size: FontSize))
                    .background(Color(hex: "#8f7a66"))
                    .cornerRadius(3)
                    
            }.buttonStyle(BorderlessButtonStyle())
        }
    }
}

struct ControlView_Previews: PreviewProvider {
    static var previews: some View {
        ControlView()
    }
}

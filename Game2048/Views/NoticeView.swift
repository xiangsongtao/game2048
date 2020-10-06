//
//  NoticeView.swift
//  Game2048
//
//  Created by 向松涛 on 2020/10/4.
//

import SwiftUI

struct NoticeView: View {
    
    #if os(macOS)
    var FontSize: CGFloat = 18
    #else
    var FontSize: CGFloat = 15
    #endif
    
    var body: some View {
        HStack(){
            Section {
                Text("HOW TO PLAY: ").bold() +
                    Text("Use your ") +
                    Text("arrow keys ").bold() +
                    Text("to move the tiles. When two tiles with the same number touch, they ") +
                    Text("merge into one!").bold()
            
            }.foregroundColor(Color(hex: "#776e65")).font(.system(size: FontSize))
        }
    }
}

struct NoticeView_Previews: PreviewProvider {
    static var previews: some View {
        NoticeView()
    }
}

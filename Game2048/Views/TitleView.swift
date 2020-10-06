//
//  Title.swift
//  Game2048
//
//  Created by 向松涛 on 2020/10/4.
//

import SwiftUI



struct TitleView: View {
    #if os(macOS)
    var FontSize: CGFloat = 80
    #else
    var FontSize: CGFloat = 47
    #endif
    
    var body: some View {
        Text("2048")
            .foregroundColor(Color(hex: "#776e65"))
            .font(.system(size: FontSize, weight: .bold))
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}

//
//  ScoreboardView.swift
//  Game2048
//
//  Created by 向松涛 on 2020/10/4.
//

import SwiftUI

struct ScoreboardView: View {
    var boxName: String;
    var score: Int;
    
    var body: some View {
        VStack {
            VStack {
                Text(boxName)
                    .foregroundColor(Color(hex: "#eee4da"))
                    .font(.system(size: 13, weight: .semibold))
                    
                Text(String(score))
                    .foregroundColor(.white)
                    .font(.system(size: 25, weight: .semibold))
                
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 15)
            .frame(height: 55, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .background(Color(hex: "#bbada0"))
            .cornerRadius(3)
        }
    }
}

struct ScoreboardView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreboardView(boxName: "SCORE", score: 116)
    }
}

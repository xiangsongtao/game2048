//
//  Extension.swift
//  Game2048
//
//  Created by 向松涛 on 2020/10/5.
//

import Foundation
import SwiftUI

extension Animation {
    static func marged() -> Animation {
        Animation.spring(
                dampingFraction: 0.55
        ).speed(2).delay(0.1)
    }
}

extension Color {
    init(hex: String) {
        func changeToInt(_ num: String) -> CGFloat {
            let str = num.localizedUppercase
            var sum: CGFloat = 0
            for i in str.utf8 {
                sum = sum * 16 + CGFloat(i) - 48 // 0-9 从48开始
                if i >= 65 {                 // A-Z 从65开始，但有初始值10，所以应该是减去55
                    sum -= 7
                }
            }
            return sum
        }

        func getSubstring(_ value: String, _ from: Int, _ to: Int) -> String {
            return String(value[value.index(value.startIndex, offsetBy: from)..<value.index(value.startIndex, offsetBy: to)])
        }

        var value = hex.replacingOccurrences(of: "#", with: "")
        if value.count == 6 {
            value += "FF"
        }

        let r = changeToInt(getSubstring(value, 0, 2)) / 0xff;
        let g = changeToInt(getSubstring(value, 2, 4)) / 0xff;
        let b = changeToInt(getSubstring(value, 4, 6)) / 0xff;
        let a = changeToInt(getSubstring(value, 6, 8)) / 0xff;

        self.init(
                red: Double(r),
                green: Double(g),
                blue: Double(b),
                opacity: Double(a)
        )
    }
}

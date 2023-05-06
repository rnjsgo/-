//
//  TESTVIEW.swift
//  XCAChatGPT
//
//  Created by 허현준 on 2023/05/03.
//

import SwiftUI

struct TESTVIEW: View {
    var body: some View {
        Button(action: {
            print("test")
        }, label:{
            Text("실전면접").font(.custom("Arial", size: 20)).foregroundColor(Color(hex: "#707070"))
        }).buttonStyle(SentenceButton())
    }
}

struct TESTVIEW_Previews: PreviewProvider {
    static var previews: some View {
        TESTVIEW()
    }
}

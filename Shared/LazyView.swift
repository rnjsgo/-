//
//  LazyView.swift
//  XCAChatGPT
//
//  Created by 허현준 on 2023/05/20.
//

import Foundation
import SwiftUI

struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}

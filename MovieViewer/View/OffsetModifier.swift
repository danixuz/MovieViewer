//
//  OffsetModifier.swift
//  MovieViewer
//
//  Created by Daniel Spalek on 15/05/2022.
//

import SwiftUI

// MARK: Scrollview offset reader so we can swipe up to dismiss movie description
struct OffsetModifier: ViewModifier {
    @Binding var offset: CGFloat
    
    func body(content: Content) -> some View{
        content
            .overlay{
                GeometryReader{ geometry in
                    let minY = geometry.frame(in: .named("SCROLL")).minY
                    
                    Color.clear
                        .preference(key: OffsetKey.self, value: minY)
                }
                .onPreferenceChange(OffsetKey.self) { minY in
                    self.offset = minY
                }
            }
    }
}


struct OffsetKey: PreferenceKey{
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

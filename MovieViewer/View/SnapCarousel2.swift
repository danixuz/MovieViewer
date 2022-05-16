//
//  SnapCarousel2.swift
//  MovieViewer
//
//  Created by Daniel Spalek on 15/05/2022.
//

import SwiftUI

struct SnapCarousel2<Content: View, T: Identifiable>: View {
    var content: (T) -> Content
    var list: [T]
    
    // MARK: Properties
    var spacing: CGFloat
    var trailingSpace: CGFloat
    @Binding var index: Int
    
    init(spacing: CGFloat = 15, trailingSpace: CGFloat = 100, index: Binding<Int>, items: [T], @ViewBuilder content: @escaping (T) -> Content){
        
        //Takes in viewbuilder function to use to use it in body
        
        self.list = items
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._index = index
        self.content = content
        
    }
    
    // MARK: Offset
    @GestureState var offset: CGFloat = 0
    @State var currentIndex: Int = 0
    
    var body: some View{
        
        GeometryReader{ geometry in
            
            // Setting current width for snap carousel
            
            // One sided snap carousel...
            
            let width = (geometry.size.width - (trailingSpace - spacing))
            let adjustmentWidth = (trailingSpace / 2) - spacing
            
            HStack(spacing: spacing){
                ForEach(list) { item in
                    //use the viewbuilder function we initialized
                    content(item)
                        .frame(width: geometry.size.width - trailingSpace)
                        .offset(y: getOffset(item: item, width: width))
                }
            }
            //spacing is the horizontal padding
            .padding(.horizontal, spacing)
            // setting only after 0th index...
            .offset(x: (CGFloat(currentIndex) * -width) + (currentIndex != 0 ? adjustmentWidth : 0) + offset)
            .gesture(
                DragGesture().updating($offset, body: { value, out, _ in
                    
                    // MARK: Making it a bit slower by dividing by 1.5
                    out = (value.translation.width / 1.5)
                })
                .onEnded({ value in
                    // Update the current index
                    let offsetX = value.translation.width
                    
                    // converting the translation into progress ( 0 - 1 ) and round the value. base on the progress - increasing or decreasing the currentIndex
                    let progress = -offsetX / width
                    
                    let roundIndex = progress.rounded()
                    
                    // Setting the max
                    currentIndex += max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                    
                    // updating the index
                    currentIndex = index
                })
                .onChanged({ value in
                    // updating only index...
                    
                    // Update the current index
                    let offsetX = value.translation.width
                    
                    // converting the translation into progress ( 0 - 1 ) and round the value. base on the progress - increasing or decreasing the currentIndex
                    let progress = -offsetX / width
                    
                    let roundIndex = progress.rounded()
                    
                    // Setting the max
                    index = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                })
            )
        }
        // Animating when offset = 0
        .animation(.easeInOut, value: offset == 0)
    }
    
    // Moving the view based on scroll offset
    func getOffset(item :T, width: CGFloat) -> CGFloat{
        
        //shifting the current item to the top.
        let progress = ((offset < 0 ? offset : -offset) / width) * 60
        
        // the max is 60. then again minus from 60
        let topOffset = -progress < 60 ? progress : -(progress + 120)
        
        let previous = getIndex(item: item) - 1 == currentIndex ? (offset < 0 ? topOffset : -topOffset) : 0
        
        let next = getIndex(item: item) + 1 == currentIndex ? (offset < 0 ? -topOffset : topOffset) : 0
        
        // safety check between 0 to max list size
        let checkBetween = currentIndex >= 0 && currentIndex < list.count ? (getIndex(item: item) - 1 == currentIndex ? previous : next) : 0
        
        // checking current. if so - shifting view to the top
        
        return getIndex(item: item) == currentIndex ? -60 - topOffset : checkBetween
    }
    
    // Fetching index
    func getIndex(item: T) -> Int{
        let index = list.firstIndex { currentItem in
            return currentItem.id == item.id
        } ?? 0
        
        return index
    }
}

//struct SnapCarousel2_Previews: PreviewProvider {
//    static var previews: some View {
//        SnapCarousel2()
//    }
//}

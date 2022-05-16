//
//  Home.swift
//  MovieViewer
//
//  Created by Daniel Spalek on 15/05/2022.
//

import SwiftUI

struct Home: View {
    // MARK: Animated view properties
    @State var currentIndex = 0
    @State var currentTab: String = "Films"
    
    // MARK: Detail view properties
    @State var detailMovie: Movie?
    @State var showDetailView: Bool = false
    // For matched geometry effect storing current card size
    @State var currentCardSize: CGSize = .zero
    // MARK: Environment Values
    @Namespace var animation
    @Environment(\.colorScheme) var scheme
    
    
    var body: some View {
        ZStack{
            // MARK: Background
            BGView()
            
            // MARK: Main view content
            VStack{
                
                // Custom nav bar
                NavBar()
                
                SnapCarousel2(spacing: 20, trailingSpace: 110, index: $currentIndex, items: movies) { movie in
                    
                    GeometryReader{ geometry in
                        let size = geometry.size
                        
                        Image(movie.artwork)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .cornerRadius(15)
                            .matchedGeometryEffect(id: movie.id, in: animation)
                            .onTapGesture {
                                currentCardSize = size
                                detailMovie = movie
                                withAnimation(.easeInOut){
                                    showDetailView = true
                                }
                            }
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                    }
                }
                //we use padding to make sure the elements of the carousel dont cover the top buttons
                .padding(.top, 70)
                
                
                // MARK: Custom indicator
                CustomIndicator()
                
                HStack{
                    Text("Popular")
                        .font(.title3.bold())
                    Spacer()
                    
                    Button("See More"){}
                        .font(.system(size: 16, weight: .semibold))
                }
                .padding()
                
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 15){
                        ForEach(movies){ movie in
                            Image(movie.artwork)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 120)
                                .cornerRadius(15)
                                .shadow(color: .black.opacity(0.5), radius: 5)
                        }
                    }
                    .padding()
                }
            }
            .overlay {
                if let movie = detailMovie, showDetailView{
                    DetailView(movie: movie, showDetailView: $showDetailView, detailMovie: $detailMovie, currentCardSize: $currentCardSize, animation: animation)
                }
            }
            
        }
    }
    
    // MARK: Custom indicator
    @ViewBuilder
    func CustomIndicator() -> some View{
        HStack(spacing: 5){
            ForEach(movies.indices, id: \.self){ index in
                Circle()
                    .fill(currentIndex == index ? .blue : .gray.opacity(0.5))
                    .frame(width: currentIndex == index ? 10 : 6, height: currentIndex == index ? 10: 6)
            }
        }
        .animation(.easeInOut, value: currentIndex)
        //Add animation
    }
    
    // MARK: Custom nav bar
    @ViewBuilder
    func NavBar() -> some View{
        HStack(spacing: 0){
            ForEach(["Films", "Localities"], id: \.self) { tab in
                Button {
                    withAnimation {
                        currentTab = tab
                    }
                } label: {
                    Text(tab)
                        .foregroundColor(.white)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 20)
                        .background{
                            if currentTab == tab{
                                Capsule()
                                    .fill(.ultraThinMaterial)
                                    .environment(\.colorScheme, .dark)
                                    .matchedGeometryEffect(id: "TAB", in: animation)
                            }
                        }
                }

            }
        }
        .padding()
    }
    
    // MARK: Blurred Background
    @ViewBuilder
    func BGView() -> some View{
        GeometryReader{ geometry in
            let size = geometry.size
            
            TabView(selection: $currentIndex) {
                ForEach(movies.indices, id: \.self){ index in
                    Image(movies[index].artwork)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .clipped()
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentIndex)
            
            
            // MARK: Custom gradient
            let color: Color = (scheme == .dark ? .black : .white)
            LinearGradient(colors: [
                .black,
                .clear,
                color.opacity(0.15),
                color.opacity(0.5),
                color.opacity(0.8),
                color,
                color
            ], startPoint: .top, endPoint: .bottom)
            
            // MARK: Blurred overlay
            Rectangle()
                .fill(.ultraThinMaterial)
        }
        .ignoresSafeArea()
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
        Home().preferredColorScheme(.dark)
    }
}

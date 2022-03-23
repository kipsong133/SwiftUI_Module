//
//  Home.swift
//  SwiftUI ParallaxHeader+ViewPager
//
//  Created by 김우성 on 2022/03/23.
//

import SwiftUI

struct Home: View {
    
    @State private var offset: CGFloat = 0
    
    // 다크모드 대응
    @Environment(\.colorScheme) var colorScheme
    
    @State private var currentTab = "Tweets"
    
    // 부드러운 애니메이션효과
    @Namespace var animation
    
    // Tabbar Offset
    @State private var tabBarOffset: CGFloat = 0
    
    // 아래방향으로 스크롤 할 때, offset
    @State private var titleOffset: CGFloat = 0
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false, content: {
            
            VStack(spacing: 15) {
                 
                // HeaderView
                GeometryReader { proxy -> AnyView in
                    
                    // Sticky Header
                    /* minY를 기준으로 헤더의 위치를 판별합니다.  */
                    let minY = proxy.frame(in: .global).minY
                    
                    /* minY를 State 변수에 할당해서, 위치기 변경될때매다, UI를 다시그리도록 합니다. */
                    DispatchQueue.main.async {
                        self.offset = minY
                    }
                    
                    return AnyView(
                        
                        ZStack {
                            
                            Image("banner")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(
                                    width: getRect().width,
                                    height: minY > 0 ? 180 + minY : 180,
                                    alignment: .center
                                )
                                .cornerRadius(0)
                            
                            BlurView()
                                .opacity(blurViewOpacity())
                            
                            // 위로 올라갔을 때, 타이틀 뷰
                            VStack(spacing: 5) {
                                Text("Kavsoft")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text("150 Tweets")
                                    .foregroundColor(.white)
                            }
                            // 위로 슬라이드할 때, 60만큼 더 더해줬음
                            .offset(y: 120)
                            .offset(y: titleOffset > 100 ? 0 : -getTitleOffset())
                            .opacity(titleOffset < 100 ? 1 : 0)
                            
                        }
                            .clipped() // 이걸 해줘야 상단 헤더뷰에서 정보가 나타날 때, 미리 나타나지 않음
                        
                        // Strechy Header
                        .frame(height: minY > 0 ? 180 + minY : nil)
                        /* offset 조건을 다음과 같이 줌으로써, 위로 더이상 올라가지 않습니다. */
                            .offset(y: minY > 0 ? -minY : -minY < 80 ? 0 : -minY - 80)
                        
                    )
                }
                .frame(height: 180)
                .zIndex(1)
                
                // ProfileImage
                VStack {
                    HStack {
                        
                        Image("moya")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 75, height: 75)
                            .clipShape(Circle())
                            .padding(8)
                            .background(
                                colorScheme == .dark ? Color.black : Color.white
                            )
                            .clipShape(Circle())
                            .offset(y: offset < 0 ? getOffset() - 20 : -20)
                            .scaleEffect(getScale())
                            
                        
                        Spacer()
                        
                        Button(action: {}, label: {
                            Text("Edit Profile")
                                .foregroundColor(.blue)
                                .padding(.vertical, 10)
                                .padding(.horizontal)
                                .background(
                                    Capsule()
                                        .stroke(Color.blue, lineWidth: 1.5)
                                )
                        })
                    }
                    .padding(.top, -25)
                    .padding(.bottom, -10)
                    
                    // Profile Data
                    VStack(alignment: .leading, spacing: 8, content: {
                        
                        Text("Uno Kim")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("kipsong133")
                            .foregroundColor(.gray)
                        
                        Text("Kavsoft is a channel where I make videos on SwiftUI Website: https://kavsoft.dev, Patreon: http://patreon.com/kavsoft")
                        
                        HStack(spacing: 5){
                            
                            Text("13")
                                .foregroundColor(.primary)
                                .fontWeight(.semibold)
                            
                            Text("Followers")
                                .foregroundColor(.gray)
                            
                            Text("680")
                                .foregroundColor(.primary)
                                .fontWeight(.semibold)
                                .padding(.leading,10)
                            
                            Text("Following")
                                .foregroundColor(.gray)
                        }
                        .padding(.top,8)
                    })
                        .overlay(
                            GeometryReader { proxy -> Color in
                                
                                let minY = proxy.frame(in: .global).minY
                                
                                DispatchQueue.main.async {
                                    self.titleOffset = minY
                                }
                                return Color.clear
                            }
                                .frame(width: 0, height: 0)
                            , alignment: .top
                        )
                    
                    // Segmented Menu(ViewPager)
                    // 탭바
                    VStack(spacing: 0) {
                        
                        ScrollView(.horizontal, showsIndicators: false, content: {
                            
                            HStack(spacing: 0) {
                                
                                TabButton(
                                    title: "Tweets",
                                    currentTab: $currentTab,
                                    animation: animation
                                )
                                
                                TabButton(
                                    title: "Tweets & Likes",
                                    currentTab: $currentTab,
                                    animation: animation
                                )
                                
                                TabButton(
                                    title: "Media",
                                    currentTab: $currentTab,
                                    animation: animation
                                )
                                
                                TabButton(
                                    title: "Likes",
                                    currentTab: $currentTab,
                                    animation: animation
                                )
                            }
                        })
                        Divider()
                    }
                    .padding(.top, 30)
                    .background(colorScheme == .dark ? Color.black : Color.white)
                    .offset(y: tabBarOffset < 90 ? -tabBarOffset + 90 : 0)
                    .overlay(
                        GeometryReader { reader -> Color in
                            
                            let minY = reader.frame(in: .global).minY
                            
                            DispatchQueue.main.async {
                                self.tabBarOffset = minY
                            }
                            
                            return Color.clear
                        }
                            .frame(width: 0, height: 0)
                        
                        ,alignment: .top
                    )
                    .zIndex(1)
                    
                    VStack(spacing: 30) {
                        
                        // Sample Page
                        // 게시글들
                        TweetView(tweet: "새로나온 아이폰 너무 사고싶다.", tweetImage: "post")
                        Divider()
                        ForEach(1...20, id: \.self) { _ in
                            TweetView(tweet: sampleText)
                            Divider()
                        }
                    }
                    .padding(.top)
                    .zIndex(0)
                    
                }
                .padding(.horizontal)
                // 80이상으로 뷰가 이동하면, 뒤로 이동합니다.
                .zIndex(-offset > 80 ? 0 : 1)
            }
        })
            .ignoresSafeArea(.all, edges: .top)
    }
    
    // Profile이 작아지는 효과를 위한 메소드
    func getOffset() -> CGFloat {
        let progress = (-offset / 80) * 20
        return progress <= 20 ? progress : 20
    }
    
    // 프로필 이미지의 스케일을 조절하는 메소드
    func getScale() -> CGFloat {
        let progress = -offset / 80
        let scale = 1.8 - (progress < 1.0 ? progress : 1)
        
        // 스케일이 작아지더라도 0.8 이하로는 작아지지 않도록 해줍니다.
        return scale < 1 ? scale : 1
    }
    
    // Blur 효과 관련 메소드
    func blurViewOpacity() -> Double {
        let progress = -(offset + 80) / 150
        return Double(-offset > 80 ? progress : 0)
    }
    
    func getTitleOffset() -> CGFloat {
        let progress = 20 / titleOffset
        let offset = 60 * (progress > 0 && progress <= 1 ? progress : 1)
        
        return offset
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .preferredColorScheme(.dark)
    }
}

//
extension View {
    
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
}

// TabButton
struct TabButton: View {
    
    var title: String
    @Binding var currentTab: String
    var animation: Namespace.ID
    
    var body: some View {
        
        Button(action: {
            withAnimation {
                currentTab = title
            }
            
        }, label: {
            // LazyStack으로 하게되면, ScrollView를 꽉채우게됩니다. (아마도 버그)
            LazyVStack(spacing: 14) {

                Text(title)
                    .fontWeight(.semibold)
                    .foregroundColor(currentTab == title ? .blue : .gray)
                    .padding(.horizontal)
                
                if currentTab == title {
                    
                    Capsule()
                        .fill(Color.blue)
                        .frame(height: 1.2)
                        .matchedGeometryEffect(id: "TAB", in: animation)
                    
                } else {
                    Capsule()
                        .fill(Color.clear)
                        .frame(height: 1.2)
                }
            }
            
            
        })
    }
}

struct TweetView: View {
    
    var tweet: String
    var tweetImage: String?
    
    var body: some View {
        HStack (alignment: .top, spacing: 10, content: {
            
            Image("moya")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 55, height: 55)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 10, content: {
                
                (
                    Text("Uno")
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    +
                    
                    Text("@_unokim")
                        .foregroundColor(.gray)
                    
                    
                )
                
                Text(tweet)
                    .frame(maxHeight: 100, alignment: .top)
                
                if let tweetImage = tweetImage {
                    
                    
                    GeometryReader { proxy in
                        Image(tweetImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(
                                width: proxy.frame(in: .global).width,
                                height: 250
                            )
                            .cornerRadius(15)
                    }
                    .frame(height: 250)
                }
            })
        })
    }
}

var sampleText = "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book."

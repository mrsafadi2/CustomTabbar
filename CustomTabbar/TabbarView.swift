//
//  TabbarView.swift
//  CustomTabbar
//
//  Created by Mohammed Safadi Macbook Pro on 21/12/2022.
//

import SwiftUI

struct Item:Hashable , Identifiable , Equatable {
    var id: UUID = UUID()
    var title:String
    var image:String
    
    
}

struct TabbarView: View {
    var tabItems = [Item(title: "Home", image: "house"),
                    Item(title: "Cart", image: "cart") ,
                    Item(title: "Orders", image: "checklist.unchecked") ,
                    Item(title: "Settings", image: "list.bullet") ]
    
    @State var selected:Item = Item(title: "Home", image: "house")
    @State var centerX:CGFloat = 0
    init(){
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        
        VStack {
            TabView(selection: $selected) {
                Color.green
                    .tag(tabItems[0])
                    .ignoresSafeArea(.all , edges: .top)
                Color.red
                    .tag(tabItems[1])
                    .ignoresSafeArea(.all , edges: .top)

                Color.orange
                    .tag(tabItems[2])
                    .ignoresSafeArea(.all , edges: .top)

                Color.yellow
                    .tag(tabItems[3])
                    .ignoresSafeArea(.all , edges: .top)

            }
            
            HStack(spacing: 0){
                ForEach(tabItems) { value in
                    GeometryReader { reader in
                        TabbarButton(selected: $selected , item: value, centerX: $centerX , rect : reader.frame(in: .global)).onAppear(){
                            if value == tabItems.first {
                                centerX = reader.frame(in: .global).midX
                            }
                        }

                    }.frame(width: 70 , height: 50)
                    if value != tabItems.last{Spacer(minLength: 0)}
                }
            }.padding(.horizontal, 20)
                .padding(.top)
                .padding(.bottom , UIApplication.shared.windows.first?.safeAreaInsets.bottom == 0 ? 15 : UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                .background(Color.white.clipShape(AnimatedShap(centerX: centerX)))
                .shadow(color: Color.black.opacity(0.1) ,radius: 5, x: 0 , y: -5)
                .padding(.top ,-20)
        }.ignoresSafeArea(.all ,edges: .bottom)
    }
}

struct TabbarButton: View {
    @Binding var selected:Item
    @State var item:Item
    @Binding var centerX:CGFloat
    var rect:CGRect
    
    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                selected = item
                centerX = rect.midX
            }
        }) {
            VStack{
                Image(systemName: item.image)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(selected.title == item.title ? Color.pink  : Color.gray)
                    .frame(width: 26, height: 26)
                
                Text(item.title)
                    .font(.caption)
                    .foregroundColor(.black)
                    .opacity(selected.title == item.title ? 1: 0)
                
            }.padding(.top).frame(width: 70, height: 50).offset(y : selected == item ? -15 : 0 )
        }
    }
    
}

struct AnimatedShap: Shape {
    var centerX:CGFloat
    var animatableData:CGFloat {
        get{return centerX}
        set{centerX = newValue}
    }
    func path(in rect: CGRect) -> Path {
        return Path{ path in
            path.move(to: CGPoint(x: 0, y: 15))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 15))
            
            path.move(to: CGPoint(x: centerX - 35, y: 15))
            
            path
                .addQuadCurve(to: CGPoint(x: centerX + 35, y: 15), control: CGPoint(x: centerX, y: -30))
        }
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView()
    }
}

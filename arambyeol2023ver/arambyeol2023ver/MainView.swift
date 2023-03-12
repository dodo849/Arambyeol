//
//  MainView.swift
//  arambyeol2023ver
//
//  Created by 김가은 on 2023/03/06.
//

import SwiftUI

struct MainView: View {
    struct CustomGroupBoxStyle : GroupBoxStyle{
        var background: some View {
            RoundedRectangle(cornerRadius: 20).fill(.white).shadow(color: .yellow.opacity(0.5), radius: 5, x: 3, y: 3)
                

            }
        func makeBody(configuration: Configuration) -> some View {
            VStack{
                configuration.label
                configuration.content

            }
            .padding().frame(width:140).background(background)

        }
    }
   @State var buttonColor : [Color] = [.yellow,.white,.white]
    @State var checkDay : Int = 0
    @State var ShowModal : Bool = false
    @State var menu : [TheDayAfterTomorrow] = []
    @State var morningCount = 0
    @State var lunchCount = 0
    @State var dinnerCount = 0
    @State var menuCount = 0
    var body: some View {
        
        NavigationView() {
//                        Color.init(red: 244/255, green: 255/255, blue: 255/255).edgesIgnoringSafeArea(.all)
//                        LinearGradient(
//                            gradient: Gradient(colors: [.white, Color.teal]),
//                          startPoint: UnitPoint(x: 0.2, y: 0.5),
//                          endPoint: .bottomTrailing
//                        ).edgesIgnoringSafeArea(.all)
            VStack(){
                Spacer().frame(height:20).onAppear(){
                    print("실행")
                    
                    
                }
                
                HStack(){
                    Spacer()
                    VStack(){
                        Button("오늘"){
                            buttonColor[0] = .yellow
                            buttonColor[1] = .white
                            buttonColor[2] = .white
                            checkDay = 0
                            morningCount = menu[checkDay].morning.count
                            lunchCount = menu[checkDay].lunch.count
                            dinnerCount = menu[checkDay].dinner.count
                        }.foregroundColor(.black).onAppear(){
                            Task {
                              do {
                                let getmenu =  try await getMenuApi()
                                  if getmenu.count != 0 {
                                      menu = getmenu
                                      morningCount = getmenu[0].morning.count
                                      lunchCount = getmenu[0].lunch.count
                                      dinnerCount = getmenu[0].dinner.count
                                      menuCount = getmenu.count
                                      
                                      var minusMenu = 3-menuCount
                                      for i in 0...(minusMenu-1){
                                          menu.append(TheDayAfterTomorrow(morning: [Dinner(course: "업데이트 예정", menu: [])], lunch:  [Dinner(course: "업데이트 예정", menu: [])], dinner:  [Dinner(course: "업데이트 예정", menu: [])]))
                                      }
                                  }else{
                                      
                                      morningCount = 0
                                      lunchCount = 0
                                      dinnerCount = 0
                                      for i in 0...2{
                                          menu.append(TheDayAfterTomorrow(morning: [Dinner(course: "업데이트 예정", menu: [])], lunch:  [Dinner(course: "업데이트 예정", menu: [])], dinner:  [Dinner(course: "업데이트 예정", menu: [])]))
                                      }
                                  }
                                 
                                 
                              } catch {
                                print(error)
                              }
                            }
                          
                        }
                        Rectangle().fill(buttonColor[0]).frame(width:50,height:4)
                    }.padding()
                   
                    VStack(){
                        Button("내일"){
                            buttonColor[0] = .white
                            buttonColor[1] = .yellow
                            buttonColor[2] = .white
                            checkDay = 1
                            morningCount = menu[checkDay].morning.count
                            lunchCount = menu[checkDay].lunch.count
                            dinnerCount = menu[checkDay].dinner.count
                        }.foregroundColor(.black).onAppear(){
                        }.foregroundColor(.black)
                        Rectangle().fill(buttonColor[1]).frame(width:50,height:4)
                    }.padding()
                 
                    VStack(){
                        Button("모레"){
                            buttonColor[0] = .white
                            buttonColor[1] = .white
                            buttonColor[2] = .yellow
                            checkDay = 2
                            morningCount = menu[checkDay].morning.count
                            lunchCount = menu[checkDay].lunch.count
                            dinnerCount = menu[checkDay].dinner.count
                        }.foregroundColor(.black).onAppear(){
                        }.foregroundColor(.black)
                        Rectangle().fill(buttonColor[2]).frame(width:50,height:4)
                    }.padding()
                    Spacer()
                }
                
                Spacer().frame(height:20)
                ScrollView(.horizontal,showsIndicators: false){
                    HStack(){
                        VStack(){
                            Text("아침").bold().font(.system(size:18)).foregroundColor(.black)
                            GroupBox(){
                                ScrollView(showsIndicators:false){
                                    if morningCount != 0 {
                                        Group(){
                
                                            ForEach(0..<morningCount) { c in
                                                if c < morningCount {
                                                    Text(menu[checkDay].morning[c].course).font(.system(size:16)).bold().padding().foregroundColor(.gray)
                                                   
                                                    ForEach( menu[checkDay].morning[0].menu, id : \.self){ m in
                                                        Text(m).font(.system(size:16))
                                                    }
                                                }
                                                
                                            }
                                          
                                        }
                                    }

                                }
                                
                            }.frame(height: 350).groupBoxStyle(CustomGroupBoxStyle()).padding()
                        }
                        
                        VStack(){
                            Text("점심").bold().font(.system(size:18)).foregroundColor(.black)
                            GroupBox(){
                                ScrollView(showsIndicators:false){

                                    if lunchCount != 0 {
                                        Group(){
                                            ForEach(0..<lunchCount) { c in
                                                if c < morningCount {
                                                    Text(menu[checkDay].lunch[c].course).font(.system(size:16)).bold().padding().foregroundColor(.gray)
                                                    ForEach( menu[checkDay].lunch[c].menu, id : \.self){ m in
                                                        Text(m).font(.system(size:16))
                                                    }
                                                }
                                                
                                                
                                            }
                                            //한식
                                        }
                                    }


                                }

                            }.frame(height : 350 ).groupBoxStyle(CustomGroupBoxStyle()).padding()
                        }
                        
                        VStack(){
                            Text("저녁").bold().font(.system(size:18)).foregroundColor(.black)
                            GroupBox(){
                                ScrollView(showsIndicators:false){
                                    if dinnerCount != 0 {
                                        Group(){
                                            ForEach(0..<dinnerCount) { c in
                                                if c < morningCount {
                                                    Text(menu[checkDay].dinner[c].course).font(.system(size:16)).bold().padding().foregroundColor(.gray)
                                                    ForEach( menu[checkDay].dinner[c].menu, id : \.self){ m in
                                                        Text(m).font(.system(size:16))
                                                    }
                                                }
                                                
                                            }
                                            //한식
                                        }
                                    }


                                }

                            }.frame(height : 350 ).groupBoxStyle(CustomGroupBoxStyle()).padding()
                        }
                      
                    }
                    
                }
                Divider().padding()
                Text("매주 월요일 1시에 식단표가 업데이트 됩니다 !").font(.system(size:11)).foregroundColor(.gray)
                Text(" 상단 오른쪽 아람별 아이콘을 누르면 아람관 운영시간을 확인할 수 있습니다.").font(.system(size:11)).foregroundColor(.gray)
                Text("앱 아람별 문의사항은 13wjdgk@gnu.ac.kr 로 보내주세요 :) ").font(.system(size:11)).foregroundColor(.gray)

                
                Spacer()
                
                
            }
            .navigationBarTitle("아람별",displayMode:.inline)
            .navigationBarItems(trailing:Button(action: {
                ShowModal = true
            }, label: {
                Image("아람별행성").resizable().frame(width:50,height:50).sheet(isPresented: $ShowModal) {
                    TimeTableView()
                }
            }))
        }
        
       
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

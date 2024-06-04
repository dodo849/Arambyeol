//
//  MainView.swift
//  arambyeol2023ver
//
//  Created by 김가은 on 2023/03/06.
//

import SwiftUI
import GoogleMobileAds
struct GADBanner: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let view = GADBannerView(adSize: GADAdSizeBanner)
        let viewController = UIViewController()
        view.adUnitID = "ca-app-pub-2736900311526941/1577970620" // test Key
//        view.adUnitID = "ca-app-pub-3940256099942544/2934735716" // test Key
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: GADAdSizeBanner.size)
        view.load(GADRequest())
        return viewController
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    
    }
}
@ViewBuilder func admob() -> some View {
    // admob
    GADBanner().frame(width: GADAdSizeBanner.size.width, height: GADAdSizeBanner.size.height)
}


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
    
    struct Theme {
        static func myBackgroundColor(forScheme scheme: ColorScheme) -> Color {
            let lightColor = Color.white
            let darckColor = Color.black
            
            switch scheme {
            case .light : return lightColor
            case .dark : return darckColor
            @unknown default: return lightColor
            }
        }
    }
    
    @Environment(\.colorScheme) var scheme
   @State var buttonColor : [Color] = [.yellow,.white,.white]
    @State var checkDay : Int = 0
    @State var ShowModal : Bool = false
    @State var menu : [TheDayAfterTomorrow] = []
    @State var morningCount = 0
    @State var lunchCount = 0
    @State var dinnerCount = 0
    @State var menuCount = 0
    @State var ModeColor = Color.black
   
    @Environment(\.scenePhase) var scenePhase
    var body: some View {
        
        ZStack() {
            Theme.myBackgroundColor(forScheme: scheme).edgesIgnoringSafeArea(.all).onAppear(){
                
            }
            NavigationView() {
                VStack(){
                    Spacer().frame(height:20)
                    HStack(){
                        Spacer()
                        VStack(){
                            Button("오늘"){
                                buttonColor[0] = .yellow
                                buttonColor[1] = .clear
                                buttonColor[2] = .clear
                                checkDay = 0
                                morningCount = menu[checkDay].morning.count
                                lunchCount = menu[checkDay].lunch.count
                                dinnerCount = menu[checkDay].dinner.count
                            }.foregroundColor(ModeColor).onChange(of: scenePhase) { newValue in
                                switch newValue {
                                                case .active:
                                                    print("Active")
                                    if scheme == .light {
                                        ModeColor = Color.black
                                        
                                    }else{
                                        ModeColor = Color.white
                                      
                                    }
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
                                              if minusMenu > 0 {
                                                  for i in 0...(minusMenu-1){
                                                      menu.append(TheDayAfterTomorrow(morning: [Dinner(course: "업데이트 예정", menu: [])], lunch:  [Dinner(course: "업데이트 예정", menu: [])], dinner:  [Dinner(course: "업데이트 예정", menu: [])]))
                                                  }
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
                                                case .inactive:
                                                    print("Inactive")
                                                case .background:
                                                    print("Background")
                                                default:
                                                    print("scenePhase err")
                                            }
                            }.onAppear(){
                                print("appear1")
                              
                            }
                            Rectangle().fill(buttonColor[0]).frame(width:50,height:4)
                        }.padding()
                       
                        VStack(){
                            Button("내일"){
                                buttonColor[0] = .clear
                                buttonColor[1] = .yellow
                                buttonColor[2] = .clear
                                checkDay = 1
                                morningCount = menu[checkDay].morning.count
                                lunchCount = menu[checkDay].lunch.count
                                dinnerCount = menu[checkDay].dinner.count
                            }.foregroundColor(ModeColor).onAppear(){
                            }.foregroundColor(ModeColor)
                            Rectangle().fill(buttonColor[1]).frame(width:50,height:4)
                        }.padding()
                     
                        VStack(){
                            Button("모레"){
                                buttonColor[0] = .clear
                                buttonColor[1] = .clear
                                buttonColor[2] = .yellow
                                checkDay = 2
                                morningCount = menu[checkDay].morning.count
                                lunchCount = menu[checkDay].lunch.count
                                dinnerCount = menu[checkDay].dinner.count
                            }.foregroundColor(ModeColor).onAppear(){
                            }.foregroundColor(ModeColor)
                            Rectangle().fill(buttonColor[2]).frame(width:50,height:4)
                        }.padding()
                        Spacer()
                    }
                    
                    Spacer().frame(height:20)
                    ScrollView(.horizontal,showsIndicators: false){
                        HStack(){
                            VStack(){
                                Text("아침").bold().font(.system(size:18)).foregroundColor(ModeColor)
                                GroupBox(){
                                    ScrollView(showsIndicators:false){
                                        if morningCount != 0 {
                                            Group(){
                    
                                                ForEach(0..<morningCount) { c in
                                                    if c < morningCount {
                                                        Text(menu[checkDay].morning[c].course).font(.system(size:16)).bold().padding().foregroundColor(.gray)
                                                       
                                                        ForEach( menu[checkDay].morning[c].menu, id : \.self){ m in
                                                            Text(m).font(.system(size:16)).foregroundColor(.black)
                                                        }
                                                    }
                                                    
                                                }
                                              
                                            }
                                        }

                                    }
                                    
                                }.frame(height: 350).groupBoxStyle(CustomGroupBoxStyle()).padding()
                            }
                            
                            VStack(){
                                Text("점심").bold().font(.system(size:18)).foregroundColor(ModeColor)
                                GroupBox(){
                                    ScrollView(showsIndicators:false){

                                        if lunchCount != 0 {
                                            Group(){
                                                ForEach(0..<lunchCount) { c in
                                                    if c < lunchCount {
                                                        Text(menu[checkDay].lunch[c].course).font(.system(size:16)).bold().padding().foregroundColor(.gray)
                                                        ForEach( menu[checkDay].lunch[c].menu, id : \.self){ m in
                                                            Text(m).font(.system(size:16)).foregroundColor(.black)
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
                                Text("저녁").bold().font(.system(size:18)).foregroundColor(ModeColor)
                                GroupBox(){
                                    ScrollView(showsIndicators:false){
                                        if dinnerCount != 0 {
                                            Group(){
                                                ForEach(0..<dinnerCount) { c in
                                                    if c < dinnerCount {
                                                        Text(menu[checkDay].dinner[c].course).font(.system(size:16)).bold().padding().foregroundColor(.gray)
                                                        ForEach( menu[checkDay].dinner[c].menu, id : \.self){ m in
                                                            Text(m).font(.system(size:16)).foregroundColor(.black)
                                                        }
                                                    }
                                                    
                                                }
                                              
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
                    
                    NavigationLink("챗뷰") {
                        ChatView()
                    }
                    
                    let webSocketURL = URL(string: "wss://aramchat.kro.kr:443/ws-stomp")!
                    let client = StompClient(url: webSocketURL)
                    Button("연결") {
                        client.connect() { error in
                            if error != nil {
                                print("실패!!! \(error)")
                            }
                        }
                        client.subscribe(topic: "/sub/ArambyeolChat") { result in
                            switch result {
                            case .failure(let error):
                                print(error)
                            case .success(let body):
                                print("받았당: \(body)")
                            }
                        }
                    }

                    Button("보내기") {
                        client.send(
                            topic: "/pub/chat",
                            body: .string("안녕하세용용")) { error in
                                if let error = error {
                                    print("실패!!!")
                                }
                            }
                    }
                    
                    Spacer()
                    admob()
                    
                           
                    
                    
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
        .onAppear {

        }
        
       
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

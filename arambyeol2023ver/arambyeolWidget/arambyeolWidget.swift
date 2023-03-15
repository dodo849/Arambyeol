//
//  arambyeolWidget.swift
//  arambyeolWidget
//
//  Created by 김가은 on 2023/03/07.
//

import WidgetKit
import SwiftUI
var beforeDate : [TheDayAfterTomorrow] = []
var timeUpateCheck : [Bool]  = [true,true,true,true,true,true,true]
var updateTime = false
struct Provider: TimelineProvider {
    func getNewMenu(completion: @escaping ([TheDayAfterTomorrow]) -> ()) {
        let newsAddress: String = "http://3.34.186.94:5000/menu"
        var menu : [TheDayAfterTomorrow] = []
        let task = URLSession.shared.dataTask(with: URL(string: newsAddress)!) { (data, response, errpr) in
            if let jsonData = data {
                if let news = try? JSONDecoder().decode(Welcome.self, from: jsonData) {
                    menu.append(news.today)
                    menu.append(news.tomorrow)
                    menu.append(news.theDayAfterTomorrow)
//                    print("menu : ",menu)
                    completion(menu)
                }else if let Newmenu = try? JSONDecoder().decode(getSatMenu.self, from: jsonData){
                    menu.append(Newmenu.today)
                    menu.append(Newmenu.tomorrow)
//                    print("menu : ",menu)
                    completion(menu)
                }else if let Newmenu = try? JSONDecoder().decode(getSunMenu.self, from: jsonData){
                    menu.append(Newmenu.today)
                    menu.append(TheDayAfterTomorrow(morning: [], lunch: [], dinner: []))
//                    print("menu : ",menu)
                    completion(menu)
                }
            }
        }
        task.resume()
    }
    
    func placeholder(in context: Context) -> SimpleEntry {

        return SimpleEntry(date: Date(),menu: [],morning: [],lunch: [],dinner: [])
        
        
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
//        let entry = SimpleEntry(date: Date(),menu: [],morning: [],lunch: [],dinner: [])
        let entry =  SimpleEntry(date: Date(),menu: [],morning: [],lunch: [],dinner: [])
        completion(entry)
//        getNewMenu { (menu) in
//            let entry = SimpleEntry(date: Date(),menu: menu ,morning: menu[0].morning,lunch: menu[0].lunch,dinner: menu[0].dinner)
//            completion(entry)
//
//        }

        
        
    }
  
    // 데이터를 언제 리프레시 할지 결정
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
        let getHour = Calendar.current.dateComponents([.hour], from: currentDate).hour ?? 0
        let getMinut = Calendar.current.dateComponents([.minute], from: currentDate).minute ?? 0
        if beforeDate.count == 0  {
            getNewMenu { menu in
                beforeDate = menu
                let entry = SimpleEntry(date: currentDate,menu: menu ,morning: menu[0].morning,lunch: menu[0].lunch,dinner: menu[0].dinner)
                let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                completion(timeline)
            }
        }else{
            if getHour == 0 && timeUpateCheck[0] {
                getNewMenu { menu in
                    beforeDate = menu
                    let entry = SimpleEntry(date: currentDate,menu: menu ,morning: menu[0].morning,lunch: menu[0].lunch,dinner: menu[0].dinner)
                    let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                    timeUpateCheck[0] = false
                    timeUpateCheck[1] = true
                    timeUpateCheck[2] = true
                    timeUpateCheck[3] = true
                    timeUpateCheck[4] = true
                    timeUpateCheck[5] = true
                    
                    
                    completion(timeline)
                }
            }else if getHour == 3 && timeUpateCheck[1] {
                getNewMenu { menu in
                    beforeDate = menu
                    let entry = SimpleEntry(date: currentDate,menu: menu ,morning: menu[0].morning,lunch: menu[0].lunch,dinner: menu[0].dinner)
                    let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                    timeUpateCheck[0] = true
                    timeUpateCheck[1] = false
                    timeUpateCheck[2] = true
                    timeUpateCheck[3] = true
                    timeUpateCheck[4] = true
                    timeUpateCheck[5] = true
                    
                    completion(timeline)
                }
            }
            else if getHour == 6 && timeUpateCheck[2] {
                getNewMenu { menu in
                    beforeDate = menu
                    let entry = SimpleEntry(date: currentDate,menu: menu ,morning: menu[0].morning,lunch: menu[0].lunch,dinner: menu[0].dinner)
                    let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                    timeUpateCheck[0] = true
                    timeUpateCheck[1] = false
                    timeUpateCheck[2] = true
                    timeUpateCheck[3] = true
                    timeUpateCheck[4] = true
                    timeUpateCheck[5] = true
                    
                    completion(timeline)
                }
            }else if getHour == 10 && timeUpateCheck[3] {
                getNewMenu { menu in
                    beforeDate = menu
                    let entry = SimpleEntry(date: currentDate,menu: menu ,morning: menu[0].morning,lunch: menu[0].lunch,dinner: menu[0].dinner)
                    let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                    timeUpateCheck[0] = true
                    timeUpateCheck[1] = true
                    timeUpateCheck[2] = true
                    timeUpateCheck[3] = false
                    timeUpateCheck[4] = true
                    timeUpateCheck[5] = true
                    
                    completion(timeline)
                }
            }
            else if getHour == 14 && timeUpateCheck[4] {
            getNewMenu { menu in
                beforeDate = menu
                let entry = SimpleEntry(date: currentDate,menu: menu ,morning: menu[0].morning,lunch: menu[0].lunch,dinner: menu[0].dinner)
                let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                timeUpateCheck[0] = true
                timeUpateCheck[1] = true
                timeUpateCheck[2] = true
                timeUpateCheck[3] = true
                timeUpateCheck[4] = false
                timeUpateCheck[5] = true
                
                completion(timeline)
            }
        }else if getHour == 19 && timeUpateCheck[5] {
            getNewMenu { menu in
                beforeDate = menu
                let entry = SimpleEntry(date: currentDate,menu: menu ,morning: menu[0].morning,lunch: menu[0].lunch,dinner: menu[0].dinner)
                let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                timeUpateCheck[0] = true
                timeUpateCheck[1] = true
                timeUpateCheck[2] = true
                timeUpateCheck[3] = true
                timeUpateCheck[4] = true
                timeUpateCheck[5] = false
                
                completion(timeline)
            }
        }
        else {
                if getHour > 20 {
                    timeUpateCheck[0] = true
                    timeUpateCheck[1] = true
                    timeUpateCheck[2] = true
                    timeUpateCheck[3] = true
                    timeUpateCheck[4] = true
                    timeUpateCheck[5] = true
                }
                let entry = SimpleEntry(date: currentDate,menu: beforeDate ,morning: beforeDate[0].morning,lunch: beforeDate[0].lunch,dinner: beforeDate[0].dinner)
               let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
               completion(timeline)
            }
            
        }
        
       
        
        //원본
//        getNewMenu { menu in
//            var entries: [SimpleEntry] = []
//
//            // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//            let currentDate = Date()
//            for hourOffset in 0 ..< 5 {
//                let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
//                let entry = SimpleEntry(date: entryDate,menu: menu ,morning: menu[0].morning,lunch: menu[0].lunch,dinner: menu[0].dinner)
//                entries.append(entry)
//            }
//
//            let timeline = Timeline(entries: entries, policy: .atEnd)
//            completion(timeline)
//        }
       

        
    }
}

// MARK: - Welcome
struct Welcome: Codable {
    let today, tomorrow, theDayAfterTomorrow: TheDayAfterTomorrow
}
struct getSatMenu: Codable {
    let today, tomorrow: TheDayAfterTomorrow
}
struct getSunMenu: Codable {
    let today: TheDayAfterTomorrow
}

// MARK: - TheDayAfterTomorrow
struct TheDayAfterTomorrow: Codable {
    let morning, lunch, dinner: [Dinner]
}

// MARK: - Dinner
struct Dinner: Codable {
    let course: String
    let menu: [String]
}

struct SimpleEntry: TimelineEntry {
    var date: Date
    var menu : [TheDayAfterTomorrow]
    var morning : [Dinner]
    var lunch : [Dinner]
    var dinner : [Dinner]
//    var todayMorning : Int
//    var todayLunch : Int
//    var todayDinner : Int
//    var tomMorning : Int
//    var tomLunch : Int
//    var tomDinner : Int
//    var datMorning : Int
//    var datLunch : Int
//    var datDinner : Int
}

func getKORTime() -> DateFormatter {
    let date: DateFormatter = {
            let df = DateFormatter()
            df.locale = Locale(identifier: "ko_KR")
            df.timeZone = TimeZone(abbreviation: "KST")
            df.dateFormat = "HH:mm"
            return df
        }()
    var nowString = Date()
    
    var DateToString = date.string(from: Date())
    print("placeholder : ",date.string(from: nowString))
    return date
//    return date.string(from: nowString)
}
func getNowDateTime24(now : Date) -> String {
        // [date 객체 사용해 현재 날짜 및 시간 24시간 형태 출력 실시]
        let nowDate = now // 현재의 Date 날짜 및 시간
        let dateFormatter = DateFormatter() // Date 포맷 객체 선언
        dateFormatter.locale = Locale(identifier: "ko") // 한국 지정
        
        dateFormatter.dateFormat = "MM월 dd일 E요일" // Date 포맷 타입 지정
        let date_string = dateFormatter.string(from: nowDate) // 포맷된 형식 문자열로 반환

        return date_string
    }
struct arambyeolWidgetEntryView : View {
    @State var entry: Provider.Entry
    @State var tomCheck = false
    @Environment(\.widgetFamily) var family: WidgetFamily
    @State var time : Int = 2
    @Environment(\.scenePhase) var scenePhase
    var body: some View {
        switch self.family {
        case .systemSmall :
            
            VStack() {
                HStack() {
                    Text("\(getNowDateTime24(now : entry.date))").bold().font(.system(size:10)).padding(EdgeInsets(top: 8, leading: 10, bottom: 2, trailing: 5))
                    Group(){
                        if (Calendar.current.dateComponents([.hour], from: entry.date).hour ?? 0) < 9 {
                            Text("아침").bold().font(.system(size:10)).padding(EdgeInsets(top: 8, leading: 5, bottom: 2, trailing: 10)).onAppear(){
                                time = 0
                                tomCheck = false
                            }
                        }
                        else if (Calendar.current.dateComponents([.hour], from: entry.date).hour ?? 0) == 9 {
                            if (Calendar.current.dateComponents([.minute], from: entry.date).minute ?? 0) > 30 {
                                Text("점심").bold().font(.system(size:10)).padding(EdgeInsets(top: 8, leading: 5, bottom: 2, trailing: 10)).onAppear(){
                                    time = 1
                                    tomCheck = false
                                }
                            }else {
                                Text("아침").bold().font(.system(size:10)).padding(EdgeInsets(top: 8, leading: 5, bottom: 2, trailing: 10)).onAppear(){
                                    time = 0
                                    tomCheck = false
                                    //
                                }
                            }
                        }
                        else if (Calendar.current.dateComponents([.hour], from: entry.date).hour ?? 0) < 13 {
                            Text("점심").bold().font(.system(size:10)).padding(EdgeInsets(top: 8, leading: 5, bottom: 2, trailing: 10)).onAppear(){
                                time = 1
                                tomCheck = false
                                //
                            }
                        }
                        else if (Calendar.current.dateComponents([.hour], from: entry.date).hour ?? 0) == 13 {
                            if (Calendar.current.dateComponents([.minute], from: entry.date).minute ?? 0) > 30 {
                                Text("저녁").bold().font(.system(size:10)).padding(EdgeInsets(top: 8, leading: 5, bottom: 2, trailing: 10)).onAppear(){
                                    time = 2
                                    tomCheck = false
//
                                }
                            }else {
                                Text("점심").bold().font(.system(size:10)).padding(EdgeInsets(top: 8, leading: 5, bottom: 2, trailing: 10)).onAppear(){
                                    time = 1
                                    tomCheck = false
                                    //
                                }
                            }
                        }
                        else if (Calendar.current.dateComponents([.hour], from: entry.date).hour ?? 0) < 19 {
                            Text("저녁").bold().font(.system(size:10)).padding(EdgeInsets(top: 8, leading: 5, bottom: 2, trailing: 10)).onAppear(){
                                time = 2
                                tomCheck = false
                            }
                        }else{
                            Text("내일 아침").bold().font(.system(size:10)).padding(EdgeInsets(top: 8, leading: 5, bottom: 2, trailing: 10)).onAppear(){
                                time = 4
                                tomCheck = true
                                entry.date = Date(timeIntervalSinceNow:60*60*24)
                                entry.morning = entry.menu[1].morning
                                entry.lunch = entry.menu[1].lunch
                                entry.dinner = entry.menu[1].dinner
                            }
                        }

                        
                    }
                    

                }

                HStack(){
                    Group(){
                        if time == 0 {
                            ForEach(0..<entry.morning.count){ i in
                                VStack(){
                                    Text(entry.morning[i].course).bold().font(.system(size:10))
                                    ForEach(entry.morning[i].menu , id : \.self){ m in
                                        Text(m).font(.system(size:10))
                                    }
                                
                                    Spacer()
                                }
//                                if i != entry.morning.count-1 {
//                                    Divider()
//                                }

                            }
                        }
                        else if time == 1{
                            ForEach(0..<entry.lunch.count){ i in
                                VStack(){
                                    Text(entry.lunch[i].course).bold().font(.system(size:10))
                                    ForEach(entry.lunch[i].menu , id : \.self){ m in
                                        Text(m).font(.system(size:10))
                                    }

                                    Spacer()
                                }
                               
    //



                            }
                        } else if time == 4{
                            ForEach(0..<entry.menu[1].morning.count){ i in
                                VStack(){
                                    Text(entry.menu[1].morning[i].course).bold().font(.system(size:10))
                                    ForEach(entry.morning[i].menu , id : \.self){ m in
                                        Text(m).font(.system(size:10))
                                    }

                                    Spacer()
                                }
    //
                              
                                

                            }
                        }
                        else{
                            ForEach(0..<entry.dinner.count){ i in
                                VStack(){
                                    Text(entry.dinner[0].course).bold().font(.system(size:10))
                                    ForEach(entry.dinner[0].menu , id : \.self){ m in
                                        Text(m).font(.system(size:10))
                                    }

                                    Spacer()
                                }
    //
                              
                                

                            }
                        }
                    }

                }


                Spacer()
                
            }
   
        case .systemMedium:

            VStack() {
                HStack() {
                    Text("\(getNowDateTime24(now : entry.date))").bold().font(.system(size:12)).padding(EdgeInsets(top: 8, leading: 10, bottom: 2, trailing: 10))
                    Group(){
                        if (Calendar.current.dateComponents([.hour], from: entry.date).hour ?? 0) < 9 {
                            Text("아침").bold().font(.system(size:11)).padding(EdgeInsets(top: 8, leading: 10, bottom: 2, trailing: 10)).onAppear(){
                                time = 0
                                tomCheck = false
                            }
                        }
                        else if (Calendar.current.dateComponents([.hour], from: entry.date).hour ?? 0) == 9 {
                            if (Calendar.current.dateComponents([.minute], from: entry.date).minute ?? 0) > 30 {
                                Text("점심").bold().font(.system(size:11)).padding(EdgeInsets(top: 8, leading: 10, bottom: 2, trailing: 10)).onAppear(){
                                    time = 1
                                    tomCheck = false
                                }
                            }else {
                                Text("아침").bold().font(.system(size:11)).padding(EdgeInsets(top: 8, leading: 10, bottom: 2, trailing: 10)).onAppear(){
                                    time = 0
                                    tomCheck = false
                                    //
                                }
                            }
                        }
                        else if (Calendar.current.dateComponents([.hour], from: entry.date).hour ?? 0) < 13 {
                            Text("점심").bold().font(.system(size:11)).padding(EdgeInsets(top: 8, leading: 10, bottom: 2, trailing: 10)).onAppear(){
                                time = 1
                                tomCheck = false
                                //
                            }
                        }
                        else if (Calendar.current.dateComponents([.hour], from: entry.date).hour ?? 0) == 13 {
                            if (Calendar.current.dateComponents([.minute], from: entry.date).minute ?? 0) > 30 {
                                Text("저녁").bold().font(.system(size:11)).padding(EdgeInsets(top: 8, leading: 10, bottom: 2, trailing: 10)).onAppear(){
                                    time = 2
                                    tomCheck = false
//
                                }
                            }else {
                                Text("점심").bold().font(.system(size:11)).padding(EdgeInsets(top: 8, leading: 10, bottom: 2, trailing: 10)).onAppear(){
                                    time = 1
                                    tomCheck = false
                                    //
                                }
                            }
                        }
                        else if (Calendar.current.dateComponents([.hour], from: entry.date).hour ?? 0) < 19 {
                            Text("저녁").bold().font(.system(size:11)).padding(EdgeInsets(top: 8, leading: 10, bottom: 2, trailing: 10)).onAppear(){
                                time = 2
                                tomCheck = false
                            }
                        }else{
                            Text("내일 아침").bold().font(.system(size:11)).padding(EdgeInsets(top: 8, leading: 10, bottom: 2, trailing: 10)).onAppear(){
                                time = 4
                                tomCheck = true
                                entry.date = Date(timeIntervalSinceNow:60*60*24)
                                entry.morning = entry.menu[1].morning
                                entry.lunch = entry.menu[1].lunch
                                entry.dinner = entry.menu[1].dinner
                            }
                        }

                        
                    }
                    

                }
               
                HStack(){
                    if time == 0 {
                        ForEach(0..<entry.morning.count){ i in
                            VStack(){
                                Text(entry.morning[i].course).bold().font(.system(size:11))
                                ForEach(entry.morning[i].menu , id : \.self){ m in
                                    Text(m).font(.system(size:11))
                                }

                                Spacer()
                            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 2, trailing: 10))
//                            if i != entry.morning.count-1{
//                                Divider()
//                            }
                        }
                    }
                   else if time == 1{
                        ForEach(0..<entry.lunch.count){ i in
                            VStack(){
                                Text(entry.lunch[i].course).bold().font(.system(size:12))
                                ForEach(entry.lunch[i].menu , id : \.self){ m in
                                    Text(m).font(.system(size:12))
                                }

                                Spacer()
                            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 2, trailing: 10))
                            
                        }
                    }else if time == 4{
                        ForEach(0..<entry.menu[1].morning.count){ i in
                            VStack(){
                                Text(entry.menu[1].morning[i].course).bold().font(.system(size:10))
                                ForEach(entry.morning[i].menu , id : \.self){ m in
                                    Text(m).font(.system(size:10))
                                }

                                Spacer()
                            }
//
                          
                            

                        }
                    }
                    else{
                       
                        ForEach(0..<entry.dinner.count){ i in
                            VStack(){
                                Text(entry.dinner[0].course).bold().font(.system(size:12))
                                ForEach(entry.dinner[0].menu , id : \.self){ m in
                                    Text(m).font(.system(size:12))
                                }

                                Spacer()
                            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 2, trailing: 10))
                           
                    
                        }
                        
                    }
                }


                Spacer()

            }
        case .systemLarge:

            VStack(alignment:.leading) {

                if  (Calendar.current.dateComponents([.hour], from: entry.date).hour ?? 0) >= 19  {
                                    HStack() {
                                       Spacer()
                    
                                        Text("\(getNowDateTime24(now : entry.date)) 내일").bold().font(.system(size:12)).onAppear(){
                                            entry.morning = entry.menu[1].morning
                                            entry.lunch = entry.menu[1].lunch
                                            entry.dinner = entry.menu[1].dinner
                                            time = 4
                                            tomCheck = true
                                            entry.date = Date(timeIntervalSinceNow:60*60*24)
                                        }
                                        Spacer()
                    
                                    }.padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                                       
                                       VStack(){
                                           HStack(){
                                               Text("아침").bold().font(.system(size:12)).padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 1))
                                               Spacer()
                                          
                                               ForEach(0..<entry.menu[1].morning.count){ i in
                                                   VStack(){
                                                       Text("\(entry.morning[i].course)").bold().font(.system(size:10))
                                                       ForEach(entry.morning[i].menu , id : \.self){ m in
                                                           Text(m).font(.system(size:10))
                                                       }
                                                       Spacer()


                                                   }
                                                   if i != entry.menu[1].morning.count-1 {
                                                       Divider()
                                                   }
                       //
                                               }
                                               Spacer()

                                           }
                                           Divider()
                                           HStack(){
                                               Text("점심").bold().font(.system(size:12)).padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 1))
                                               Spacer()

                                               ForEach(0..<entry.menu[1].lunch.count){ i in
                                                   VStack(){
                                                       if entry.lunch[i].course != ""{
                                                           Text(entry.lunch[i].course).bold().font(.system(size:10))
                                                       }
                                                       
                                                       ForEach(entry.lunch[i].menu , id : \.self){ m in
                                                           Text(m).font(.system(size:10))
                                                       }
                                                     

                                                   }
                                                   if i != entry.menu[1].lunch.count-1 {
                                                       Divider()
                                                   }



                                               }
                                               Spacer()

                                           }
                                           Divider()
                                           HStack(){
                                               Text("저녁").bold().font(.system(size:12)).padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 1))
                                               Spacer()

                                               ForEach(0..<entry.menu[1].dinner.count){ i in
                                                   VStack(){
                                                       if entry.dinner[i].course != ""{
                                                           Text(entry.dinner[i].course).bold().font(.system(size:10))
                                                       }
                                                       
                                                       ForEach(entry.dinner[i].menu , id : \.self){ m in
                                                           Text(m).font(.system(size:10))
                                                       }

                                                       Spacer()

                                                   }
                                                   if i != entry.menu[1].dinner.count-1 {
                                                       Divider()
                                                   }
                                               }
                                               Spacer()

                                           }
                                

                                       }
                }else{
                    HStack() {
                       Spacer()
    
                        Text("\(getNowDateTime24(now : entry.date)) 아람").bold().font(.system(size:12))
                        Spacer()
    
                    }.padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                    VStack(){
                        HStack(){
                            Text("아침").bold().font(.system(size:12)).padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 1))
                            Spacer()
                       
                            ForEach(0..<entry.morning.count){ i in
                                VStack(){
                                    Text("\(entry.morning[i].course)").bold().font(.system(size:10))
                                    ForEach(entry.morning[i].menu , id : \.self){ m in
                                        Text(m).font(.system(size:10))
                                    }
                                    Spacer()

                                }
                                if i != entry.morning.count-1 {
                                    Divider()
                                }
    //
                            }
                            Spacer()

                        }
                        Divider()
                        HStack(){
                            Text("점심").bold().font(.system(size:12)).padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 1))
                            Spacer()

                            ForEach(0..<entry.lunch.count){ i in
                                VStack(){
                                    if entry.lunch[i].course != "" {
                                        Text("\(entry.lunch[i].course)").bold().font(.system(size:10))
                                    }
                                    
                                    ForEach(entry.lunch[i].menu , id : \.self){ m in
                                        Text(m).font(.system(size:10))
                                    }

                                    
                                }
                                if i != entry.lunch.count-1 {
                                    Divider()
                                }



                            }
                            Spacer()

                        }
                        //
                        
                        Divider()
                        HStack(){
                            Text("저녁").bold().font(.system(size:12)).padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 1))
                            Spacer()
                            
                            ForEach(0..<entry.dinner.count){ i in
                                VStack(){
                                    if entry.dinner[i].course != "" {
                                        Text(entry.dinner[i].course).bold().font(.system(size:10))
                                    }
                                    
                                    ForEach(entry.dinner[i].menu , id : \.self){ m in
                                        Text(m).font(.system(size:10))
                                    }
                                    Spacer()
                                    
                                    
                                }
                                if i != entry.dinner.count-1 {
                                    Divider()
                                }
                            }
                            Spacer()
                        }

                        
                        //
                        
                    }
                    
                    
                }


                Spacer()

            }

        case .systemExtraLarge: // ExtraLarge는 iPad의 위젯에만 표출
          Text("nope")
        @unknown default:
          Text(".systemMedium")
        }
            
            
        
        
    }
}

@main
struct arambyeolWidget: Widget {
    let kind: String = "arambyeolWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            arambyeolWidgetEntryView(entry: entry, time: 0)
        }
        .configurationDisplayName("아람별")
        .description("아람별 식단 위젯")
    }
}

struct arambyeolWidget_Previews: PreviewProvider {
    static var previews: some View {
        arambyeolWidgetEntryView(entry: SimpleEntry(date: Date(),menu: [],morning: [],lunch: [],dinner: []), time: 0)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

//
//  API.swift
//  arambyeol2023ver
//
//  Created by 김가은 on 2023/03/07.
//

import Foundation
// MARK: Async & Await
// MARK: Async & Await
func getMenuApi() async throws -> [TheDayAfterTomorrow] {
    var Menus : [TheDayAfterTomorrow] = []
  let url = NSURL(string: "http://arambyeol.kro.kr/menu")
    let (data, _) = try await URLSession.shared.data(from: (url ?? NSURL(string:"http://arambyeol.kro.kr/menu"))! as URL)
    if let result = try? JSONDecoder().decode(Welcome.self, from: data) {
        Menus.append(result.today)
        Menus.append(result.tomorrow)
        Menus.append(result.theDayAfterTomorrow)
    }else if let result = try? JSONDecoder().decode(getSatMenu.self, from: data) {
        Menus.append(result.today)
        Menus.append(result.tomorrow)
       
    }else if let result = try? JSONDecoder().decode(getSunMenu.self, from: data) {
        Menus.append(result.today)
    }
  
  return Menus
}
//func getNewMenu(completion: @escaping ([TheDayAfterTomorrow]) -> ()) {
//    let newsAddress: String = "http://3.34.186.94:5000/menu"
//    var menu : [TheDayAfterTomorrow] = []
//    let task = URLSession.shared.dataTask(with: URL(string: newsAddress)!) { (data, response, errpr) in
//        if let jsonData = data {
//            if let news = try? JSONDecoder().decode(Welcome.self, from: jsonData) {
//                menu.append(news.today)
//                menu.append(news.tomorrow)
//                menu.append(news.theDayAfterTomorrow)
////                    print("menu : ",menu)
//                completion(menu)
//            }else if let Newmenu = try? JSONDecoder().decode(getSatMenu.self, from: jsonData){
//                menu.append(Newmenu.today)
//                menu.append(Newmenu.tomorrow)
////                    print("menu : ",menu)
//                completion(menu)
//            }
//        }
//    }
//    task.resume()
//}




func getMenuApis() async throws -> [TheDayAfterTomorrow] {
    var menuList : [TheDayAfterTomorrow] = []
    let url = NSURL(string: "https://43.201.37.66:5000/menu")
    let session = try await URLSession(configuration: .default)
    let task =  session.dataTask(with: url! as URL) { data, response, error in
              if let error = error{
                  print(error.localizedDescription)
                  return
              }
              guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
                  // 실패
                  return
              }
              guard let data = data else{
                  return
              }
              do{
                  print("실행1")
                  let apiResponse = try JSONDecoder().decode(Welcome.self, from: data)
                  print("실행2")
                  menuList.append(apiResponse.today)
                  menuList.append(apiResponse.tomorrow)
                  menuList.append(apiResponse.theDayAfterTomorrow)
                  print(menuList)
              }catch(let err){
                  print("메뉴 api 에러남")
                  print(err.localizedDescription)
              }
          }
          task.resume()
    return menuList
}
//
//func getMenu( ) -> [menu_day] {
//    
//    var Menu_list : [menu_day] = []
//    var result_B = false
//
//    let url = URL(string: "http://43.201.37.66:5000/menu")
////    var request = URLRequest(url: url!)
//    let session = URLSession(configuration: .default)
//          
//    let task = session.dataTask(with: url!) { data, response, error in
//              if let error = error{
//                  print(error.localizedDescription)
//                  return
//              }
//              guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
//                  // 실패
//                  return
//              }
//              guard let data = data else{
//                  return
//              }
//              do{
//                  let apiResponse = try JSONDecoder().decode(get_Menus.self, from: data)
//                  let api_day = [apiResponse.월,apiResponse.화,apiResponse.수,apiResponse.목,apiResponse.금,apiResponse.토,apiResponse.일]
////                  Menu_list = []
//                  
//                  for day in api_day{
//                      // 하루 메뉴 저장할 변수
//                      let menu_day = menu_day()
//                      // 코스 저장 변수
//                      var course = day.morning[0].course ?? ""
//                    
//                      //아침 메뉴 목록 리스트에 저장
//                      var course_list = menu_course()
//                      
//                      for m in day.morning {
//                
//                          //코스끼리 모아서 리스트에 저장
//                          if m.course == course {
//                              course_list.courseList.append(menu_info(menu_id: m.menu_id, menu_name: m.menu, score: m.score, course: m.course))
//                              
//                          }else{
//                              menu_day.morning.append(course_list)
//                              course = m.course
//                              course_list = menu_course()
//                              course_list.courseList.append(menu_info(menu_id: m.menu_id, menu_name: m.menu, score: m.score, course: m.course))
//                          }
//                          
//                        
//                      }
//                      menu_day.morning.append(course_list)
//                      //점심 메뉴 저장
//                      course = day.lunch[0].course ?? ""
//                      course_list = menu_course()
//                      for m in day.lunch {
//                          
//                          //코스끼리 모아서 리스트에 저장
//                          if m.course == course {
//                              course_list.courseList.append(menu_info(menu_id: m.menu_id, menu_name: m.menu, score: m.score, course: m.course))
//                              
//                          }else{
//                              menu_day.lunch.append(course_list)
//                              course = m.course
//                              course_list = menu_course()
//                              course_list.courseList.append(menu_info(menu_id: m.menu_id, menu_name: m.menu, score: m.score, course: m.course))
//                          }
//                        
//                      }
//                      menu_day.lunch.append(course_list)
//                      //저녁 메뉴 저장
//                      course = day.dinner[0].course ?? ""
//                      course_list = menu_course()
//                      for m in day.dinner {
//                          //코스끼리 모아서 리스트에 저장
//                          if m.course == course {
//                              course_list.courseList.append(menu_info(menu_id: m.menu_id, menu_name: m.menu, score: m.score, course: m.course))
//                              
//                          }else{
//                              menu_day.dinner.append(course_list)
//                              course = m.course
//                              course_list = menu_course()
//                              course_list.courseList.append(menu_info(menu_id: m.menu_id, menu_name: m.menu, score: m.score, course: m.course))
//                          }
//                        
//                      }
//                      menu_day.dinner.append(course_list)
//                      Menu_list.append(menu_day)
//                  }
////                  for Menu in Menu_list{
////                      for mini in Menu.morning{
////                          for info in mini.courseList{
////                              print("\(info.course): \(info.menu_name)")
////                          }
////
////                      }
////                      print("------------------")
////                      for mini in Menu.lunch{
////                          for info in mini.courseList{
////                              print("\(info.course): \(info.menu_name)")
////                          }
////
////                      }
////                      print("------------------")
////                      for mini in Menu.dinner{
////                          for info in mini.courseList{
////                              print("\(info.course): \(info.menu_name)")
////                          }
////
////                      }
////                      print("==============================")
////                  }
//////                  print("Menu_list ===============\(Menu_list)")
//                 
// 
//                  
//              }catch(let err){
//                  print("메뉴 api 에러남")
//                  print(err.localizedDescription)
//              }
//          }
//          task.resume()
//    
//sleep(3)
// return Menu_list
//}

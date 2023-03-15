//
//  TimeTableView.swift
//  arambyeol2023ver
//
//  Created by 김가은 on 2023/03/07.
//

import SwiftUI

struct TimeTableView: View {
    @Environment(\.colorScheme) var scheme
    @State var textColor = Color.white
    var body: some View {
            VStack(){
                Text("아람 시간표").bold().foregroundColor(textColor).onAppear(){
                    if scheme == .light {
                        textColor = Color.black
                    }else{
                        textColor = Color.white
                    }
                }
                HStack(){
                    Text("평일").padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    VStack(alignment:.leading){
                        HStack(){
                            Text("아침").padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                            Text("7시 30분  -  9시")
                        }
                        HStack(){
                            Text("Take out").padding(EdgeInsets(top: 3, leading: 20, bottom: 0, trailing: 20))
                            Text("8시 30분  -  9시 30분")
                        }
                        HStack(){
                            Text("점심").padding(EdgeInsets(top: 3, leading: 20, bottom: 0, trailing: 20))
                            Text("11시 30분  -  13시 30분")
                        }
                        HStack(){
                            Text("저녁").padding(EdgeInsets(top: 3, leading: 20, bottom: 0, trailing: 20))
                            Text("17시 30분  -  19시")
                        }

                    }

                    Spacer()
                }.padding().foregroundColor(textColor)
                HStack(){
                    Text("주말").padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    VStack(alignment:.leading){
                        HStack(){
                            Text("아침").padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                            Text("8시  -  9시")
                        }
                        HStack(){
                            Text("점심").padding(EdgeInsets(top: 3, leading: 20, bottom: 0, trailing: 20))
                            Text("12시  -  13시 30분")
                        }
                        HStack(){
                            Text("저녁").padding(EdgeInsets(top: 3, leading: 20, bottom: 0, trailing: 20))
                            Text("17시 30분  -  18시 40분")
                        }

                    }

                    Spacer()
                }.padding().foregroundColor(textColor)
            }.font(.system(size:15))
    }
}

struct TimeTableView_Previews: PreviewProvider {
    static var previews: some View {
        TimeTableView()
    }
}

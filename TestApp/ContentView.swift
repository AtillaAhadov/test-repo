//
//  ContentView.swift
//  TestApp
//
//  Created by Atilla Ahadov on 27.12.2022.
//
/*
 
 - сделать и добавить в viewcontroller такой UI сделанный любым способом: programm_view, storyboards
 - график брать отсюда - https://job-server.net/images/padacura/score/44.png, где циферка должна меняться при помощи кнопок под этой кастомной вьюхой, и соответственно картинка должна перезагружаться тоже
 - сделать нажатие на график (картинку графика) и переход на экран написанный полностью на swiftui, то есть и график, и сам экран, он должен быть идентичен предыдущему, кроме перехода
 - все блоки слева, и снизу - это текстовые поля, там везде должен быть текст Hello World
 - на втором экране должна быть возможность вернуться назад к самому первому
 - блоки разноцветные слева должны быть по высоте такие же как и белые линии на графике, то есть снизу вверх по пропорциям наверное

 срок: 10 часов. Если по заданию что-то не понятно - спрашивайте, я не кусаюсь) но если это не касается деталей реализации
 
 */

import Charts
import SwiftUI

var dayArray: Array<Int> = []
var scoreArray: Array<Double> = []


class Item: Identifiable {
    
    let id = UUID()
    let day: Int
    let score: Double
    
    init(day: Int, score: Double) {
        self.day = day
        self.score = score
        scoreArray.append(score)
        dayArray.append(day)
    }
    
}



struct TestView: View {
    
    // MARK: PROPERTIES
    
    @State var progress: [Item] = [
        Item(day: 1, score: 1),
        Item(day: 2, score: 1.3),
        Item(day: 3, score: 2),
        Item(day: 4, score: 6),
        Item(day: 5, score: 7),
        Item(day: 6, score: 7)
    ]
    
    @State var currentX: CGFloat = 10
    @State var currentY: CGFloat = 10
    @State var chosenDay: Int = 1
    @State var width: CGFloat = 0
    @State var height: CGFloat = 0
    @State var textFieldText: String = ""
    
    
    // MARK: BODY
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        
                        // Naming every white horisontal line 'Hello World'
                        VStack {
                            Spacer()
                            
                            VStack {
                                Text("Hello")
                                Text("World")
                            }
                            .font(.footnote)
                            
                            
                            Spacer()
                            
                            VStack {
                                Text("Hello")
                                Text("World")
                            }
                            .font(.footnote)
                            
                            Spacer()
                            
                            VStack {
                                Text("Hello")
                                Text("World")
                            }
                            .font(.footnote)
                            
                            Spacer()
                        }
                        .padding()
                        
                        // Creating a view for the chart and the text field
                        VStack {
                            
                            // Making the chart clickable
                            NavigationLink {
                                CopyTestView(progress: $progress)
                            } label: {
                                
                                ZStack {
                                    // Initializing geometry reader to trace width and height
                                        GeometryReader { proxy in
                                            
                                            let width = proxy.size.width
                                            let height = proxy.size.height
                                            let maxScore = scoreArray.max()
                                            let maxDays = dayArray.max()
                                            
                                            // Creating a background
                                            LinearGradient(
                                                colors: [Color(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1))],
                                                startPoint: .bottom,
                                                endPoint: .top
                                            )
                                            
                                            // Adding white horisontal lines
                                            VStack {
                                                Spacer()
                                                Divider()
                                                    .frame(height: 1)
                                                    .background(Color.white)
                                                Spacer()
                                                Divider()
                                                    .frame(height: 1)
                                                    .background(Color.white)
                                                Spacer()
                                                Divider()
                                                    .frame(height: 1)
                                                    .background(Color.white)
                                                Spacer()
                                            }
                                            
                                            
                                            // Creating the line chart
                                            Chart (progress) { item in
                                                LineMark(
                                                    x: .value("Days", item.day),
                                                    y: .value("Score", item.score)
                                                )
                                                .interpolationMethod(.catmullRom)
                                                .offset(
                                                    x: -20,
                                                    y: 15
                                                )
                                            }
                                            .foregroundColor(.white)
                                            .chartXAxis(.hidden)
                                            .chartYAxis(.hidden)
                                            
                                            
                                            // Adding marker for the chart
                                            Circle()
                                                .frame(width: 14)
                                                .foregroundColor(.black)
                                                .overlay(
                                                    Text("\(chosenDay)")
                                                        .font(.caption2)
                                                        .foregroundColor(.white)
                                                )
                                                .offset(
                                                    x: width / CGFloat(progress.count) * CGFloat(chosenDay) - 25,
                                                    y: CGFloat(1 - (height / CGFloat(maxScore ?? 1))) * CGFloat(progress[chosenDay - 1].score) + height + CGFloat(maxScore ?? 1) - CGFloat(progress[chosenDay - 1].score)
                                                )
                                        }.padding(.trailing)
                                    }
                                    .frame(maxWidth: 300, minHeight: 200)
                            }
                        }
                    }
                    
                    Spacer(minLength: 100)
                    
                    // Creating text field to make the marker change its place
                    HStack {
                        
                        
                        TextField("Enter the Day...", text: $textFieldText)
                            .frame(maxWidth: 200)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)))
                            .cornerRadius(10)
                        
                        
                        Button {
                            
                            guard let theDay = Int(textFieldText) else { return }
                            
                            if dayArray.contains(theDay) {
                                chosenDay = theDay
                                textFieldText = ""
                            }
                            
                            
                        } label: {
                            Image(systemName: "magnifyingglass")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(disableMagnifying() ? Color.gray : Color(#colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)))
                        .cornerRadius(10)
                        .disabled(disableMagnifying())
                    }
                }
                
            }
            .navigationTitle("Test Chart")
        }
    }
    
    // MARK: FUNCTIONS
    
    func disableMagnifying() -> Bool {
        guard let textToInt = Int(textFieldText) else { return false }
        
        if dayArray.contains(textToInt) {
            return false
        } else {
            return true
        }
        
    }
}

struct CopyTestView: View {
    
    @Binding var progress: [Item]
    
    // MARK: COPIED BODYS
    
    var body: some View {
        
        // Copying the content of previous page but with the scroll view instead of naviation link
        ScrollView {
            VStack {
                HStack {
                    
                    VStack {
                        Spacer()
                        
                        VStack {
                            Text("Hello")
                            Text("World")
                        }
                        .font(.footnote)
                        
                        
                        Spacer()
                        
                        VStack {
                            Text("Hello")
                            Text("World")
                        }
                        .font(.footnote)
                        
                        Spacer()
                        
                        VStack {
                            Text("Hello")
                            Text("World")
                        }
                        .font(.footnote)
                        
                        Spacer()
                        Spacer()
                        Spacer()
                    }
                    .padding()
                    
                    VStack {
                        
                        ZStack {
                            
                            // Initializing geometry reader to trace width and height
                                GeometryReader { proxy in
                                    
                                    let width = proxy.size.width
                                    let height = proxy.size.height
                                    let maxScore = scoreArray.max()
                                    
                                    // Creating a background
                                    LinearGradient(
                                        colors: [Color(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1))],
                                        startPoint: .bottom,
                                        endPoint: .top
                                    )
                                    
                                    // Adding white horisontal lines
                                    VStack {
                                        Spacer()
                                        Divider()
                                            .frame(height: 1)
                                            .background(Color.white)
                                        Spacer()
                                        Divider()
                                            .frame(height: 1)
                                            .background(Color.white)
                                        Spacer()
                                        Divider()
                                            .frame(height: 1)
                                            .background(Color.white)
                                        Spacer()
                                    }
                                    
                                    Chart (progress) { item in
                                        LineMark(
                                            x: .value("Days", item.day),
                                            y: .value("Score", item.score)
                                        )
                                        .interpolationMethod(.catmullRom)
                                        .offset(
                                            x: -20,
                                            y: 20
                                        )
                                    }
                                    .foregroundColor(.white)
                                    .chartXAxis(.hidden)
                                    .chartYAxis(.hidden)
                                    
                                }.padding(.trailing)
                            }
                            .frame(maxWidth: 300, minHeight: 200)
                        
                        
                        /*
                         HStack {
                            Spacer()
                            Spacer()
                            ForEach(progress) { day in
                                VStack {
                                    Text("Hello World")
                                        .rotationEffect(Angle(degrees: 90))
                                }
                                .font(.footnote)
                                Spacer()
                            }
                            Spacer()
                            Spacer()
                        }
                         */
                    }
                }
            }
        }
    }
}



// MARK: PREVIEW

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}

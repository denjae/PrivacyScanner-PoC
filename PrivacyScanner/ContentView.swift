//
//  ContentView.swift
//  PrivacyScanner
//
//  Created by Dennis Jaeger on 07.01.20.
//  Copyright © 2020 Dennis Jaeger. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var threatmentFloat = Float(0.0)
    @State private var components = reloadComponentList()
    @State private var clicked = false
    
    var body: some View {
        VStack{
            Text("Privacy Scanner").font(.title)
            VStack() {
                ZStack (alignment: .top) {
                RoundedRectangle(cornerRadius: 10).size(width: 100, height: 200).foregroundColor(Color.black).frame(width: 100, height: 200)
                    Circle().foregroundColor(Color.red).frame(width: 55, height: 55).offset(x: 0, y: 10).opacity(0.2)
                Circle().foregroundColor(Color.yellow).frame(width: 55, height: 55).offset(x: 0, y: 70).opacity(0.2)
                Circle().foregroundColor(Color.green).offset(x: 0, y: 65 ).frame(width: 55, height: 55).offset(x: 0, y: 65).opacity(0.2)
                    if threatmentFloat != 0.0 {
                        if threatmentFloat > 0.66 && threatmentFloat <= 1.0 {
                            Circle().foregroundColor(Color.red).frame(width: 55, height: 55).offset(x: 0, y: 10).animation(.easeIn(duration: 0.8))
                        }
                        else if threatmentFloat > 0.33 && threatmentFloat <= 0.66 {
                            Circle().foregroundColor(Color.yellow).frame(width: 55, height: 55).offset(x: 0, y: 70).animation(.easeIn(duration: 0.8))
                        }
                        else if threatmentFloat <= 0.33 { Circle().foregroundColor(Color.green).offset(x: 0, y: 65 ).frame(width: 55, height: 55).offset(x: 0, y: 65).animation(.easeIn(duration: 0.8))
                        }
                    }
                }
            Divider()
                VStack(){
                    VStack{
                        Text("Privacy-Impact: \(Int(threatmentFloat * 100)) %").font(.headline)
                                       }
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                                  Rectangle()
                                     .foregroundColor(Color.gray)
                                     .opacity(0.3)
                                     .frame(width: 350.0, height: 8.0)
                                  Rectangle()
                                     .foregroundColor(Color.blue)
                                    .frame(width: CGFloat(self.threatmentFloat) * 350, height: 8.0).animation(.linear(duration: 0.8))
                               }.cornerRadius(4.0)
                    }.frame(maxWidth: .infinity, maxHeight: 20)
                   Divider()
                    VStack() {
                        List(components) { component in
                                HStack {
                                    Text(component.desc)
                                    Spacer()
                                    if self.clicked {
                                        Circle().foregroundColor(component.color).fixedSize()
                                    }
                                    else {
                                    Circle().foregroundColor(Color.white).fixedSize().opacity(0.2)
                                    }
                                }
                        }
                    }
            }.frame(minWidth: 400, maxWidth: .infinity, minHeight: 250, maxHeight: .infinity, alignment: Alignment.topLeading)
            }
            HStack{
                Button(action: {
                    self.clicked = false
                    self.threatmentFloat = 0.0
                    }) {Text("Reset")
                }.foregroundColor(Color.red)
                Spacer(minLength: 80.0)
                Button(action: {
                    let comps = reloadComponentList()
                    self.components = comps
                    self.threatmentFloat = sumThreatments(comps)
                    self.clicked = true
                    }) {Text("Berechne Privacy-Impact")
                }
            }
        }
    }
}


//struct ContentView_Previews : PreviewProvider {
//    static var previews: some View {
//        ContentView(components: componentsList)
//    }
//}

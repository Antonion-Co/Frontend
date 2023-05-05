//
//  HomeView.swift
//  HackathoneTecmi
//
//  Created by Pablo Salas on 05/05/23.
//

import SwiftUI

struct ServicesStructs{
    var id: Int
    var service: String
    var price: Int
}


let servicess = [ServicesStructs(id: 1,service: "Netflix", price: 150),
                         ServicesStructs(id: 2, service: "Disney Plus", price: 179),
                         ServicesStructs(id: 3, service: "Apple TV", price: 79),
                         ServicesStructs(id: 4, service: "Paramount Plus", price: 159),
                         ServicesStructs(id: 5, service: "Apple Music", price: 79),
]

struct HomeView: View {
    
    //var services: ServicesStruct
    
    var body: some View {
        VStack{
            HStack {
                Text("Home")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                Image(systemName: "plus")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
            }
        
            Spacer()
            
            VStack(alignment: .center, spacing: 20){
                Text("Spends / Month")
                    .font(.title2)
                    .fontWeight(.regular)
                
                Text("1000$ MXN").font(.largeTitle).fontWeight(.bold).frame(width: 360.0, height: 100.0).background(Color(hue: 0.289, saturation: 0.0, brightness: 0.0, opacity: 0.129)).foregroundColor(Color(hue: 0.246, saturation: 0.86, brightness: 0.857)).cornerRadius(5)
                
                Image(systemName: "message.badge.circle.fill").resizable().frame(width: 50.0, height: 50.0).foregroundColor(Color.gray)
                
                Text("Services")
                    .font(.title2)
                
                
                HStack{
                    Text("Service")
                    Spacer()
                    Text("Price")
                }.frame(width: 320)
            }
            
            ScrollView{
                
                VStack{
                    ForEach(servicess, id: \.id) { ss in
                        HStack{
                            Text(ss.service)
                            Spacer()
                            Text(String(ss.price))
                        }.frame(height: 50).padding(.horizontal, 22.0).background(Color(red: 0.871, green: 0.871, blue: 0.871)).cornerRadius(5)
                    }
                }
            }
        }.padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

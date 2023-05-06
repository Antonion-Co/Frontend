//
//  HomeView.swift
//  HackathoneTecmi
//
//  Created by Pablo Salas on 05/05/23.
//

import SwiftUI

struct ServicesStructs: Codable{
    var id: Int
    var service: String
    var price: Float
}


//let services = [ServicesStructs(id: 1,service: "Netflix", price: 150),
//                         ServicesStructs(id: 2, service: "Disney Plus", price: 179),
//                         ServicesStructs(id: 3, service: "Apple TV", price: 79),
//                         ServicesStructs(id: 4, service: "Paramount Plus", price: 159),
//                         ServicesStructs(id: 5, service: "Apple Music", price: 79),
//                         ServicesStructs(id: 6, service: "Spotify", price: 79),
//                         ServicesStructs(id: 7, service: "Fitness", price: 79),
//]

struct HomeView: View {
    
    @State private var services: [ServicesStructs] = []
    //@Binding var token: String
    
    var totalPrice: Float {
        services.reduce(0.0) {$0 + $1.price}
    }
    
    var roundedTotal: String {
            String(format: "%.2f", totalPrice.rounded())
        }
    
    var body: some View {
        NavigationView{
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
                    
                    Text("\(roundedTotal)$ MXN").font(.largeTitle).fontWeight(.bold).frame(width: 360.0, height: 100.0).background(Color(hue: 0.289, saturation: 0.0, brightness: 0.0, opacity: 0.129)).foregroundColor(Color(hue: 0.246, saturation: 0.86, brightness: 0.857)).cornerRadius(5)
                    
                    NavigationLink(destination: HomeView()) {
                        Image(systemName:
                                "message.badge.circle.fill").resizable().frame(width: 50.0, height:50.0).foregroundColor(Color.gray)
                    }
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
                        ForEach(services, id: \.id) { ss in
                            HStack{
                                Text(ss.service)
                                Spacer()
                                Text("\(String(format: "%.2f", ss.price.rounded()))$")
                            }.frame(height: 50).padding(.horizontal, 22.0).background(Color(red: 0.871, green: 0.871, blue: 0.871)).cornerRadius(5)
                        }
                    }
                }
            }.padding()
        }
    }
    
    func fetchData() {
        guard let url = URL(string: "https://5d53-2605-6440-1018-1000-00-921c.ngrok-free.app/api/app_services") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        //request.setValue("Bearer \(token)", forHTTPHeaderField: "Autorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                services = try JSONDecoder().decode([ServicesStructs].self, from: data)
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }.resume()
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

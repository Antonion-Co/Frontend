//
//  Services.swift
//  Hackathon
//
//  Created by Hugo Martinez on 05/05/23.
//

import SwiftUI

struct Services: View {
    
    @State private var selectedService: String = ""
    
    var body: some View {
        VStack {
            Text("Selecciona un servicio")
                .font(.title)
                .padding(.top, 60)
            Spacer()
            VStack(spacing: 30) {
                Button(action: {
                    self.selectedService = "Netflix"
                }) {
                    Text("Netflix")
                        .font(.headline)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 20)
                }
                .background(Color.red)
                .cornerRadius(10)
                
                Button(action: {
                    self.selectedService = "Spotify"
                }) {
                    Text("Spotify")
                        .font(.headline)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 20)
                }
                .background(Color.green)
                .cornerRadius(10)
                
                Button(action: {
                    self.selectedService = "Disney Plus"
                }) {
                    Text("Disney Plus")
                        .font(.headline)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 20)
                }
                .background(Color.yellow)
                .cornerRadius(10)
            }
            Spacer()
            Button(action: {
                print("Enviar \(self.selectedService)")
            }) {
                Text("Enviar")
                    .font(.headline)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 20)
            }
            .background(self.selectedService.isEmpty ? Color.gray : Color.purple)
            .cornerRadius(10)
            .padding(.bottom, 30)
            .disabled(self.selectedService.isEmpty)
        }
        .onAppear() {
            guard let url = URL(string: "https://5d53-2605-6440-1018-1000-00-921c.ngrok-free.app/api/app_services") else { return }
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    do {
                        let appServices = try JSONDecoder().decode(AppServices.self, from: data)
                        let serviceNames = appServices.appServices.map { $0.name }
                        print(serviceNames)
                    } catch let error {
                        print(error)
                    }
                }
            }.resume()
        }
    }
}

struct Services_Previews: PreviewProvider {
    static var previews: some View {
        Services()
    }
}

struct AppServices: Codable {
    let appServices: [AppService]
}

struct AppService: Codable {
    let id: Int
    let name: String
    let price: String
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, price
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

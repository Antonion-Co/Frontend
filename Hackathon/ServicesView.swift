//
//  Services.swift
//  Hackathon
//
//  Created by Alumno on 05/05/23.
//

import SwiftUI

struct Service {
    let id: Int
    let name: String
    let price: Float
}

struct ServicesView: View {
    @State var services: Array<Service> = []
    @Binding var token: String
    
    var body: some View {
        VStack {
            ForEach(services, id: \.id) { service in
                Text("\(service.id) => \(service.name) => \(service.price)")
            }
        }.onAppear {
            fetchServices(completionHandler: { error in
                if error != nil {
                    print(error as Any)
                }
            })
        }
    }

    enum ServicesError: Error {
        case connectionError
        case invalidResponse
        case authenticationError
        case invalidCredentials
        case unknownError
    }

    func fetchServices(completionHandler: @escaping (Error?) -> Void) {
        guard let url = URL(string: "https://5d53-2605-6440-1018-1000-00-921c.ngrok-free.app/api/app_services") else {
            completionHandler(ServicesError.connectionError)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Autorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error : \(error.localizedDescription)")
                completionHandler(ServicesError.connectionError)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completionHandler(ServicesError.invalidResponse)
                return
            }
            
            if httpResponse.statusCode == 200 {
                guard let responseData = data else {
                    completionHandler(ServicesError.unknownError)
                    return
                }
                let responseJson = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
                let responseServices = responseJson?["app_services"] as? Array<Any>
                guard let unwrappedResponseServices = responseServices else {
                    completionHandler(ServicesError.invalidResponse)
                    return
                }
                for responseService in unwrappedResponseServices {
                    if let serviceDict = responseService as? [String: Any],
                       let serviceId = serviceDict["id"] as? Int,
                       let serviceName = serviceDict["name"] as? String,
                       let servicePrice = serviceDict["price"] as? Float {
                        services.append(Service(id: serviceId, name: serviceName, price: servicePrice))
                    } else {
                        print("Invalid service")
                    }
                }

                completionHandler(nil)
            } else if httpResponse.statusCode == 401 {
                completionHandler(ServicesError.invalidCredentials)
            } else {
                print(httpResponse.statusCode)
                completionHandler(ServicesError.unknownError)
            }
        }
        
        task.resume()
    }
}

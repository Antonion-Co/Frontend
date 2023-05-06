//
//  LoginView.swift
//  Hackathon
//
//  Created by Alumno on 05/05/23.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @Binding var token: String

    var body: some View {
        VStack {
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 50)

            TextField("Email", text: $email)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5.0)
                .padding(.bottom, 20)

            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5.0)
                .padding(.bottom, 20)

            Button(action: {
                Task.detached {
                    login(completionHandler: { error in
                        if error != nil {
                            print(error as Any)
                        }
                    })
                }
            }) {
                Text("Login")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.blue)
                    .cornerRadius(15.0)
            }
        }
        .padding()
    }

    enum LoginError: Error {
        case connectionError
        case invalidResponse
        case authenticationError
        case invalidCredentials
        case unknownError
    }

    func login(completionHandler: @escaping (Error?) -> Void) {
        guard let url = URL(string: "https://3a44-2a0d-5600-6-8000-00-c182.ngrok-free.app/api/users/sign_up") else {
            completionHandler(LoginError.connectionError)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let params = ["user": ["email": email, "password": password]]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            completionHandler(LoginError.invalidCredentials)
            return
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error : \(error.localizedDescription)")
                completionHandler(LoginError.connectionError)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completionHandler(LoginError.invalidResponse)
                return
            }
            
            if httpResponse.statusCode == 200 {
                guard let responseData = data else {
                    completionHandler(LoginError.unknownError)
                    return
                }
                let responseJson = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
                let responseToken = responseJson?["token"] as? String
                token = responseToken ?? ""

                if token == "" {
                    completionHandler(LoginError.invalidResponse)
                } else {
                    completionHandler(nil)
                }
            } else if httpResponse.statusCode == 401 {
                completionHandler(LoginError.invalidCredentials)
            } else {
                print(httpResponse.statusCode)
                completionHandler(LoginError.unknownError)
            }
        }
        
        task.resume()
    }
}

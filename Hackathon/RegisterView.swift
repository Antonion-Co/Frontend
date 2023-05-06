//
//  RegisterView.swift
//  Hackathon
//
//  Created by Alumno on 05/05/23.
//

import SwiftUI

struct RegisterView: View {
    @State private var email = ""
    @State private var password = ""
    @Binding var token: String

    var body: some View {
        VStack {
            Text("Register")
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
                    register(completionHandler: { error in
                        if error != nil {
                            print(error as Any)
                        }
                    })
                }
            }) {
                Text("Register")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.blue)
                    .cornerRadius(15.0)
            }

            NavigationLink(destination: LoginView(token: $token)) {
                Text("Already have an account?")
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }

    enum RegisterError: Error {
        case connectionError
        case invalidResponse
        case authenticationError
        case invalidCredentials
        case unknownError
    }

    func register(completionHandler: @escaping (Error?) -> Void) {
        guard let url = URL(string: "https://5d53-2605-6440-1018-1000-00-921c.ngrok-free.app/api/users/sign_up") else {
            completionHandler(RegisterError.connectionError)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let params = ["user": ["email": email, "password": password]]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            completionHandler(RegisterError.invalidCredentials)
            return
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error : \(error.localizedDescription)")
                completionHandler(RegisterError.connectionError)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completionHandler(RegisterError.invalidResponse)
                return
            }
            
            if httpResponse.statusCode == 201 {
                guard let responseData = data else {
                    completionHandler(RegisterError.unknownError)
                    return
                }
                let responseJson = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
                let responseToken = responseJson?["token"] as? String
                token = responseToken ?? ""

                if token == "" {
                    completionHandler(RegisterError.invalidResponse)
                } else {
                    completionHandler(nil)
                }
            } else if httpResponse.statusCode == 401 {
                completionHandler(RegisterError.invalidCredentials)
            } else {
                print(httpResponse.statusCode)
                completionHandler(RegisterError.unknownError)
            }
        }
        
        task.resume()
    }
}

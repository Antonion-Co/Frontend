//
//  LoginView.swift
//  Hackathon
//
//  Created by Alumno on 05/05/23.
//

import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @Binding var token: String

    var body: some View {
        VStack {
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 50)

            TextField("Username", text: $username)
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
                token = "OK"
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

    func login(completionHandler: @escaping (Error?) -> Void) throws {
        guard let url = URL(string: "https://3a44-2a0d-5600-6-8000-00-c182.ngrok-free.app/api/users/sign_in") else {
            throw LoginError.connectionError
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let params = ["username": $username, "password": $password]
        request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
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
                completionHandler(nil)
            } else if httpResponse.statusCode == 401 {
                completionHandler(LoginError.invalidCredentials)
            } else {
                completionHandler(LoginError.unknownError)
            }
        }
        
        task.resume()
    }
}

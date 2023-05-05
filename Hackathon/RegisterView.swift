//
//  RegisterView.swift
//  Hackathon
//
//  Created by Alumno on 05/05/23.
//

import SwiftUI

struct RegisterView: View {
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""

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
                // Logical part here
            }) {
                Text("Register")
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

    enum RegisterError: Error {
        case connectionError
        case invalidResponse
        case authenticationError
        case invalidCredentials
        case unknownError
    }

    func register(email: String, username: String, password: String, completionHandler: @escaping (Error?) -> Void) throws {
        guard let url = URL(string: "https://example.com/api/register") else {
            throw RegisterError.connectionError
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let params = ["email": email, "username": username, "password": password]
        request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
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
            
            if httpResponse.statusCode == 200 {
                completionHandler(nil)
            } else if httpResponse.statusCode == 401 {
                completionHandler(RegisterError.invalidCredentials)
            } else {
                completionHandler(RegisterError.unknownError)
            }
        }
        
        task.resume()
    }
}

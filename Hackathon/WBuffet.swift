//
//  WBuffet.swift
//  Hackathon
//
//  Created by Hugo Martinez on 05/05/23.
//

import SwiftUI

struct WBuffet: Identifiable {
    var id = UUID()
    var message: String
    var isMe: Bool
}

struct ChatView: View {
    @State private var message = ""
    @State private var messages: [WBuffet] = [
        WBuffet(message: "Hola, ¿en qué puedo ayudarte?", isMe: false)
    ]
    @Binding var token: String
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(messages) { message in
                    HStack {
                        if !message.isMe {
                            Text(message.message)
                                .padding(10)
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(10)
                                .padding(.horizontal)
                            Spacer()
                        } else {
                            Spacer()
                            Text(message.message)
                                .padding(10)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                    }
                }
            }
            HStack {
                TextField("Escribe un mensaje", text: $message)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(10)
                Button(action: sendMessage) {
                    Text("Enviar")
                        .padding(10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationBarTitle("Chat con Chatbot")
    }
    
    func sendMessage() {
        if !message.isEmpty {
            messages.append(WBuffet(message: message, isMe: true))
            message = ""
            
            // Configurar la solicitud HTTP
            let url = URL(string: "https://5d53-2605-6440-1018-1000-00-921c.ngrok-free.app/api/messages")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let parameters = ["messages": messages.last!.message]
            request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
            
            // Enviar la solicitud HTTP
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    print("Error al enviar la solicitud HTTP: \(error!)")
                    return
                }
                guard let data = data else {
                    print("Error al recibir datos de la respuesta")
                    return
                }
                guard let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    print("Error al analizar la respuesta JSON")
                    return
                }
                let responseMessage = responseJSON["response"] as? String ?? "Lo siento, no puedo responder esa pregunta"
                DispatchQueue.main.async {
                    messages.append(WBuffet(message: responseMessage, isMe: false))
                }
            }
            task.resume()
        }
    }
}

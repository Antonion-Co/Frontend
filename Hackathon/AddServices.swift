//
//  AddServices.swift
//  Hackathon
//
//  Created by Hugo Martinez on 05/05/23.
//

import SwiftUI

struct AddServices: View {
    // Declara una variable para almacenar la lista de opciones de servicios
    @State private var options = [ServiceOption]()
    // Declara una variable para almacenar la opción seleccionada
    @State private var selectedOption: ServiceOption?
    
    var body: some View {
        NavigationView {
            if options.isEmpty {
                // Muestra un indicador de carga mientras se cargan los datos de la API
                ProgressView()
                    .navigationBarTitle("Agregar servicio")
            } else {
                // Muestra una lista de opciones de servicios
                List(options) { option in
                    VStack(alignment: .leading) {
                        Text(option.name)
                            .font(.headline)
                        Text("ID: \(option.id) - Fecha: \(option.fecha)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .onTapGesture {
                        // Al seleccionar una opción, actualiza la variable `selectedOption`
                        selectedOption = option
                    }
                    // Agrega un indicador de selección para la opción seleccionada
                    .background(selectedOption != nil && selectedOption!.id == option.id ? Color(.systemGray6) : Color.white)

                }
                .navigationBarTitle("Agregar servicio")
                .navigationBarItems(trailing:
                    Button(action: {
                        // Agrega aquí la lógica para enviar la opción seleccionada
                        if let option = selectedOption {
                            print("Enviar opción: \(option.name)")
                        }
                    }) {
                        Text("Enviar")
                            .fontWeight(.semibold)
                    }
                    // Desactiva el botón de enviar si no se ha seleccionado una opción
                    .disabled(selectedOption == nil)
                )
            }
        }
        .onAppear {
            // Realiza una llamada a la API cuando la vista aparece
            fetchData()
        }
        
    }
    
    // Función para obtener los datos de la API
    func fetchData() {
        guard let url = URL(string: "https://3a44-2a0d-5600-6-8000-00-c182.ngrok-free.app/api/app_services") else {
            print("URL inválida")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    // Decodifica la respuesta JSON en una matriz de opciones de servicios
                    let decodedResponse = try JSONDecoder().decode(ServiceOptionsResponse.self, from: data)
                    DispatchQueue.main.async {
                        // Actualiza la variable de opciones con los datos de la API
                        self.options = decodedResponse.app_services
                    }
                } catch {
                    print("Error al decodificar la respuesta: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}

// Estructura para representar una respuesta de opciones de servicio
struct ServiceOptionsResponse: Codable {
    let app_services: [ServiceOption]
}

// Estructura para representar una opción de servicio
struct ServiceOption: Codable, Identifiable {
    let id: Int
    let name: String
    let fecha: String
    
    static func ==(lhs: ServiceOption, rhs: ServiceOption) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.fecha == rhs.fecha
    }
}

struct AddServices_Previews: PreviewProvider {
    static var previews: some View {
        AddServices()
    }
}





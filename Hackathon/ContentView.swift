//
//  ContentView.swift
//  Hackathon
//
//  Created by Alumno on 05/05/23.
//

import SwiftUI

struct ContentView: View {
    @State var token: String = ""

    var body: some View {
        if token == "" {
            RegisterView(token: $token)
        } else {
            VStack {
                AddServices()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

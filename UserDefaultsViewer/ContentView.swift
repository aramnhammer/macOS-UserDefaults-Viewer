//
//  ContentView.swift
//  UserDefaultsViewer
//
//  Created by aram on 8/11/24.
//

import SwiftUI

struct ListKVPair: View {
    let key: String
    let value: Any

    var body: some View {
        HStack {
            Text(key)
                .font(.headline)

            Spacer()

            Text("\(value)")
                .truncationMode(/*@START_MENU_TOKEN@*/.tail/*@END_MENU_TOKEN@*/)
                .font(.headline)
                .foregroundColor(.secondary)
        }
    }
}

struct ContentView: View {
    @State private var key: String = ""
    @State private var value: String = ""
    @State private var allKeys: [String: Any] = [:]
    @State private var searchKey: String = ""
    
    var body: some View {
        VStack {
            TextField("Search UserDefaults keys", text: $searchKey, onEditingChanged: {_ in 
                self.allKeys = self.getAllKeys(matching: self.searchKey)
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            List(Array(allKeys.keys), id: \.self) { key in
                ListKVPair(key: key, value: allKeys[key] as Any)
            }
            .frame(maxHeight: 200)
        }
        .frame(width: 600, height: 400)
        .onAppear {
            self.allKeys = self.getAllKeys(matching: "")
        }
    }
    
    private func getUserDefaultsValue(forKey key: String) -> String {
        let defaults = UserDefaults.standard
        if let value = defaults.object(forKey: key) {
            return "\(value)"
        } else {
            return "No value found for key '\(key)'"
        }
    }
    
    private func getAllKeys(matching search: String) -> [String: Any]{
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        if search.isEmpty {
            return dictionary
        } else {
            return dictionary.filter( { $0.key.contains(search) } )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

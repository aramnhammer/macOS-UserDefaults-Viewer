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


struct NavViewButtonStyle: ButtonStyle {
    @State private var hovered = false

    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.label
                .foregroundColor(.primary)
                .padding(.horizontal, 2)
                .padding(.vertical, 2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .background(configuration.isPressed ? Color.gray.opacity(0.2) : Color.clear)
                .background(Color(hovered ? .systemBlue : .clear))
                .onHover { isHovered in
                    self.hovered = isHovered
                }
                .animation(.default, value: hovered)
                .clipShape(RoundedRectangle(cornerRadius:10))
                .font(.callout)
                .cornerRadius(1)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 2) // Outline color and width
                )
        }
    }
}


struct ContentView: View {
    @State private var key: String = ""
    @State private var value: String = ""
    @State private var allKeys: [String: Any] = [:]
    @State private var searchKey: String = ""
    @State private var selectedKey: String = ""
    
    var body: some View {
        NavigationView
        {
            VStack {
                TextField("Search UserDefaults keys", text: $searchKey, onEditingChanged: {_ in
                    self.allKeys = self.getAllKeys(matching: self.searchKey)
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                List(Array(allKeys.keys), id: \.self) { key in
                                    Button(action: {
                                        self.selectedKey = key
                                    }) {
                                        Text(key)
                                            .padding()
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .buttonStyle(NavViewButtonStyle())

                                }
                .listStyle(SidebarListStyle())

//                                .frame(maxHeight: 200)
            }
            .frame(width: 200)
            VStack {
                Text("Value for '\(selectedKey)': ")
                    .font(.headline)
                    .padding()
                Text(getUserDefaultsValue(forKey: selectedKey))
                    .padding()
            }
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())

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

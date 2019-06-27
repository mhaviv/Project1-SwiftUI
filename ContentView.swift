//
//  ContentView.swift
//  Project1-SwiftUI
//
//  Created by Michael Haviv on 6/26/19.
//  Copyright © 2019 Michael Haviv. All rights reserved.
//

import Combine // works with data to send changes
import SwiftUI

// states when data has changed in project 1 images folder (sends data to parent)
class DataSource: BindableObject {
    // send void and never throw errors
    // Void - knows to reload automatically so no reason to send anything
    // Never - no need to throw an error
    let didChange = PassthroughSubject<Void, Never>()
    var pictures = [String]()
    
    init() {
        let fm = FileManager.default
        
        // Scans the project1-files folder for the pictures and appends them to the array
        if let path = Bundle.main.resourcePath, let items = try? fm.contentsOfDirectory(atPath: path) {
            for item in items {
                if item.hasPrefix("nssl"){
                    pictures.append(item)
                }
            }
        }
        
        didChange.send(()) // send the changes in the items array
    }
}

struct DetailView: View {
    @State private var hidesNavigationBar = false
    var selectedImage: String
    
    var body: some View {
        let img = UIImage(named: selectedImage)!
        return Image(uiImage: img)
            .resizable()
            .aspectRatio(1024/768, contentMode: .fit)
            .navigationBarTitle(Text(selectedImage), displayMode: .inline)
            .navigationBarHidden(hidesNavigationBar)
            .tapAction {
                self.hidesNavigationBar.toggle()
            }
    }
}

struct ContentView : View {
    // our content view is a Struct which means when it gets recreated, it will destroy dataSource and recreate it everytime. So we want it to be controlled by SwiftUI by being @ObjectBinding
    @ObjectBinding var dataSource = DataSource()
    
    var body: some View {
        NavigationView {
            // .identified(by: \.self) - looks at itself to understand how to make these rows
            List(dataSource.pictures.identified(by: \.self))
                { picture in
                    NavigationButton(destination:
                        DetailView(selectedImage: picture), isDetail: true){
                        Text(picture)
                    }
            }.navigationBarTitle(Text("Storm Viewer"))
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

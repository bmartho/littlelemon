//
//  Menu.swift
//  Little Lemon
//
//  Created by Bruno Juliani Martho on 07/02/25.
//

import SwiftUI

struct Menu: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            Text("LITTLE LEMON")
            Text("Chicago")
            Text("Great app to order your preferred food")
            TextField("Search menu", text: $searchText).padding()
            
            FetchedObjects(
                predicate: buildPredicate(),
                sortDescriptors:buildSortDescriptors()
            ) { (dishes: [Dish]) in
                List{
                    ForEach(dishes, id: \.self) { dish in
                        HStack {
                            let text = (dish.title ?? "" ) + "-" + (dish.price ?? "" )
                            Text(text)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            if let imageUrlString = dish.image, let imageUrl = URL(string: imageUrlString) {
                                AsyncImage(url: imageUrl) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 50, height: 50)
                                }
                            }
                            
                            Spacer()
                        }
                    }
                }
            }
            
        }.onAppear{
            getMenuData()
        }
    }
    
    func buildSortDescriptors() -> [NSSortDescriptor]{
        return [NSSortDescriptor(
            key: "title",
            ascending: true,
            selector: #selector(NSString.localizedStandardCompare))]
    }
    
    func buildPredicate() -> NSPredicate {
        if searchText == "" {
            return NSPredicate(value: true)
        } else {
            return NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        }
    }
    
    func getMenuData(){
        let urlString = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                if let menuList = try? decoder.decode(MenuList.self, from: data) {
                    for menuItem in menuList.menu {
                        let dish = Dish(context: viewContext)
                        dish.title = menuItem.title
                        dish.category = menuItem.category
                        dish.price = menuItem.price
                        dish.image = menuItem.image
                    }
                    
                    PersistenceController.shared.clear()
                    try? viewContext.save()
                } else {
                    print("Failed to decode JSON")
                }
            }
        }
        task.resume()
    }
}
#Preview {
    Menu()
}

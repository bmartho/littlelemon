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
    @State private var selectedFilters: Set<String> = []
    private let filters = ["starters", "desserts", "mains"]
    
    var body: some View {
        VStack {
            headerSection
            
            heroSection
            
            breakdownSection
            
            listSection
        }.onAppear{
            getMenuData()
        }
    }
    
    var breakdownSection: some View {
        VStack{
            HStack{
                Text("ORDER FOR DELIVERY!")
                    .font(.system(size: 18))
                    .bold()
                    .padding(.horizontal, 8)
                
                Spacer()
            }
            
            HStack{
                ForEach(filters, id: \.self) { filter in
                    FilterLabel(filter: filter, isSelected: selectedFilters.contains(filter)) {
                        if selectedFilters.contains(filter) {
                            selectedFilters.remove(filter)
                        } else {
                            selectedFilters.insert(filter)
                        }
                    }
                }
            }
        }
    }
    
    var listSection: some View {
        FetchedObjects(
            predicate: buildPredicates(),
            sortDescriptors:buildSortDescriptors()
        ) { (dishes: [Dish]) in
            ScrollView{
                Divider()
                    .background(Color.gray)
                
                ForEach(dishes, id: \.self) { dish in
                    HStack {
                        VStack{
                            Text(dish.title ?? "")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .bold()
                            
                            Text(dish.desc ?? "")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.system(size: 14))
                                .padding(.vertical, 8)
                            
                            Text(formatPrice(dish.price ?? "0"))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                        }
                        if let imageUrlString = dish.image, let imageUrl = URL(string: imageUrlString) {
                            AsyncImage(url: imageUrl) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 100, height: 100)
                            }
                        }
                    }
                    
                    Divider()
                        .background(Color.gray)
                }
            }
            .padding(.horizontal, 8)
        }.frame(maxHeight: .infinity)
    }
    
    var headerSection: some View {
        HStack{
            Text("LITTLE LEMON")
                .foregroundColor(.gray)
                .font(.system(size: 20))
                .bold()
            
            Image("profile-image-placeholder")
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 50, height: 50)
        }
    }
    
    var heroSection: some View {
        VStack {
            HStack{
                Text("LITTLE LEMON")
                    .foregroundColor(.yellow)
                    .font(.system(size: 26))
                    .bold()
                Spacer()
            }
            
            HStack{
                Text("Chicago")
                    .font(.system(size: 22))
                Spacer()
            }
            
            HStack{
                Text("We are a family owed Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                Spacer()
                Image("profile-image-placeholder")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding(.bottom, 20)
            }
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.horizontal, 8)
                TextField("Search menu", text: $searchText)
                    .foregroundColor(.black)
                    .padding(.trailing, 8)
                    .padding(.vertical, 8)
            }.background(RoundedRectangle(cornerSize: .init(width: 8, height: 8)).fill(Color(.systemGray6))) .padding(.bottom, 8)
        }
        .padding(.horizontal, 8)
        .background(Color.green.opacity(0.3))
    }
    
    struct FilterLabel: View {
        let filter: String
        let isSelected: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Text(filter)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(isSelected ? Color.green : Color.gray.opacity(0.2))
                    .foregroundColor(.black)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isSelected ? Color.green : Color.gray, lineWidth: 2)
                    )
            }
            .padding(.vertical, 4)
        }
    }
    
    func buildSortDescriptors() -> [NSSortDescriptor]{
        return [NSSortDescriptor(
            key: "title",
            ascending: true,
            selector: #selector(NSString.localizedStandardCompare))]
    }
    
    func buildPredicates() -> NSPredicate {
        var predicates: [NSPredicate] = []

        if !searchText.isEmpty {
            predicates.append(NSPredicate(format: "title CONTAINS[cd] %@", searchText))
        }

        if !selectedFilters.isEmpty {
            let categoryPredicate = NSPredicate(format: "category IN %@", Array(selectedFilters))
            predicates.append(categoryPredicate)
        }

        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
    
    func getMenuData(){
        let urlString = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                if let menuList = try? decoder.decode(MenuList.self, from: data) {
                    for menuItem in menuList.menu {
                        if !PersistenceController.shared.doesDishExist(title: menuItem.title, viewContext){
                            let dish = Dish(context: viewContext)
                            dish.title = menuItem.title
                            dish.category = menuItem.category
                            dish.price = menuItem.price
                            dish.image = menuItem.image
                            dish.desc = menuItem.description
                        }
                    }
                    
                    
                    try? viewContext.save()
                } else {
                    print("Failed to decode JSON")
                }
            }
        }
        task.resume()
    }
    
    func formatPrice(_ price : String) -> String {
        if let priceFloat = Float(price) {
            let spacing = priceFloat < 10 ? " " : ""
            return "$" + spacing + String(format: "%.2f", priceFloat)
        } else {
            return "$0.00"
        }
    }
}
#Preview {
    Menu()
}

import SwiftUI

struct AddPinCategoryView: View {
    
    
    @State internal var categoryName: String = ""
    @State internal var selectedSymbol: String = "bookmark" // Default symbol
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    
    
    let symbols: [String] = [
        "bookmark", "flag", "heart", "star", "tag", "square.and.arrow.up", "doc.text", "photo", "speaker", "mic", "video", "briefcase", "building.columns", "airplane", // Add more system symbols as needed
    ]

    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Category Details")) {
                    TextField("Category Name", text: $categoryName)
                    
                    Picker("Select Symbol", selection: $selectedSymbol) {
                        ForEach(symbols, id: \.self) { symbol in
                            HStack {
                                Image(systemName: symbol)
                                    .renderingMode(.original) // Ensures the symbol's original color
                                Text(symbol)
                            }
                            .tag(symbol)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .labelsHidden()
                }
                
                Section {
                    Button("Save Category") {
                        saveCategory()
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Add Pin Category")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Dismiss") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    func saveCategory() {
        let newCategory = PinCategory(context: viewContext)
        newCategory.categoryID = UUID().uuidString // Generate a unique ID for the category
        newCategory.categoryName = categoryName
        newCategory.categorySymbol = selectedSymbol
        
        do {
            try viewContext.save() // Save changes to Core Data using viewContext
            print("Category saved successfully")
            print(newCategory)
            presentationMode.wrappedValue.dismiss() // Dismiss the view after saving
        } catch {
            print("Error saving category: \(error.localizedDescription)")
        }
    }


}

struct AddPinCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddPinCategoryView()
        }
    }
}


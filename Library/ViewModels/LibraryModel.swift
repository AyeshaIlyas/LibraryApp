//
//  LibraryModel.swift
//  Library
//
//  Created by Ayesha Ilyas on 4/12/22.
//

import Foundation

class LibraryModel: ObservableObject {
    @Published var books: [Book]
    let saveKey = "savedBooks"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode([Book].self, from: data) {
                books = decoded
                return
            }
        }
        books = [Book]()
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(books) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    func deleteBook(at index: Int) {
        if (0..<self.books.count).contains(index) {
            self.books.remove(at: index)
            self.save()
        } else {
            print("Could not remove  book. Invalid index")
        }
    }
    
    func addBook(_ book: Book) {
        self.books.append(book)
        self.save()
    }
    
    func editBook() {
        self.books.append(self.books.removeLast())
        self.save()
    }
    
    // func to addBook
    // write Books to file right before user quits app
    // keep track of total number of books and display in GUI
    // edit functionality - implement an alternative initializer for the AddBookFormView
}

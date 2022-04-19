//
//  LibraryModel.swift
//  Library
//
//  Created by Ayesha Ilyas on 4/12/22.
//

import Foundation

class LibraryModel: ObservableObject {
    @Published var books: [Book]
    private let bookKey = "savedBooks"
    private let bookCountKey = "bookCount"
    private var reverseSort = false
    var numberOfBooks: Int {
        self.books.count
    }
    
    var usedGenres: [String] {
        var used = [String]()
        for book in books {
            if !used.contains(book.genre) {
                used.append(book.genre)
            }
        }
        
        used.sort()
        if reverseSort {
            used.reverse()
        }
        print(used)
        return used
    }
    
    // retrieve any saved data
    init() {
        // retrieve books
        if let data = UserDefaults.standard.data(forKey: self.bookKey) {
            if let decoded = try? JSONDecoder().decode([Book].self, from: data) {
                self.books = decoded
                return
            }
        }
        self.books = [Book]()
    }
    
    
    // save data
    func save() {
        // save books
        if let encoded = try? JSONEncoder().encode(books) {
            UserDefaults.standard.set(encoded, forKey: bookKey)
        }
    }
    
    // remove book at valid index
    func deleteBook(at index: Int) {
        if (0..<self.books.count).contains(index) {
            self.books.remove(at: index)
            self.save()
        }
    }
    
    // add book to books
    func addBook(_ book: Book) {
        self.books.append(book)
        self.save()
    }
    
    // force UI update by removing and reappending a book to show changes made to a Book in the [Book]
    func editBook() {
        self.books.append(self.books.removeLast())
        self.save()
    }
    
    // sort books based on title, toggle ascending and descending order
    func sortByTitle() {
        // descending order
        if self.reverseSort {
            books.sort { book1, book2 in
                return book1.title > book2.title
            }
        }
        
        // ascending order
        else { // reverseSort is false
            books.sort { book1, book2 in
                return book1.title < book2.title
            }
        }
        self.reverseSort.toggle()
        self.save()
    }
    
    // keep track of total number of books and display in GUI
    // edit functionality - implement an alternative initializer for the AddBookFormView
}


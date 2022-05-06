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
    
    private var sortState = 0
    private let sortKey = "sortState"
    
    private enum Sort: CaseIterable, Codable {
        case byDateAddedAsc
        case byDateAddedDesc
        case byTitleAsc
        case byTitleDesc
    }
    private let sortOptions: [Sort] = Sort.allCases
    var listId = 0
    
    var numberOfBooks: Int {
        books.count
    }
    
    var usedGenres: [String] {
        var used = [String]()
        for book in books {
            if !used.contains(book.genre) {
                used.append(book.genre)
            }
        }
        // sort genres based on sort specified
        // alphabetically if sorted by title or date asc
        used.sort()
        // reverse alphabbetical if sorted by title or data desc
        if sortOptions[sortState] == Sort.byDateAddedDesc ||
            sortOptions[sortState] == Sort.byTitleDesc {
            used.reverse()
        }
        listId += 1
        return used
    }
    
    // retrieve any saved data
    init() {
        // retrieve books
        if let bookData = UserDefaults.standard.data(forKey: bookKey), let decodedBooks = try? JSONDecoder().decode([Book].self, from: bookData) {
                books = decodedBooks
        } else {
            books = [Book]()
        }
        
        // retrieve sort state
        if let sortData = UserDefaults.standard.data(forKey: sortKey), let decodedSort = try? JSONDecoder().decode(Int.self, from: sortData) {
                sortState = decodedSort
        } else {
            sortState = 0 // corresponds to Sort.byTitleAsc
        }
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
        if (0..<books.count).contains(index) {
            books.remove(at: index)
            save()
        }
    }
    
    // add book to books
    func addBook(_ book: Book) {
        books.append(book)
        save()
    }
    
    // force UI update by removing and reappending a book to show changes made to a Book in the [Book]
    func enableEdit() {
        books.append(books.removeLast())
        save()
    }
    
    // sort books based on title, toggle ascending and descending order
    func sort() {
        // change the sort type to the next one
        sortState = (sortState + 1) % sortOptions.count
        
        // sort 
        if sortOptions[sortState] == Sort.byDateAddedAsc {
            books.sort { book1, book2 in
                return book1.date < book2.date
            }
        } else if sortOptions[sortState]  == Sort.byDateAddedDesc {
            books.sort { book1, book2 in
                return book1.date > book2.date
            }
        } else if sortOptions[sortState]  == Sort.byTitleAsc {
            books.sort { book1, book2 in
                return book1.title < book2.title
            }
        } else if sortOptions[sortState]  == Sort.byTitleDesc {
            books.sort { book1, book2 in
                return book1.title > book2.title
            }
        }
        
        // save sort state
        if let encoded = try? JSONEncoder().encode(sortState) {
            UserDefaults.standard.set(encoded, forKey: sortKey)
        }
    }

}

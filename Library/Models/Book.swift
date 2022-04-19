//
//  Book.swift
//  Library
//
//  Created by Ayesha Ilyas on 4/12/22.
//

import Foundation
import UIKit

class Book: Identifiable, Codable {
    static let genres = ["Academic", "Action and Adventure", "Biography", "Classic", "Comic Book and Graphic Novel", "Dystopian", "Fantasy", "Fiction", "Historical Fiction", "History", "Horror", "Humanities & Social Sciences", "Memoir and Autobiography", "Mystery", "Poetry", "Religion and Spirituality", "Romance", "Science Fiction", "Science and Technology", "Short Stories", "Suspense and Thriller", "Thriller and Suspense", "True Crime", "Young Adult"]
    var id: UUID?
    var title: String
    var author: Author
    var yearOfPublication: Int
    var numberOfPages: Int
    var estimatedReadingTime: Double // in hours
    var genre: String
    var rating: Int
    var notes: String?
    
    init(title: String, authorFirstName: String, authorLastName: String, yearOfPublication: Int, numberOfPages: Int, estimatedReadingTime: Double, genre: String, rating: Int, notes: String? = nil) throws {
        // if any String value is empty throw exception
        guard !Utilities.isEmpty(title) && !Utilities.isEmpty(authorFirstName) && !Utilities.isEmpty(authorLastName) && !Utilities.isEmpty(genre) else {
            throw BookError.emptyValue
        }
        // number of pages has to be positive
        guard numberOfPages > 0 else {
            throw BookError.invalidNumberOfPages
        }
        
        // reading time must be positive
        guard estimatedReadingTime > 0 else {
            throw BookError.invalidReadingTime
        }
        
        // rating must be between 1 and 5 inclusive
        guard rating >= 1 && rating <= 5 else {
            throw BookError.invalidRating
        }
        
        // publication date must be a four digit year
        guard String(yearOfPublication).range(of: #"^[0-9]{4}$"#, options: .regularExpression) != nil else {
            throw BookError.invalidPublicationDate
        }
        
        // genre must be one of the predefined genres
        guard Book.genres.contains(genre) else {
            throw BookError.invalidGenre
        }
        
        // inialize book
        self.id = UUID()
        self.title = Utilities.parseString(title)
        self.author = Author(Utilities.parseString(authorFirstName), Utilities.parseString(authorLastName))
        self.yearOfPublication = yearOfPublication
        self.numberOfPages = numberOfPages
        self.estimatedReadingTime = estimatedReadingTime
        self.genre = Utilities.parseString(genre)
        self.rating = rating
        // if notes is not null or an empty string, set notes stored property
        if notes != nil && !Utilities.isEmpty(notes!) {
            self.notes = notes!
        }
    }
    
    static func isValidTitle(_ s: String) -> Bool {
        return !Utilities.isEmpty(s)
    }
    
    static func isValidYear(_ year: String) -> Bool {
        return Utilities.parseString(String(year)).range(of: #"^[0-9]{4}$"#, options: .regularExpression) == nil ? false : true
    }
    
    static func isValidAuthorName(_ s: String) -> Bool {
        return isValidTitle(s)
    }
    
    static func isValidPages(_ pages: Int) -> Bool {
        return pages > 0
    }
    
    static func isValidReadingTime(_ time: Double) -> Bool {
        return time > 0
    }
    
    static func isValidRating(_ rating: Int) -> Bool {
        return rating >= 1 && rating <= 5
    }
    
    static func isValidGenre(_ genre: String) -> Bool {
        return Book.genres.contains(genre)
    }
}

class Author: Codable {
    var firstName = ""
    var lastName = ""
    
    init(_ firstName: String, _ lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
}

enum BookError: Error {
    case invalidPublicationDate
    case invalidNumberOfPages
    case invalidReadingTime
    case invalidRating
    case invalidGenre
    case emptyValue
}



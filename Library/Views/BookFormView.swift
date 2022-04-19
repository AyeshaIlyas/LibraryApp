//
//  BookFormView.swift
//  Library
//
//  Created by Ayesha Ilyas on 4/13/22.
//

import SwiftUI

struct BookFormView: View {
    private let accentColor = Color(red: 0.929, green: 0.102, blue: 0.365)
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var libraryModel: LibraryModel
    @State var title = "";
    @State var authorFirstName = ""
    @State var authorLastName = ""
    @State var yearOfPublication = ""
    @State var numberOfPages = ""
    @State var estimatedReadingTime = "" // in hours
    @State var genre = Book.genres[0]
    @State var rating = "1"
    @State var notes = ""
    @State var errorMsg = ""
    let viewTitle: String
    let buttonLabel: String
    var book: Book?
    
    init(viewTitle: String, buttonLabel: String) {
        self.viewTitle = viewTitle
        self.buttonLabel = buttonLabel
    }
    
    init(viewTitle: String, buttonLabel: String, book: Book) {
        self.init(viewTitle: viewTitle, buttonLabel: buttonLabel)
        _title = State(initialValue: book.title)
        _authorFirstName = State(initialValue: book.author.firstName)
        _authorLastName = State(initialValue: book.author.lastName)
        _yearOfPublication = State(initialValue: String(book.yearOfPublication))
        _numberOfPages = State(initialValue: String(book.numberOfPages))
        _estimatedReadingTime = State(initialValue: String(book.estimatedReadingTime))
        _genre = State(initialValue: book.genre)
        _rating = State(initialValue: String(book.rating))
        _notes = State(initialValue: book.notes == nil ? "" : book.notes!)
        self.book = book
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Book Information (Required)")) {
                        TextField("Title", text: $title)
                        TextField("Publication year", text: $yearOfPublication)
                            .keyboardType(.decimalPad)
                        HStack (spacing: 0) {
                            Text("Choose a genre: ")
                            Picker("", selection: $genre) {
                                ForEach(Book.genres, id:\.self) { g in
                                    Text(g)
                                }
                            }
                            .foregroundColor(.black)
                            .pickerStyle(.menu)
                        }
                        
                    }
                    Section(header: Text("Author Information (Required)")) {
                        TextField("First name", text: $authorFirstName)
                        TextField("Last name", text: $authorLastName)
                    }
                    
                    Section(header: Text("Reading Information (Required)")) {
                        TextField("Number of pages", text: $numberOfPages)
                            .keyboardType(.decimalPad)
                        TextField("Estimated reading time (hrs)", text: $estimatedReadingTime)
                            .keyboardType(.decimalPad)
                        
                        HStack (spacing: 0) {
                            Text("Rate book: ")
                            Picker("", selection: $rating) {
                                ForEach(1...5, id: \.self) { i in
                                    Text(String(i)).tag(String(i))
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        
                    }
                    
                    Section(header: Text("Notes (optional)")) {
                        TextEditor(text: $notes)
                    }
                    
                    if (errorMsg != "") {
                        Label(errorMsg, systemImage: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    
                }
                .navigationBarTitle(viewTitle)
                
                HStack {
                    Spacer()
                    // MARK: ADD and EDIT button
                    Button {
                        do {
                            // test each property to cutomize error message as much as possible
                            yearOfPublication = Utilities.parseString(yearOfPublication)
                            if !Book.isValidTitle(title) {
                                errorMsg = "Please enter a valid title. The title must be at least one non-whitespace character."
                            } else if !Book.isValidYear(yearOfPublication) {
                                errorMsg = "Please enter a valid publication year."
                            } else if !Book.isValidAuthorName(authorFirstName) || !Book.isValidAuthorName(authorLastName) {
                                errorMsg = "Please enter a valid author name."
                            } else if Int(numberOfPages) == nil {
                                errorMsg = "Please enter a valid number of pages. The number must to an integer."
                            } else if !Book.isValidPages(Int(numberOfPages)!) {
                                errorMsg = "Please enter a valid number of pages. The number must be positive."
                            } else if Double(estimatedReadingTime) == nil {
                                errorMsg = "Please enter a valid reading time. The time must be a decimal number or integer."
                            } else if !Book.isValidReadingTime(Double(estimatedReadingTime)!) {
                                errorMsg = "Please enter a valid reading time. The time must be positive."
                            } else {
                                // use enum
                                // MARK: Add Button
                                if buttonLabel == "Add" {
                                    // sage to force unwrap values because we passed the validation checks
                                    let newBook = try Book(title: title, authorFirstName: authorFirstName, authorLastName: authorLastName, yearOfPublication: Int(yearOfPublication)!, numberOfPages: Int(numberOfPages)!, estimatedReadingTime: Double(estimatedReadingTime)!, genre: genre, rating: Int(rating)!, notes: notes)
                                    libraryModel.addBook(newBook)
                                // MARK: Edit Button
                                } else if buttonLabel == "Edit" {
                                    let b = book!
                                    b.title = title
                                    b.author.firstName = authorFirstName
                                    b.author.lastName = authorLastName
                                    b.genre = genre
                                    b.yearOfPublication = Int(yearOfPublication)!
                                    b.numberOfPages = Int(numberOfPages)!
                                    b.estimatedReadingTime = Double(estimatedReadingTime)!
                                    b.rating = Int(rating)!
                                    b.notes = notes
                                    libraryModel.editBook()
                                }
                                
                                errorMsg = ""
                                dismiss()
                            }
                        } catch {
                            print(error)
                            errorMsg = "Invalid data entered"
                        }
                    } label : {
                        Text(buttonLabel)
                            .frame(maxWidth: 100, maxHeight: 40)
                            .background(accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Spacer()
                    Button {
                        dismiss()
                    } label : {
                        Text("Cancel")
                            .frame(maxWidth: 100, maxHeight: 40)
                            .background(accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
                .padding()
            }
        }
        .accentColor(accentColor)
        
    }
}

struct BookFormView_Previews: PreviewProvider {
    static var previews: some View {
        BookFormView(viewTitle: "Add Book", buttonLabel: "Add")
            .environmentObject(LibraryModel())
    }
}

//
//  BookDetailView.swift
//  Library
//
//  Created by Ayesha Ilyas on 4/13/22.
//

import SwiftUI

struct BookDetailView: View {
    @EnvironmentObject var libraryModel: LibraryModel
    @State private var showingSheet = false
    @State private var confirmationShown = false
    let book: Book
    let index: Int
    
    var body: some View {
        // MARK: Book Information
        ScrollView {
            LazyVStack (alignment: .leading) {
                Text("By \(book.author.firstName) \(book.author.lastName)")
                Text(verbatim: "Publication Date: \(book.yearOfPublication)")
                HStack (spacing: 0) {
                    Text("Genre: ")
                    Text(book.genre)
                        .italic()
                } // end of HStack
                
                Divider()
                
                Text("Reading Data")
                    .font(.title)
                Text("Number of pages: \(book.numberOfPages)")
                // verbatim argument label means that the output with be formatted exactly as the underlying data
                Text(verbatim: "Estimated reading time: \(book.estimatedReadingTime)")
                
                HStack (spacing: 1) {
                    Text("Rating:")
                    // output stars for rating
                    ForEach(1...book.rating, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .font(.system(size: 15))
                            .foregroundColor(.yellow)
                    }
                }
                
                // if there are notes and the notes are not jusst white space, display them
                if let n = book.notes, !Utilities.isEmpty(book.notes!) {
                    Text("Notes")
                        .font(.title)
                        .padding(.top, 10)
                    Text(n)
                }
            }
            .padding([.leading, .trailing])
        } // end of ScrollView
        .navigationBarTitle(book.title)
        
        HStack (spacing: 80) {
            
            // MARK: Delete Button
            Button {
                confirmationShown = true
            } label: {
                Image(systemName: "trash.fill")
                    .font(.system(size: 25))
            }
            .buttonStyle(PlainButtonStyle())
            .confirmationDialog(
                "Are you sure you want to delete this book?",
                isPresented: $confirmationShown) {
                    Button("Delete") {
                        libraryModel.deleteBook(at: index)
                    }
                }
            
            // MARK: Edit Book
            Button {
                showingSheet.toggle()
            } label: {
                Image(systemName: "pencil")
                    .font(.system(size: 25))
            }
            .buttonStyle(PlainButtonStyle())
            .fullScreenCover(isPresented: $showingSheet) {
                BookFormView(viewTitle: "Edit Book", buttonLabel: "Edit", book: book)
            }
        } // end of HStack
        .foregroundColor(.black)
        .padding(15)
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(book: LibraryModel().books[0], index: 0)
    }
}

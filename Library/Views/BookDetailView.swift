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
        ScrollView {
            LazyVStack (alignment: .leading) {
                Text("By \(book.author.firstName) \(book.author.lastName)")
                Text(verbatim: "Publication Date: \(book.yearOfPublication)")
                HStack (spacing: 0) {
                    Text("Genre: ")
                    Text(book.genre)
                        .italic()
                }
                
                Divider()
                
                Text("Reading Data")
                    .font(.title)
                Text("Number of pages: \(book.numberOfPages)")
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
                
                // if there are notes, display them
                if let n = book.notes, !Utilities.isEmpty(book.notes!) {
                    Text("Notes")
                        .font(.title)
                        .padding(.top, 10)
                    Text(n)
                }
            }
            .padding([.leading, .trailing])
                    }
        .navigationTitle(book.title)
        
        HStack (spacing: 80) {
            Spacer()
            
            // MARK: Delete Button
            Button {
                print("Deleting")
                confirmationShown = true
            } label: {
                Image(systemName: "trash.fill")
                .font(.system(size: 25))
            }
            .confirmationDialog(
                "Are you sure you want to delete this book?",
                isPresented: $confirmationShown) {
                Button("Delete") {
                    libraryModel.deleteBook(at: index)
                }
            }
            
            // MARK: Edit Book
            Button {
                print("Editing")
                showingSheet.toggle()
            } label: {
                Image(systemName: "pencil")
                    .font(.system(size: 25))
            }
            .buttonStyle(PlainButtonStyle())
            .fullScreenCover(isPresented: $showingSheet) {
                BookFormView(viewTitle: "Edit Book", buttonLabel: "Edit", book: book)
            }
            Spacer()
        }
        .foregroundColor(.black)
        .padding(10)
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(book: LibraryModel().books[0], index: 0)
    }
}

//
//  LibraryView.swift
//  Library
//
//  Created by Ayesha Ilyas on 4/12/22.
//

import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var libraryModel: LibraryModel
    @State private var showingSheet = false
    @State private var sectionize = true
    private let accentColor = Color(red: 0.929, green: 0.102, blue: 0.365)
    
    var body: some View {
        NavigationView {
            VStack {
                // MARK: Bulk Book Actions Toolbar
                Divider()
                
                HStack (spacing: 7) {
                    
                    // MARK: Sort By Title Button
                    Button {
                        libraryModel.sortByTitle()
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                            .padding(.leading, 25)
                    }.buttonStyle(PlainButtonStyle())
                    
                    // MARK: Book Count Label
                    Text("Count: \(libraryModel.numberOfBooks)")
                
                    Spacer()
                    
                    // MARK: Show Sections Toggle
                    Toggle("Show genres", isOn: $sectionize)
                        .toggleStyle(CheckToggleStyle())
                        .padding(.trailing, 25)

                }
                .foregroundColor(accentColor)
                
                ZStack {
                    // Book List
                    // MARK: With sections shown
                    if sectionize {
                        // for each genre, display all the books in the genre in a section
                        List(libraryModel.usedGenres, id: \.self) { g in
                            Section(header: Text(g)) {
                                ForEach (0..<libraryModel.books.count) { index in
                                    let book = libraryModel.books[index]
                                    if book.genre == g {
                                        NavigationLink(destination: BookDetailView(book: book, index: index)) {
                                            Text("\(book.title) by \(book.author.lastName)")
                                                .frame(height: 20)
                                                .truncationMode(.tail)
                                                .foregroundColor(.black)
                                        }.buttonStyle(PlainButtonStyle()) // remove blue highlighting on NavigationLink items when tapped
                                        
                                    }
                                }
                            }
                        } // end of List
                    }
                    
                    // MARK: Without sections
                    else {
                        List(0..<libraryModel.books.count, id: \.self) { i in
                            let book = libraryModel.books[i]
                            NavigationLink(destination: BookDetailView(book: book, index: i)) {
                                Text("\(book.title) by \(book.author.lastName)")
                                    .frame(height: 20)
                                    .truncationMode(.tail)
                                    .foregroundColor(.black)
                            }
                            .buttonStyle(PlainButtonStyle()) // remove blue highlighting on NavigationLink items when tapped
                        } // end of List
                    }
                    
                    
                    // MARK: Add Button
                    GeometryReader { geo in
                        Button {
                            showingSheet.toggle()
                        } label: {
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    ZStack {
                                        Image(systemName: "circle.fill")
                                            .position(x: geo.size.width - 70, y: geo.size.height - 70)
                                            .font(.system(size: 60))
                                            .foregroundColor(.white)
//                                            .shadow(color: Color(UIColor.lightGray), radius: 10, x: 5, y: 7)
                                        
                                        Image(systemName: "plus.circle.fill")
                                            .position(x: geo.size.width - 70, y: geo.size.height - 70)
                                            .font(.system(size: 60))
                                            .foregroundColor(accentColor)
                                    }
                                    
                                }
                            }
                        } // end of Button label closure
                        .buttonStyle(PlainButtonStyle())
                        .fullScreenCover(isPresented: $showingSheet) {
                            BookFormView(viewTitle: "Add Book", buttonLabel: "Add")
                        }
                    } // end of GeometryReader
                    
                } // end of ZStack
                
            } // end of VStack
            .navigationBarTitle("Library")
        }
        .accentColor(accentColor)
        
    }
    
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}

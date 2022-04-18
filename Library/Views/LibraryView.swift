//
//  LibraryView.swift
//  Library
//
//  Created by Ayesha Ilyas on 4/12/22.
//

import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var libraryModel: LibraryModel
    @State var showingSheet = false
    private let accentColor = Color(red: 0.929, green: 0.102, blue: 0.365)
    
    var body: some View {
        NavigationView {
            VStack {
                // MARK: Bulk Book Actions Toolbar
                Divider()
                
                HStack {
                    // MARK: Book Count Label
                    Text("Count: \(libraryModel.numberOfBooks)")
                        .padding(.horizontal, 25)
                    
                    Spacer()
                    
                    // MARK: Sort By Title Button
                    Button {
                        libraryModel.sortByTitle()
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                            .padding(.horizontal)
                    }.buttonStyle(PlainButtonStyle())
                }
                .foregroundColor(accentColor)
                
                ZStack {
                    // MARK: Book List
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
    }
    
    
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}

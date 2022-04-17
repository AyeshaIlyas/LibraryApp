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
    
    var body: some View {
        NavigationView {
            
            ZStack {
                List(0..<libraryModel.books.count, id: \.self) { i in
                    let book = libraryModel.books[i]
                    NavigationLink(destination: BookDetailView(book: book, index: i)) {
                        Text("\(book.title) by \(book.author.lastName)")
                            .frame(height: 20)
                            .truncationMode(.tail)
                            .foregroundColor(.black)
                    }
                    .buttonStyle(PlainButtonStyle()) // remove blue highlighting on NavigationLink items when tapped
                }
                .navigationBarTitle("Library")
                
                Button {
                    showingSheet.toggle()
                } label: {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            ZStack {
                                Image(systemName: "circle.fill")
                                    .padding(.trailing, 35)
                                    .font(.system(size: 60))
                                    .foregroundColor(.white)
                                
                                Image(systemName: "plus.circle.fill")
                                    .padding(.trailing, 35)
                                    .font(.system(size: 60))
                                    .foregroundColor(Color(red: 0.929, green: 0.102, blue: 0.365))
                            }
                            
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .fullScreenCover(isPresented: $showingSheet) {
                    BookFormView(viewTitle: "Add Book", buttonLabel: "Add")
                }
                
                
            }
        }
    }
    

}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}

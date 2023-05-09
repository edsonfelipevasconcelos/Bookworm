//
//  AddBookView.swift
//  Bookworm
//
//  Created by EDSON FELIPE VASCONCELOS on 04/05/23.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss

    @State private var title = ""
    @State private var author = ""
    @State private var genre = "Unknown"
    @State private var review = ""
    @State private var rating = 3
    @State private var date = Date.now
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller", "Unknown"]
    
    var hasValidBook: Bool {
        if title.trimmingCharacters(in: .whitespaces).isEmpty || author.trimmingCharacters(in: .whitespaces).isEmpty || review.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        } else {
            return true
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $title)
                    TextField("Author", text: $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section {
                    TextEditor(text: $review)
                    
                    RatingView(rating: $rating)
                } header: {
                    Text("Write a review")
                }
                
                Section {
                    Button("Save") {
                        let newBook = Book(context: moc)
                        newBook.id = UUID()
                        newBook.title = title
                        newBook.author = author
                        newBook.genre = genre
                        newBook.review = review
                        newBook.rating = Int16(rating)
                        newBook.date = date
                        if moc.hasChanges {
                            try? moc.save()
                        }
                        
                        dismiss()
                    }
                }
                .disabled(hasValidBook == false)
            }
            .navigationTitle("Add Book")
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}

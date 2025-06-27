//
//  ContentView.swift
//  Memorize
//
//  Created by Stefan Tadić on 27. 6. 2025..
//

import SwiftUI

// MARK: - Theme Struct
struct Theme {
    let name: String
    let emojis: [String]
    let numberOfPairs: Int
    let symbolName: String // SF Symbol
}

// MARK: - Card Model
struct Card: Identifiable {
    let id: Int
    let emoji: String
    var isFaceUp: Bool = false
}

// MARK: - Main ContentView
struct ContentView: View {
    @State private var cards: [Card] = []
    
    let themes: [Theme] = [
        Theme(name: "Animals", emojis: ["🐌", "🐇", "🐷", "🦎", "🦙", "🦁", "🦃", "🦅", "🐵", "🦋", "🦓"], numberOfPairs: 4, symbolName: "hare.fill"),
        Theme(name: "Fruits", emojis: ["🍎", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🍒", "🍑", "🍐"], numberOfPairs: 6, symbolName: "applelogo"),
        Theme(name: "Faces", emojis: ["😍", "😁", "😂", "🙃", "😆", "😄", "😜", "😎", "🤓", "🤖"], numberOfPairs: 8, symbolName: "smiley.fill"),
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Memorize")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.horizontal)
                    .padding(.top)
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                        ForEach($cards) { $card in
                            CardView(card: $card)
                                .aspectRatio(2/3, contentMode: .fit)
                        }
                    }
                    .padding()
                }
                themeButtons
            }
            .onAppear {
                startGame(with: themes[0])
            }
        }
    }
    
    var themeButtons: some View {
        HStack(spacing: 16) {
            ForEach(themes, id: \.name) { theme in
                Button(action: {
                    startGame(with: theme)
                }) {
                    VStack {
                        Image(systemName: theme.symbolName)
                            .font(.largeTitle)
                        Text(theme.name)
                            .font(.caption)
                            .lineLimit(1)
                    }
                    .padding(10)
                    .frame(width: 90)
                    .padding(.vertical, 8)
                    .foregroundColor(.blue)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .padding(.bottom)
    }
    
    func startGame(with theme: Theme) {
        let selected = theme.emojis.shuffled().prefix(theme.numberOfPairs)
        let paired = Array(selected + selected).shuffled()
        cards = paired.enumerated().map { index, emoji in
            Card(id: index, emoji: emoji)
        }
    }
}

// MARK: - Card View
struct CardView: View {
    @Binding var card: Card
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 16)
            if card.isFaceUp {
                shape.fill(.white)
                shape.strokeBorder(.orange, lineWidth: 3)
                Text(card.emoji)
                    .font(.largeTitle)
            } else {
                shape.fill(.orange)
            }
        }
        .onTapGesture {
            card.isFaceUp.toggle()
        }
        .padding(4)
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}


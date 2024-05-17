//
//  ContentView.swift
//  Rock Paper Scissors Game
//
//  Created by Vincent Leong on 11/4/2024.
//
import SwiftUI

struct ContentView: View {
@State private var choice = ""
@State private var pw = ""
@State private var tapCount = 0
@State private var gameOutput = "Rock-Paper-Scissors Game!"
@State private var bet = 0
@State private var points = 0
@State private var computerChoice = ""
@State private var showDetail = false
let choices = ["r", "p", "s"]

    var body: some View {
        VStack {
            Section {
                Form {
                    Button("Bet: \(bet)"){
                        bet += 1
                    }
                Button{
                    withAnimation {
                        showDetail.toggle()
                    }
                } label: {
                    Label("Graph", systemImage: "chevron.right.circle")
                        .labelStyle(.iconOnly)
                        .imageScale(.large)
                        .rotationEffect(.degrees(showDetail ? 90 : 0))
                        .scaleEffect(showDetail ? 1.5 : 1)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                        
                }
                    if showDetail {
                        
                        Button("Bet x 10"){
                            bet += 10
                        }
                        Button("Hold back"){
                            if bet != 0 {
                                bet -= 1
                            }
                        }
                        Button("Hold back x 10"){
                            if bet >= 10 {
                                bet -= 10
                            }
                        }
                        Button("Reset"){
                            bet = 0
                        }
                    }
                }
                Section {
                    Text(emojiForChoice(choice: computerChoice))
                        .font(.system(size: 100))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                } header: {
                    Text("Computer:")
                }
                Section {
                    Text(emojiForChoice(choice: choice))
                        .font(.system(size: 100))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                } header: {
                    Text("Your Choice:")
                }
                Section {
                    Picker("", selection: $choice) {
                        ForEach(choices, id:\.self){ choice in
                            Text(choice.capitalized)
                        }
                        .padding()
                    } .pickerStyle(.palette)
//                    Text("Your choice is '\(choice.capitalized)'")
                } header: {
                    Text("Enter 'r' for rock, 'p' for paper, or 's' for scissors")
                }
//                Text(gameOutput)
                Text("\(points)")
                    .padding()
                Button("Play") {
                    playRockPaperScissors()
                }
            }
        }
    }
    
    func playRockPaperScissors() {
        let player = getUserChoice()
        let computer = getComputerChoice()
        computerChoice = String(computer)
        let result = determineWinner(player: player, computer: computer)
        gameOutput = "Your choice: \(showChoice(choice: player))\n" +
        "Computer's choice: \(showChoice(choice: computer))\n" +
        result
    }
    
    func getUserChoice() -> Character {
        if (choice == "p" || choice == "r" || choice == "s" || choice == "P" || choice == "R" || choice == "S"){
            return Character(choice.lowercased())
        } else {
            return Character("E")
        }
    }
    
    func getComputerChoice() -> Character {
        return ["r", "p", "s"].randomElement()!
    }
    
    func showChoice(choice: Character) -> String {
        switch choice {
        case "r": return "Rock"
        case "p": return "Paper"
        case "s": return "Scissors"
        default: return ""
        }
    }
    
    func determineWinner(player: Character, computer: Character) -> String {
        switch player {
        case "r":
            if computer == "r" {
                return "Tie"
            } else if computer == "p" {
                points -= bet
                return "Computer wins"
            } else {
                points += bet
                return "You win"
            }
        case "p":
            if computer == "r" {
                points += bet
                return "You win"
            } else if computer == "p" {
                return "Tie"
            } else {
                points -= bet
                return "Computer wins"
            }
        case "s":
            if computer == "r" {
                points -= bet
                return "Computer wins"
            } else if computer == "p" {
                points += bet
                return "You win"
            } else {
                return "Tie"
            }
        default: return "Invalid choice"
        }
    }
}

func emojiForChoice( choice: String) -> String {
    switch choice {
    case "r": return "🪨"
    case "p": return "📄"
    case "s": return "✂️"
    default: return ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

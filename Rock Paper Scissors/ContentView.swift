//
//  ContentView.swift
//  Rock Paper Scissors
//
//  Created by Vincent Leong on 5/31/24.
//

import SwiftUI

struct ContentView: View {
    @State private var choice = ""
    @State private var gameOutput = "Rock-Paper-Scissors Game!"
    @State private var bet = 1
    @State private var points = 0
    @State private var computerChoice = ""
    @State private var playerAnimationAmount: CGFloat = 1.0
    @State private var computerAnimationAmount:CGFloat = 1.0
    @State private var started = false
    
    let choices = ["Rock", "Paper", "Scissors"]
    
    var body: some View {
        
        VStack {
            Spacer()
                .frame(height: 10)
            Stepper("Bet: \(bet)", value: $bet, in: 1...Int.max)
                .padding()
            HStack {
                if(started == true) {
                Text(emojiForChoice(choice: computerChoice))
                    .font(.system(size: 100))
                    .padding()
                    .scaleEffect(computerAnimationAmount)
                    .animation(.easeInOut(duration: 0.6), value: computerAnimationAmount)
                    .onAppear {
                        if computerAnimationAmount > 1.0 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation {
                                    computerAnimationAmount = 1.0
                                }
                            }
                            }
                        }
                    }
                
                Text(emojiForChoice(choice: choice))
                    .font(.system(size: 100))
                    .padding()
                    .scaleEffect(playerAnimationAmount)
                    .animation(.easeInOut(duration: 0.6), value: playerAnimationAmount)
                    .onAppear {
                        if playerAnimationAmount > 1.0 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation {
                                    playerAnimationAmount = 1.0
                                }
                            }
                        }
                    }
            }
            Text("Points: \(points)")
//            Text(gameOutput)
            ZStack {
                WheelPicker(choices: choices, choice: $choice)
                    .edgesIgnoringSafeArea(.bottom)

                Button("Play") {
                    playRockPaperScissors()
                    started = true
                    if computerAnimationAmount > 1.0 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                computerAnimationAmount = 1.0
                            }
                        }
                    }
                    if playerAnimationAmount > 1.0 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                playerAnimationAmount = 1.0
                            }
                        }
                    }
                }
                .padding(20)
                .contentShape(Rectangle())
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

            }

        }
    }
    
    func playRockPaperScissors() {
            let player = choice
            let computer = getComputerChoice()
            computerChoice = computer
            let result = determineWinner(player: player, computer: computer)
            gameOutput = "Your choice: \(player)\n" +
            "Computer's choice: \(computer)\n" +
            result
            if result == "You win" {
                playerAnimationAmount = 1.4
            } else if result == "Computer wins" {
                computerAnimationAmount = 1.4
            } else if result == "Tie" {
                playerAnimationAmount = 1.6
                computerAnimationAmount = 1.6
            }
        }
        func getUserChoice() -> String {
            if (choice == "p" || choice == "r" || choice == "s" || choice == "P" || choice == "R" || choice == "S"){
                return String(choice.lowercased())
            } else {
                return String("E")
            }
        }
    
        func getComputerChoice() -> String {
            return choices.randomElement()!
        }
    
    func showChoice(choice: String) -> String {
        switch choice {
        case "Rock": return "Rock"
        case "Paper": return "Paper"
        case "Scissors": return "Scissors"
        default: return "Invalid choice"
        }
    }
    
    func determineWinner(player: String, computer: String) -> String {
            switch player {
            case "Rock":
                if computer == "Rock" {
                    return "Tie"
                } else if computer == "Paper" {
                    points -= bet
                    return "Computer wins"
                } else {
                    points += bet
                    return "You win"
                }
            case "Paper":
                if computer == "Rock" {
                    points += bet
                    return "You win"
                } else if computer == "Paper" {
                    return "Tie"
                } else {
                    points -= bet
                    return "Computer wins"
                }
            case "Scissors":
                if computer == "Rock" {
                    points -= bet
                    return "Computer wins"
                } else if computer == "Paper" {
                    points += bet
                    return "You win"
                } else {
                    return "Tie"
                }
            default: return "Invalid choice"
            }
        }
    }
    
func emojiForChoice(choice: String) -> String {
        switch choice {
        case "Rock": return "🪨"
        case "Paper": return "📄"
        case "Scissors": return "✂️"
        default: return ""
        }
    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

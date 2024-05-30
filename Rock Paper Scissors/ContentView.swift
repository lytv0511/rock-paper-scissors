import SwiftUI

// WheelPicker view definition
struct WheelPicker: View {
    let choices: [String]
    @Binding var choice: String
    @State private var rotation: Double = 0
    @State private var finalAngle: Double = 0
    @State private var initialTouchAngle: Double? = nil
    let numberOfTicks = 100
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    Circle()
                        .stroke(lineWidth: 1)
                        .foregroundColor(.gray)
                    
                    ForEach(0..<numberOfTicks, id: \.self) { index in
                        Rectangle()
                            .frame(width: 2, height: index % 5 == 0 ? 20 : 10)
                            .offset(y: -geometry.size.width/2 + 15 + (index % 5 == 0 ? -5 : 0))
                            .rotationEffect(Angle(degrees: 360 / Double(numberOfTicks) * Double(index)))
                    }
                    ForEach(0..<choices.count, id: \.self) { index in
                        Text(self.choices[index])
                            .offset(y: -geometry.size.width/2 + 50)
                            .rotationEffect(Angle(degrees: 360 / Double(choices.count) * Double(index)))
                            .rotationEffect(Angle(degrees: self.finalAngle), anchor: .center)
                            .font(.title)
                    }
                }
                
                .contentShape(Circle())
                .clipped()
                .frame(width: geometry.size.width, height: geometry.size.width)
                .rotationEffect(Angle(degrees: self.rotation))
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let vector = CGVector(dx: value.location.x - geometry.size.width / 2,
                                                  dy: value.location.y - geometry.size.height / 2)
                            let angle = atan2(vector.dy, vector.dx).radiansToDegrees
                            if self.initialTouchAngle == nil {
                                self.initialTouchAngle = angle
                            }
                            self.rotation = angle - (self.initialTouchAngle ?? 0)
                        }
                        .onEnded { _ in
                            self.finalAngle += self.rotation
                            self.rotation = 0
                            self.initialTouchAngle = nil
                            // Normalize the final angle to be within 0 to 360 degrees
                            let normalizedAngle = (360 - self.finalAngle.truncatingRemainder(dividingBy: 360)) + 360 / Double(choices.count) / 2
                            // Calculate the index of the top element
                            let index = Int((normalizedAngle / (360 / Double(choices.count))).truncatingRemainder(dividingBy: Double(choices.count)))
                            self.choice = self.choices[index]
                        }
                )
            }
            .aspectRatio(1, contentMode: .fit)
            .padding(.horizontal)
        }
    }
}

extension CGFloat {
    var radiansToDegrees: Double {
        return Double(self) * 180 / .pi
    }
}

// ContentView with integrated WheelPicker
struct ContentView: View {
    @State private var choice = ""
    @State private var pw = ""
    @State private var tapCount = 0
    @State private var gameOutput = "Rock-Paper-Scissors Game!"
    @State private var bet = 1
    @State private var points = 0
    @State private var computerChoice = ""
    @State private var showDetail = false
    @State private var playerAnimationAmount: CGFloat = 1.0
    @State private var computerAnimationAmount:CGFloat = 1.0
    @State private var started = false
    
    let choices = ["Rock", "Paper", "Scissors"]
    
    var body: some View {
        
        VStack {
            //                            Section {
            //                    Form {
            Spacer()
                .frame(height: 10)
            Stepper("Bet: \(bet)", value: $bet, in: 1...Int.max)
                .padding()
            
            
            //                        Button{
            //                            withAnimation {
            //                                showDetail.toggle()
            //                            }
            //                        } label: {
            //                            Label("Graph", systemImage: "chevron.right.circle")
            //                                .labelStyle(.iconOnly)
            //                                .imageScale(.large)
            //                                .rotationEffect(.degrees(showDetail ? 90 : 0))
            //                                .scaleEffect(showDetail ? 1.5 : 1)
            //                                .frame(maxWidth: .infinity, alignment: .center)
            //                                .padding()
            //
            //                        }
            //                        if showDetail {
            //                            Section {
            //                                Button("Bet x 10"){
            //                                    bet += 10
            //                                }
            //                                Button("Hold back x 10"){
            //                                    if bet >= 10 {
            //                                        bet -= 10
            //                                    }
            //                                }
            //                                Button("Reset"){
            //                                    bet = 0
            //                                }
            //                            }
            //                        }
            //                    }
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
            ZStack {
                WheelPicker(choices: choices, choice: $choice)
                    .edgesIgnoringSafeArea(.bottom)

                Button("Play") {
                    playRockPaperScissors()
                    started = true
                    // Reset animations after 1 second
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
                .padding(20) // Add padding to increase the tappable area
                .contentShape(Rectangle()) // Define the tappable area shape, Rectangle by default
                .background(Color.blue) // Set a background so you can see the button area
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
            
            // Reset animation amounts
//            playerAnimationAmount = 1.0
//            computerAnimationAmount = 1.0
        
            
            // Animate the winner
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

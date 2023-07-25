//
//  ContentView.swift
//  Click The Squares
//
//  Created by Elliot Mai on 7/25/23.
//

import SwiftUI

struct ContentView: View {
    @State private var score = 0
    @State private var timeRemaining = 30
    @State private var isGameActive = false
    @State private var squares = [Square]()
    @State private var highScore = 0

    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height

    let movementRangeX: ClosedRange<CGFloat> = 50...350
    let movementRangeY: ClosedRange<CGFloat> = 100...500

    
    var body: some View {
        VStack {
            Text("Score: \(score)")
                .font(.title)
            Text("Time: \(timeRemaining)")
                .font(.title)
                .padding(.bottom, 50)
            Text("High Score: \(highScore)")
                .font(.title)
                .padding(.bottom, 20)

            if isGameActive {
                ZStack {
                    ForEach(squares) { square in
                        Rectangle()
                            .fill(square.color)
                            .frame(width: 50, height: 50)
                            .position(square.position)
                            .onTapGesture {
                                removeSquare(square)
                            }
                    }
                }
                .animation(.easeInOut(duration: 0.5))
            } else {
                Button(action: startGame) {
                    Text("Start Game")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .onReceive(timer) { _ in
            if isGameActive {
                if timeRemaining > 0 {
                    timeRemaining -= 1
                    moveSquares()
                    addSquare()
                } else {
                    endGame()
                }
            }
        }
        .onChange(of: score) { newValue in
            if newValue > highScore {
                highScore = newValue
            }
        }
    }

    func startGame() {
        score = 0
        timeRemaining = 30
        isGameActive = true
        squares.removeAll()
    }

    func addSquare() {
        let color = Color.random
        let size: CGFloat = 50
        let x = CGFloat.random(in: size...screenWidth-size)
        let y = CGFloat.random(in: size...screenHeight-size)
        let square = Square(color: color, size: size, position: CGPoint(x: x, y: y))
        squares.append(square)
    }

    func removeSquare(_ square: Square) {
        if let index = squares.firstIndex(where: { $0.id == square.id }) {
            squares.remove(at: index)
            score += 1
        }
    }

    func endGame() {
        isGameActive = false
    }

    func moveSquares() {
            for i in 0..<squares.count {
                var square = squares[i]
                let dx = CGFloat.random(in: -10...10)
                let dy = CGFloat.random(in: -10...10)

                var newX = square.position.x + dx
                var newY = square.position.y + dy

                newX = min(max(newX, movementRangeX.lowerBound), movementRangeX.upperBound)
                newY = min(max(newY, movementRangeY.lowerBound), movementRangeY.upperBound)

                square.position.x = newX
                square.position.y = newY

                squares[i] = square
            }
        }
    }

struct Square: Identifiable {
    let id = UUID()
    let color: Color
    let size: CGFloat
    var position: CGPoint
}

extension Color {
    static var random: Color {
        Color(red: .random(in: 0...1),
              green: .random(in: 0...1),
              blue: .random(in: 0...1))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

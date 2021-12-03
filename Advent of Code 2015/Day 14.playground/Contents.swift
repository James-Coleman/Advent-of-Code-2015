import Foundation

var greeting = "Hello, playground"

struct Reindeer {
    // km/s
    let speed: Int
    let sprintTime: Int
    let restTime: Int
    
    func distanceAfter(time: Int) -> Int {
        var totalDistance = 0
        
        var timeRemaining = time
        
        while timeRemaining > 0 {
            let sprintingTime = min(sprintTime, timeRemaining)
            
            let sprintedDistance = speed * sprintingTime
            totalDistance += sprintedDistance
            
            timeRemaining -= sprintingTime
            
            guard timeRemaining > 0 else { break }
            
            let restingTime = min(restTime, timeRemaining)
            
            timeRemaining -= restingTime
        }
        
        return totalDistance
    }
}

let exampleComet = Reindeer(speed: 14, sprintTime: 10, restTime: 127)
let exampleDancer = Reindeer(speed: 16, sprintTime: 11, restTime: 162)

exampleComet.distanceAfter(time: 1)
exampleDancer.distanceAfter(time: 1)

exampleComet.distanceAfter(time: 10)
exampleDancer.distanceAfter(time: 10)

exampleComet.distanceAfter(time: 11)
exampleDancer.distanceAfter(time: 11)

exampleComet.distanceAfter(time: 1000)
exampleDancer.distanceAfter(time: 1000)

let puzzleRudolph = Reindeer(speed: 22, sprintTime: 8, restTime: 165)
let puzzleCupid = Reindeer(speed: 8, sprintTime: 17, restTime: 114)
let puzzlePrancer = Reindeer(speed: 18, sprintTime: 6, restTime: 103)
let puzzleDonner = Reindeer(speed: 25, sprintTime: 6, restTime: 145)
let puzzleDasher = Reindeer(speed: 11, sprintTime: 12, restTime: 125)
let puzzleComet = Reindeer(speed: 21, sprintTime: 6, restTime: 121)
let puzzleBlitzen = Reindeer(speed: 18, sprintTime: 3, restTime: 50)
let puzzleVixen = Reindeer(speed: 20, sprintTime: 4, restTime: 75)
let puzzleDancer = Reindeer(speed: 7, sprintTime: 20, restTime: 119)

let puzzleReinder = [puzzleRudolph, puzzleCupid, puzzlePrancer, puzzleDonner, puzzleDasher, puzzleComet, puzzleBlitzen, puzzleVixen, puzzleDancer]

let distances = puzzleReinder.map { $0.distanceAfter(time: 2503) }

let sorted = distances.sorted() // highest is 2696 (correct)

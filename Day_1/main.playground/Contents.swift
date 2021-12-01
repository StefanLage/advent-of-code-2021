import Foundation

let inputFilePath = Bundle.main.paths(forResourcesOfType: "txt", inDirectory: nil).first!
let inputFile = try! String(contentsOfFile: inputFilePath, encoding: .utf8)
let inputs: [Int] = inputFile.components(separatedBy: .newlines).compactMap { Int($0) }

struct PartOne {
    private static func previousMeasurementIncreases(in inputs: [Int]) -> Int {
        var previousIndex = -1
        var currentIndex = 0
        var largerThanPreviousCount = 0

        for _ in 0..<(inputs.count) {
            guard previousIndex >= 0 else {
                previousIndex = currentIndex
                currentIndex += 1

                continue
            }

            if inputs[previousIndex] < inputs[currentIndex] {
                largerThanPreviousCount += 1
            }

            previousIndex = currentIndex
            currentIndex += 1
        }

        return largerThanPreviousCount
    }

    static func run() {
        let depthIncreases = previousMeasurementIncreases(in: inputs)
        print("Depth measurement increases \(depthIncreases) times")
    }
}

struct PartTwo {
    private static func threeMeasurementIncreases(in inputs: [Int]) -> Int {

        guard var previousIndex = inputs.indices.first else {
            fatalError("WOOOOOW")
        }

        var currentIndex = previousIndex + 1
        var nextIndex = currentIndex + 1

        var previousSum = inputs[previousIndex] + inputs[currentIndex] + inputs[nextIndex]
        var largerThanPreviousCount = 0

        for _ in 0..<(inputs.count) {
            guard nextIndex < inputs.count else {
                break
            }

            let sum = inputs[previousIndex] + inputs[currentIndex] + inputs[nextIndex]
            if sum > previousSum {
                largerThanPreviousCount += 1
            }

            previousSum = sum
            previousIndex = currentIndex
            currentIndex += 1
            nextIndex = currentIndex + 1
        }

        return largerThanPreviousCount
    }

    static func run() {
        let sumIncreases = threeMeasurementIncreases(in: inputs)
        print("Sums measurement increases \(sumIncreases) times")
    }
}

PartOne.run()
PartTwo.run()

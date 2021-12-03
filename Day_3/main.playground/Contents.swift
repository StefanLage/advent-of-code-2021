import Foundation

let inputFilePath = Bundle.main.paths(forResourcesOfType: "txt", inDirectory: nil).first!
let inputFile = try! String(contentsOfFile: inputFilePath, encoding: .utf8)
let inputs: [String] = inputFile.components(separatedBy: .newlines).filter { $0.isEmpty == false }


struct PartOne {
    private static func gammaRate(of inputs: [String]) -> String {
        var gammaRate = ""
        for depthIndex in 0..<inputs.first!.count {
            var ones = 0
            var zeros = 0

            for rowIndex in 0..<inputs.count {
                let binary = inputs[rowIndex]

                if binary[binary.index(binary.startIndex, offsetBy: depthIndex)] == "1" {
                    ones += 1
                } else {
                    zeros += 1
                }
            }

            gammaRate.append((ones > zeros) ? "1" : "0")
        }

        return gammaRate
    }

    private static func epsilonRate(from gammaRate: String) -> String {
        var epsilonRate = ""
        for character in gammaRate {
            if character == "1" {
                epsilonRate.append("0")
            } else {
                epsilonRate.append("1")
            }
        }

        return epsilonRate
    }

    static func powerConsumption(of inputs: [String]) -> Int {
        let gammaRate = gammaRate(of: inputs)
        let epsilonRate = epsilonRate(from: gammaRate)

        return Int(gammaRate, radix: 2)! * Int(epsilonRate, radix: 2)!
    }
}

struct PartTwo {
    private enum CommonType: Equatable {
        typealias CompareType = (count: Int, value: String)

        case least, most

        private func compare(_ lhs: CompareType, _ rhs: CompareType) -> CompareType {
            switch self {
            case .least:
                return lhs.count >= rhs.count ? rhs : lhs
            case .most:
                return lhs.count >= rhs.count ? lhs : rhs
            }
        }

        func filter (x: CompareType, y: CompareType) -> String {
            return compare(x, y).value
        }
    }

    private static func rating(of inputs: [String], commonType: CommonType) -> String {
        var mutableInputs = inputs

        var previousDepth = 0
        while mutableInputs.count > 1 {
            for depthIndex in previousDepth..<mutableInputs.first!.count {
                var ones = 0
                var zeros = 0

                var location: [String: [Int]] = ["0": [], "1": []]

                for rowIndex in 0..<mutableInputs.count {
                    let binary = mutableInputs[rowIndex]

                    if binary[binary.index(binary.startIndex, offsetBy: depthIndex)] == "1" {
                        ones += 1
                        location["1"]?.append(rowIndex)
                    } else {
                        zeros += 1
                        location["0"]?.append(rowIndex)
                    }
                }

                let filter = commonType.filter(x: (ones, "1"), y: (zeros, "0"))
                let filterIndices = mutableInputs.indices.filter { indice in
                    return location[filter]!.contains(indice)
                }

                mutableInputs = filterIndices.compactMap { mutableInputs[$0] }
                previousDepth += 1

                break
            }
        }

        return mutableInputs.first!
    }

    static func lifeSupport(of inputs: [String]) -> Int {
        let oxygenGeneratorRating = rating(of: inputs, commonType: .most)
        let co2ScrubberRating = rating(of: inputs, commonType: .least)

        return Int(oxygenGeneratorRating, radix: 2)! * Int(co2ScrubberRating, radix: 2)!
    }
}

PartOne.powerConsumption(of: inputs)
PartTwo.lifeSupport(of: inputs)

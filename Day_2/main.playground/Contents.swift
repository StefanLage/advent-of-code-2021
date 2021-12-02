import Foundation

struct Command {
    enum CommandType: String {
        case down, forward, up
    }

    let type: CommandType
    let value: Int
}


let inputFilePath = Bundle.main.paths(forResourcesOfType: "txt", inDirectory: nil).first!
let inputFile = try! String(contentsOfFile: inputFilePath, encoding: .utf8)
let inputs: [Command] = inputFile.components(separatedBy: .newlines).compactMap { input in
    guard input.isEmpty == false else {
        return nil
    }

    let values = input.split(separator: " ")

    let type = Command.CommandType(rawValue: String(values.first!))!
    let value = Int(values.last!)!
    return Command(type: type, value: value)
}

struct PartOne {
    static func finalPosition(startHorizontalPosition: Int, startDepthPosition: Int, moves: [Command]) -> Int {

        var horizontal = startHorizontalPosition
        var depth = startDepthPosition

        for move in moves {
            switch move.type {
            case .forward:
                horizontal += move.value
            case .down:
                depth += move.value
            case .up:
                depth -= move.value
            }
        }

        return horizontal * depth
    }
}

struct PartTwo {
    static func finalPosition(startHorizontalPosition: Int,
                              startDepthPosition: Int,
                              aimPosition: Int,
                              moves: [Command]) -> Int {
        var horizontal = startHorizontalPosition
        var depth = startDepthPosition
        var aim = aimPosition

        for move in moves {
            switch move.type {
            case .forward:
                horizontal += move.value
                depth += move.value * aim
            case .down:
                aim += move.value
            case .up:
                aim -= move.value
            }
        }

        return horizontal * depth
    }
}


PartOne.finalPosition(startHorizontalPosition: 0, startDepthPosition: 0, moves: inputs)
PartTwo.finalPosition(startHorizontalPosition: 0, startDepthPosition: 0, aimPosition: 0, moves: inputs)

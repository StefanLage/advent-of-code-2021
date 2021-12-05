import Foundation

let ventsInputPath = Bundle.main.paths(forResourcesOfType: "txt", inDirectory: nil).first { $0.contains("vents") }!
let ventsInputFile = try! String(contentsOfFile: ventsInputPath, encoding: .utf8)
let vents: [Vent] = ventsInputFile.components(separatedBy: .newlines).compactMap { string in
    guard string.isEmpty == false else {
        return nil
    }

    let coordinatesRaw = string.components(separatedBy: " -> ")
    let startCoordinateRaw = coordinatesRaw.first!
    let endCoordinateRaw = coordinatesRaw.last!
    let startCoordinate = Vent.Coordinate(x: Int(startCoordinateRaw.split(separator: ",").first!)!,
                                          y: Int(startCoordinateRaw.split(separator: ",").last!)!)

    let endCoordinate = Vent.Coordinate(x: Int(endCoordinateRaw.split(separator: ",").first!)!,
                                        y: Int(endCoordinateRaw.split(separator: ",").last!)!)

    return Vent(startCoordinate: startCoordinate, endCoordinate: endCoordinate)
}




protocol VentOverlappable {
    static func drawOverlappingLines(from vents: [Vent], in matrix: inout [[String]])
    static func numberOfOverlappingLines(in vents: [Vent]) -> Int
}

extension VentOverlappable {
    static func emptyOverlappingMatrix(from vents: [Vent]) -> [[String]] {
        var maxX = 0
        var maxY = 0
        for vent in vents {
            maxX = max(maxX, max(vent.startCoordinate.x, vent.endCoordinate.x) + 1)
            maxY = max(maxY, max(vent.startCoordinate.y, vent.endCoordinate.y) + 1)
        }

        let template = [String](repeating: ".", count: maxX)
        return [[String]](repeating: template, count: maxY)
    }
}

struct PartOne: VentOverlappable {
    static func drawOverlappingLines(from vents: [Vent], in matrix: inout [[String]]) {
        // Iterate vents to mark each lines
        for vent in vents {
            if vent.startCoordinate.x == vent.endCoordinate.x {
                let x = vent.startCoordinate.x
                let startY = min(vent.startCoordinate.y, vent.endCoordinate.y)
                let endY = max(vent.startCoordinate.y, vent.endCoordinate.y)

                for y in startY...endY {
                    guard y < matrix.count else{
                        break
                    }

                    if let value = Int(matrix[y][x]) {
                        matrix[y][x] = "\(value + 1)"
                    } else {
                        matrix[y][x] = "1"
                    }
                }
            }

            if vent.startCoordinate.y == vent.endCoordinate.y {
                let startX = min(vent.startCoordinate.x, vent.endCoordinate.x)
                let endX = max(vent.startCoordinate.x, vent.endCoordinate.x)
                let y = vent.startCoordinate.y

                for x in startX...endX {
                    guard x < matrix.first!.count else{
                        break
                    }

                    if let value = Int(matrix[y][x]) {
                        matrix[y][x] = "\(value + 1)"
                    } else {
                        matrix[y][x] = "1"
                    }
                }
            }
        }
    }

    static func numberOfOverlappingLines(in vents: [Vent]) -> Int {
        var matrix = emptyOverlappingMatrix(from: vents)
        drawOverlappingLines(from: vents, in: &matrix)

        // Iterate matrix and count values > 2

        var count = 0
        for row in matrix {
            for value in row {
                if let number = Int(value), number > 1 {
                    count += 1
                }
            }
        }

        return count
    }
}

struct PartTwo: VentOverlappable {
    static func drawOverlappingLines(from vents: [Vent], in matrix: inout [[String]]) {
        // Iterate vents to mark each lines
        for vent in vents {
            if vent.startCoordinate.x == vent.endCoordinate.x {
                let x = vent.startCoordinate.x
                let startY = min(vent.startCoordinate.y, vent.endCoordinate.y)
                let endY = max(vent.startCoordinate.y, vent.endCoordinate.y)

                for y in startY...endY {
                    guard y < matrix.count else{
                        break
                    }

                    if let value = Int(matrix[y][x]) {
                        matrix[y][x] = "\(value + 1)"
                    } else {
                        matrix[y][x] = "1"
                    }
                }
            } else if vent.startCoordinate.y == vent.endCoordinate.y {
                let startX = min(vent.startCoordinate.x, vent.endCoordinate.x)
                let endX = max(vent.startCoordinate.x, vent.endCoordinate.x)
                let y = vent.startCoordinate.y

                for x in startX...endX {
                    guard x < matrix.first!.count else{
                        break
                    }

                    if let value = Int(matrix[y][x]) {
                        matrix[y][x] = "\(value + 1)"
                    } else {
                        matrix[y][x] = "1"
                    }
                }
            } else {
                let startX = vent.startCoordinate.x
                let endX = vent.endCoordinate.x
                let startY = vent.startCoordinate.y
                let endY = vent.endCoordinate.y

                var x = startX
                var y = startY
                let rangeX = (startX > endX) ? (endX...startX) : (startX...endX)
                let rangeY = (startY > endY) ? (endY...startY) : (startY...endY)
                while rangeY.contains(y) {
                    guard rangeX.contains(x) else {
                        break
                    }

                    if let value = Int(matrix[y][x]) {
                        matrix[y][x] = "\(value + 1)"
                    } else {
                        matrix[y][x] = "1"
                    }

                    x += (startX > endX) ? -1 : 1
                    y += (startY > endY) ? -1 : 1
                }
            }
        }
    }

    static func numberOfOverlappingLines(in vents: [Vent]) -> Int {
        var matrix = emptyOverlappingMatrix(from: vents)
        drawOverlappingLines(from: vents, in: &matrix)

        var count = 0
        for row in matrix {
            for value in row {
                if let number = Int(value), number > 1 {
                    count += 1
                }
            }
        }

        return count
    }
}

print(PartOne.numberOfOverlappingLines(in: vents))
print(PartTwo.numberOfOverlappingLines(in: vents))

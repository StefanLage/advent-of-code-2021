import Foundation

let numbersPlayedPath = Bundle.main.paths(forResourcesOfType: "txt", inDirectory: nil).first { $0.contains("numbers_played") }!
let numbersPlayedFile = try! String(contentsOfFile: numbersPlayedPath, encoding: .utf8)
let numbersPlayed: [Int] = numbersPlayedFile.components(separatedBy: .punctuationCharacters).compactMap { Int($0) }

// Read boards

let boardsPath = Bundle.main.paths(forResourcesOfType: "txt", inDirectory: nil).first { $0.contains("boards") }!
let boardsFile = try! String(contentsOfFile: boardsPath, encoding: .utf8)
let boardsInput: [String] = boardsFile.components(separatedBy: .newlines)


func extractBoards(from inputs: [String]) -> [Board] {
    var boards = [[String]]()
    var buffer = [String]()
    for board in inputs {
        guard board.isEmpty == false else {
            boards.append(buffer)
            buffer = []
            continue
        }

        buffer.append(contentsOf: board.components(separatedBy: .newlines))
    }

    return boards.map { board in
        let matrix: [[Board.MatrixValue]] = board.map { row in
            return row.components(separatedBy: .whitespaces).compactMap { c in
                guard let digit = Int(String(c)) else {
                    return nil
                }

                return Board.MatrixValue(digit: digit, mark: false)
            }
        }
        return Board(matrix: matrix)
    }
}

var boards = extractBoards(from: boardsInput)


struct PartOne {
    static func firstBoardWinningScore(in boards: [Board], with numbersPlayed: [Int]) -> Int{
        var boards = boards
        var winner = false

        for n in numbersPlayed {
            guard winner == false else {
                break
            }
            for (boardIndex, _) in boards.enumerated() {
                guard winner == false else {
                    break
                }


                let isComplete = boards[boardIndex].canMark(number: n)
                if isComplete {
                    let sum = boards[boardIndex].sum

                    winner = true
                    return sum * n
                }
            }
        }

        return 0
    }
}

struct PartTwo {
    static func lastBoardWinningScore(in boards: [Board], with numbersPlayed: [Int]) -> Int {
        var boards = boards
        var winners = [(board: Board, numberCompleting: Int)]()

        for n in numbersPlayed {
            guard winners.count < boards.count else {
                break
            }

            for (boardIndex, _) in boards.enumerated() {
                guard winners.count < boards.count else {
                    break
                }
                guard boards[boardIndex].isComplete == false else {
                    continue
                }

                let isComplete = boards[boardIndex].canMark(number: n)
                if isComplete {
                    winners.append((boards[boardIndex], n))
                }
            }
        }

        let lastWinner = winners.last!
        let sum = lastWinner.board.sum
        let total = sum * lastWinner.numberCompleting
        return total
    }
}

PartOne.firstBoardWinningScore(in: boards, with: numbersPlayed)
PartTwo.lastBoardWinningScore(in: boards, with: numbersPlayed)

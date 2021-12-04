import Foundation

public struct Board {
    public struct MatrixValue {
        public let digit: Int
        public var mark: Bool

        public init(digit: Int, mark: Bool) {
            self.digit = digit
            self.mark = mark
        }
    }

    public private(set) var matrix: [[MatrixValue]]
    public private(set) var isComplete: Bool = false
    
    public var sum: Int {
        var sum = 0
        for (rowIndex, _) in matrix.enumerated() {
            for value in matrix[rowIndex] {
                guard value.mark == false else {
                    continue
                }

                sum += value.digit
            }
        }

        return sum
    }

    public init(matrix: [[MatrixValue]]) {
        self.matrix = matrix
    }

    public mutating func canMark(number: Int) -> Bool {
        var numberFound = false

        for (rowIndex, row) in matrix.enumerated() {
            guard numberFound == false else {
                break
            }

            for (columnIndex, column) in row.enumerated() {
                guard column.digit == number else {
                    continue
                }

                matrix[rowIndex][columnIndex].mark = true
                numberFound = true
                if isComplete(rowIndex: rowIndex, columnIndex: columnIndex) {
                    return true
                } else {
                    return false
                }
            }
        }

        return false
    }

    private mutating func isComplete(rowIndex: Int, columnIndex: Int) -> Bool {
        // rows
        for idx in 0..<matrix[rowIndex].endIndex {
            guard matrix[rowIndex][idx].mark else {
                break
            }

            if idx == matrix[rowIndex].endIndex - 1 {
                isComplete = true
                return true
            }
        }

        // columns
        for idx in 0..<matrix.endIndex {
            guard matrix[idx][columnIndex].mark else {
                break
            }

            if idx == matrix.endIndex - 1 {
                isComplete = true
                return true
            }
        }

        return false
    }
}

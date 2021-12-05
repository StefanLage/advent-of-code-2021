import Foundation


public struct Vent {
    public struct Coordinate {
        public let x: Int
        public let y: Int

        public init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }
    }

    public let startCoordinate: Coordinate
    public let endCoordinate: Coordinate

    public init(startCoordinate: Coordinate, endCoordinate: Coordinate) {
        self.startCoordinate = startCoordinate
        self.endCoordinate = endCoordinate
    }
}

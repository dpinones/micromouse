namespace DataTypes {
    struct Cell {
        weight: felt,
        top: felt,
        right: felt,
        bottom: felt,
        left: felt,
    }

    struct Point {
        x: felt,
        y: felt,
    }

    struct Map {
        width: felt,
        start: Point,
        end: Point,
    }
}
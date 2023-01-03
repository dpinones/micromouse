%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin

from src.main import create_map, get_neighbors
from src.types.data_types import DataTypes

@external
func test_get_neighbors_happy_path{syscall_ptr: felt*, range_check_ptr, pedersen_ptr: HashBuiltin*}() {

    let start: DataTypes.Point = DataTypes.Point(0, 0);
    let end: DataTypes.Point = DataTypes.Point(2, 2);
    let cells: DataTypes.Cell* = alloc();

    //                                   ↑       →    ↓       ←
    assert cells[0] = DataTypes.Cell(1, FALSE, TRUE, FALSE, FALSE);
    assert cells[1] = DataTypes.Cell(0, TRUE, FALSE, FALSE, TRUE);
    assert cells[2] = DataTypes.Cell(9, TRUE, FALSE, FALSE, FALSE);
    assert cells[3] = DataTypes.Cell(0, TRUE, FALSE, FALSE, FALSE);
    assert cells[4] = DataTypes.Cell(0, TRUE, FALSE, TRUE, FALSE);
    assert cells[5] = DataTypes.Cell(0, TRUE, FALSE, TRUE, FALSE);
    assert cells[6] = DataTypes.Cell(0, FALSE, TRUE, TRUE, FALSE);
    assert cells[7] = DataTypes.Cell(0, FALSE, TRUE, TRUE, TRUE);
    assert cells[8] = DataTypes.Cell(0, FALSE, FALSE, TRUE, TRUE);

    let cells_len: felt = 9; 
    let width: felt = 3;
    let (map_id: felt) = create_map(width, start, end, cells_len, cells);

    let (result_points_len: felt, result_points: DataTypes.Point*) = get_neighbors(map_id, 1, 1); // x: 1, y: 1

    let expected_result_points: DataTypes.Point* = alloc();
    let expected_result_points_lenght = 2;
    assert expected_result_points[0] = DataTypes.Point(1, 2);
    assert expected_result_points[1] = DataTypes.Point(1, 0);

    assert result_points_len = expected_result_points_lenght;
    assert result_points[0] = expected_result_points[0];
    assert result_points[1] = expected_result_points[1];

    return ();
}
%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin

from src.micro_mouse import create_map, get_cells
from src.types.data_types import DataTypes

@external
func test_get_cells_happy_path{syscall_ptr: felt*, range_check_ptr, pedersen_ptr: HashBuiltin*}() {

    alloc_locals;
    let start: DataTypes.Point = DataTypes.Point(0, 0);
    let end: DataTypes.Point = DataTypes.Point(2, 2);
    let cells: DataTypes.Cell* = alloc();

    //                                   ↑       →    ↓       ←
    assert cells[0] = DataTypes.Cell(1, FALSE, TRUE, FALSE, FALSE);
    assert cells[1] = DataTypes.Cell(2, TRUE, FALSE, FALSE, TRUE);
    assert cells[2] = DataTypes.Cell(3, TRUE, FALSE, FALSE, FALSE);
    assert cells[3] = DataTypes.Cell(4, TRUE, FALSE, FALSE, FALSE);
    assert cells[4] = DataTypes.Cell(5, TRUE, FALSE, TRUE, FALSE);
    assert cells[5] = DataTypes.Cell(6, TRUE, FALSE, TRUE, FALSE);
    assert cells[6] = DataTypes.Cell(7, FALSE, TRUE, TRUE, FALSE);
    assert cells[7] = DataTypes.Cell(8, FALSE, TRUE, TRUE, TRUE);
    assert cells[8] = DataTypes.Cell(9, FALSE, FALSE, TRUE, TRUE);

    let cells_len: felt = 9; 
    let width: felt = 3;
    let (map_id: felt) = create_map(width, start, end, cells_len, cells);

    let (result_cells_len: felt, result_cells: DataTypes.Cell*) = get_cells(map_id);

    assert result_cells_len = cells_len;

    assert result_cells[0] = cells[0];
    assert result_cells[1] = cells[1];
    assert result_cells[2] = cells[2];
    assert result_cells[3] = cells[3];
    assert result_cells[4] = cells[4];
    assert result_cells[5] = cells[5];
    assert result_cells[6] = cells[6];
    assert result_cells[7] = cells[7];
    assert result_cells[8] = cells[8];

    return ();
}
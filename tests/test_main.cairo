%lang starknet
from src.main import create_map, Point, maps, map_list, map_count
from src.constants.grid import X
from starkware.cairo.common.cairo_builtins import HashBuiltin

@external
func test_create_map{syscall_ptr: felt*, range_check_ptr, pedersen_ptr: HashBuiltin*}() {

    let start: Point = Point(0, 0);
    let end: Point = Point(15, 15);
    tempvar map_grids: felt* = cast(new(0, X, 0,
                                        X, 8, 0,
                                        X, 0, X),  felt*);
    let map_grids_len: felt = 9; 
    let (map_id: felt) = create_map(start, end, map_grids_len, map_grids);

    let count: felt = map_count.read();
    assert count = 1;

    let map_0: felt = map_list.read(map_id, 0);
    assert map_0 = 0;

    let map_4: felt = map_list.read(map_id, 4);
    assert map_4 = 8;

    let map_8: felt = map_list.read(map_id, 8);
    assert map_8 = X;

    return ();
}
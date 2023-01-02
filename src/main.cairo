%lang starknet
from starkware.cairo.common.math import assert_nn
from starkware.cairo.common.cairo_builtins import HashBuiltin

from src.utils.point_converter import convert_coords_to_id

struct Point {
    x: felt,
    y: felt,
}

struct Map {
    start: Point,
    end: Point,
}

@storage_var
func maps(map_id: felt) -> (res: Map) {
}

@storage_var
func map_list(map_id: felt, index: felt) -> (data: felt) {
}

@storage_var
func map_count() -> (res: felt) {
}

// solo el owner puede crear mapas
@external
func create_map{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    start: Point, end: Point, grids_len: felt, grids: felt*
) -> (map_id: felt) {
    alloc_locals;
    let (map_id: felt) = map_count.read();
    
    maps.write(map_id, Map( 
        start,
        end,
    ));

    // 0: index of map
    _create_map(map_id, 0, grids_len, grids);
    
    map_count.write(map_id + 1);

    return (map_id,);
}

@external
func get_cell{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(map_id: felt, x: felt, y: felt) -> (cell: felt) {
    let coord: felt = convert_coords_to_id(x, y);
    let (cell: felt) = map_list.read(map_id, coord);
    return (cell,);
}

// Internals
func _create_map{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    map_id: felt, index: felt, grids_len: felt, grids: felt*
) {
    if (grids_len == 0) {
        return ();
    }

    _create_map(map_id, index + 1, grids_len - 1, grids + 1);
    map_list.write(map_id, index, grids[0]);
    return(); 
}


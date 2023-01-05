%lang starknet
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin

from src.types.data_types import DataTypes
from src.utils.point_converter import convert_coords_to_id

// User

@storage_var
func user_list(map_id: felt, user_id: felt) -> (user_address: felt) {
}

@storage_var
func user_count() -> (res: felt) {
}

@storage_var
func user_steps(user_address: felt) -> (steps: felt) {
}

@storage_var
func user_contract_address(user_address: felt) -> (contract_address: felt) {
}

// Map

@storage_var
func maps(map_id: felt) -> (res: DataTypes.Map) {
}

@storage_var
func map_list(map_id: felt, index: felt) -> (data: DataTypes.Cell) {
}

@storage_var
func map_count() -> (res: felt) {
}

// solo el owner puede crear mapas
@external
func create_map{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    width: felt, start: DataTypes.Point, end: DataTypes.Point, cells_len: felt, cells: DataTypes.Cell*
) -> (map_id: felt) {
    alloc_locals;
    let (map_id: felt) = map_count.read();
    
    maps.write(map_id, DataTypes.Map( 
        width,
        start,
        end,
    ));

    // 0: index of map
    _create_map(map_id, 0, cells_len, cells);
    
    map_count.write(map_id + 1);

    return (map_id,);
}
@view 
func get_cells{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    map_id: felt
) -> (cells_len: felt, cells: DataTypes.Cell*) {
    alloc_locals;
    let (map: DataTypes.Map) = maps.read(map_id);
    let cells: DataTypes.Cell* = alloc(); 
    let width: felt = map.width * map.width;
    _get_cells(map_id, 0, width , cells);
    return (width, cells,);
}

func _get_cells{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    map_id: felt, index: felt, cell_len: felt, cells: DataTypes.Cell*
) -> () {
    if (cell_len == 0) {
        return ();
    }
    let (cell: DataTypes.Cell) = map_list.read(map_id, index);
    assert cells[index] = cell;
    _get_cells(map_id, index + 1, cell_len - 1, cells);
    return ();
}

@view
func get_neighbors{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    map_id: felt, x: felt, y: felt
) -> (points_len: felt, points: DataTypes.Point*) {
    alloc_locals;
    let relevant_neighbours: DataTypes.Point* = alloc(); 
    local relevant_neighbours_len: felt = 0;

    let (map: DataTypes.Map) = maps.read(map_id);
    let (cell: DataTypes.Cell) = map_list.read(map_id, convert_coords_to_id(x, y, map.width));

    // ↑
    let (relevant_neighbours_len) = _add_neighbors(cell.top, x, y + 1, relevant_neighbours_len, relevant_neighbours);
    // →
    let (relevant_neighbours_len) = _add_neighbors(cell.right, x + 1, y, relevant_neighbours_len, relevant_neighbours);
    // ↓
    let (relevant_neighbours_len) = _add_neighbors(cell.bottom, x, y - 1, relevant_neighbours_len, relevant_neighbours);
    // ←
    let (relevant_neighbours_len) = _add_neighbors(cell.left, x - 1, y, relevant_neighbours_len, relevant_neighbours);
    
    return (relevant_neighbours_len, relevant_neighbours,);
}

// Internals
func _create_map{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    map_id: felt, index: felt, cells_len: felt, cells: DataTypes.Cell*
) {
    if (cells_len == 0) {
        return ();
    }

    _create_map(map_id, index + 1, cells_len - 1, cells + DataTypes.Cell.SIZE);
    map_list.write(map_id, index, cells[0]);
    return(); 
}

func _add_neighbors{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    walkable_condition: felt, x: felt, y: felt, neighbours_len: felt, neighbours: DataTypes.Point*
) -> (neighbours_len: felt) {

    if(walkable_condition == TRUE) {
        assert neighbours[neighbours_len] = DataTypes.Point(x, y );
        return (neighbours_len + 1,);
    } else {
        return (neighbours_len,);
    }
}

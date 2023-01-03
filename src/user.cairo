%lang starknet
from starkware.cairo.common.cairo_builtins import HashBuiltin

from src.interfaces.i_micro_mouse import IMicroMouse
from src.types.data_types import DataTypes

@storage_var
func micro_mouse_contract() -> (contract: felt) {
}

@view
func run{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(map_id: felt, x: felt, y: felt) -> (result_points_len: felt, result_points: DataTypes.Point*) {
    let (contract: felt) = micro_mouse_contract.read();
    let (result_points_len: felt, result_points: DataTypes.Point*) = IMicroMouse.get_neighbors(contract, map_id, x, y);
    return (result_points_len, result_points,);
}

@view
func get_micro_mouse_contract{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    res: felt
) {
    let (contract: felt) = micro_mouse_contract.read();
    return (contract,);
}

@external
func set_micro_mouse_contract{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    contract: felt
) {
    micro_mouse_contract.write(contract);
    return ();
}




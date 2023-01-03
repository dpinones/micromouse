%lang starknet

from src.types.data_types import DataTypes

@contract_interface
namespace IMicroMouse {
    func get_neighbors(map_id: felt, x: felt, y: felt) -> (points_len: felt, points: DataTypes.Point*) {
    }
}
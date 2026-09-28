// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IWarehouse
 * @notice Interface cua nha kho trung tam cung cap hang cho sieu thi.
 */
interface IWarehouse {
    enum WarehouseStatus {
        InStock,
        OutOfStock,
        Returned
    }

    struct WarehouseItem {
        uint256 productId;
        uint256 quantity;
        uint256 returnedQuantity;
        WarehouseStatus status;
        bool exists;
    }

    event StockReceived(uint256 productId, uint256 amount, uint256 newQuantity);
    event TakenForShelf(uint256 productId, uint256 amount, uint256 remaining);
    event ReturnedToWarehouse(uint256 productId, uint256 amount, uint256 newQuantity);

    function receiveStock(uint256 productId, uint256 amount) external;

    function takeForShelf(uint256 productId, uint256 amount) external;

    function returnFromShelf(uint256 productId, uint256 amount) external;

    function getWarehouseItem(uint256 productId) external view returns (WarehouseItem memory);

    function getStock(uint256 productId) external view returns (uint256);
}

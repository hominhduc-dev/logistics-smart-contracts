// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Warehouse
 * @notice Nha kho trung tam cung cap hang cho sieu thi.
 *
 * Logic chinh:
 * - Nha kho nhan hang tu nha cung cap bang receiveStock().
 * - Sieu thi lay hang tu nha kho dua len ke bang takeForShelf().
 * - Khi ngung kinh doanh san pham, hang con tren ke
 *   duoc tra ve kho bang returnFromShelf().
 *
 * Hang duoc tra ve se co trang thai Returned.
 */
contract Warehouse {
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

    mapping(uint256 => WarehouseItem) private items;

    event StockReceived(uint256 indexed productId, uint256 amount, uint256 newQuantity);
    event TakenForShelf(uint256 indexed productId, uint256 amount, uint256 remaining);
    event ReturnedToWarehouse(uint256 indexed productId, uint256 amount, uint256 newQuantity);

    function receiveStock(uint256 productId, uint256 amount) public {
        require(amount > 0, "Amount must be greater than 0");

        if (!items[productId].exists) {
            items[productId] = WarehouseItem({
                productId: productId,
                quantity: amount,
                returnedQuantity: 0,
                status: WarehouseStatus.InStock,
                exists: true
            });
        } else {
            items[productId].quantity += amount;
            items[productId].status = WarehouseStatus.InStock;
        }

        emit StockReceived(productId, amount, items[productId].quantity);
    }

    function takeForShelf(uint256 productId, uint256 amount) external {
        require(items[productId].exists, "Warehouse item not found");
        require(amount > 0, "Amount must be greater than 0");
        require(items[productId].quantity >= amount, "Not enough stock in warehouse");

        items[productId].quantity -= amount;

        if (items[productId].quantity == 0) {
            items[productId].status = WarehouseStatus.OutOfStock;
        } else {
            items[productId].status = WarehouseStatus.InStock;
        }

        emit TakenForShelf(productId, amount, items[productId].quantity);
    }

    function returnFromShelf(uint256 productId, uint256 amount) external {
        require(amount > 0, "Return amount must be greater than 0");

        if (!items[productId].exists) {
            items[productId] = WarehouseItem({
                productId: productId,
                quantity: amount,
                returnedQuantity: amount,
                status: WarehouseStatus.Returned,
                exists: true
            });
        } else {
            items[productId].quantity += amount;
            items[productId].returnedQuantity += amount;
            items[productId].status = WarehouseStatus.Returned;
        }

        emit ReturnedToWarehouse(productId, amount, items[productId].quantity);
    }

    function getWarehouseItem(uint256 productId) public view returns (WarehouseItem memory) {
        require(items[productId].exists, "Warehouse item not found");
        return items[productId];
    }

    function getStock(uint256 productId) public view returns (uint256) {
        if (!items[productId].exists) {
            return 0;
        }
        return items[productId].quantity;
    }
}

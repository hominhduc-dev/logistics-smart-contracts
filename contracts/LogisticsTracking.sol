// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./interfaces/ILogisticsTracking.sol";

/**
 * @title LogisticsTracking
 * @notice Hop dong theo doi chuoi cung ung (logistics) tren blockchain.
 * Moi lo hang (Shipment) duoc tao ra, gan don vi van chuyen, va cap nhat
 * trang thai qua tung chang cho den khi giao hang thanh cong.
 */
contract LogisticsTracking is ILogisticsTracking {
    address public owner;
    uint256 private nextShipmentId = 1;

    mapping(uint256 => Shipment) public shipments;
    mapping(uint256 => StatusUpdate[]) public shipmentHistory;

    mapping(address => bool) public isAuthorizedCarrier;

    modifier onlyOwner() {
        require(msg.sender == owner, "Chi owner moi duoc goi");
        _;
    }

    modifier shipmentExists(uint256 _id) {
        require(shipments[_id].id != 0, "Shipment khong ton tai");
        _;
    }

    modifier onlyParticipant(uint256 _id) {
        Shipment memory s = shipments[_id];
        require(
            msg.sender == s.sender ||
            msg.sender == s.carrier ||
            msg.sender == s.receiver,
            "Ban khong lien quan den don hang nay"
        );
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function setCarrierAuthorization(address _carrier, bool _authorized) external override onlyOwner {
        isAuthorizedCarrier[_carrier] = _authorized;
        emit CarrierAuthorized(_carrier, _authorized);
    }

    function createShipment(
        address _carrier,
        address _receiver,
        string calldata _description,
        string calldata _origin,
        string calldata _destination
    ) external override returns (uint256) {
        require(_carrier != address(0) && _receiver != address(0), "Dia chi khong hop le");

        uint256 id = nextShipmentId++;

        shipments[id] = Shipment({
            id: id,
            sender: msg.sender,
            carrier: _carrier,
            receiver: _receiver,
            description: _description,
            originLocation: _origin,
            destination: _destination,
            createdAt: block.timestamp,
            deliveredAt: 0,
            status: Status.Created
        });

        shipmentHistory[id].push(StatusUpdate({
            status: Status.Created,
            location: _origin,
            note: "Don hang duoc tao",
            timestamp: block.timestamp,
            updatedBy: msg.sender
        }));

        emit ShipmentCreated(id, msg.sender, _carrier, _receiver);
        return id;
    }

    function updateStatus(
        uint256 _id,
        Status _newStatus,
        string calldata _location,
        string calldata _note
    ) external override shipmentExists(_id) onlyParticipant(_id) {
        Shipment storage s = shipments[_id];

        require(s.status != Status.Delivered, "Don hang da giao, khong the cap nhat");
        require(s.status != Status.Cancelled, "Don hang da bi huy");
        require(_newStatus != Status.Created, "Khong the quay lai trang thai Created");

        s.status = _newStatus;

        if (_newStatus == Status.Delivered) {
            s.deliveredAt = block.timestamp;
            emit ShipmentDelivered(_id, block.timestamp);
        }

        shipmentHistory[_id].push(StatusUpdate({
            status: _newStatus,
            location: _location,
            note: _note,
            timestamp: block.timestamp,
            updatedBy: msg.sender
        }));

        emit StatusUpdated(_id, _newStatus, _location, msg.sender);
    }

    function cancelShipment(uint256 _id, string calldata _reason)
        external
        override
        shipmentExists(_id)
    {
        Shipment storage s = shipments[_id];
        require(msg.sender == s.sender, "Chi nguoi gui moi duoc huy");
        require(s.status == Status.Created || s.status == Status.PickedUp, "Khong the huy o giai doan nay");

        s.status = Status.Cancelled;

        shipmentHistory[_id].push(StatusUpdate({
            status: Status.Cancelled,
            location: "",
            note: _reason,
            timestamp: block.timestamp,
            updatedBy: msg.sender
        }));

        emit ShipmentCancelled(_id, _reason);
    }

    function getShipment(uint256 _id)
        external
        view
        override
        shipmentExists(_id)
        returns (Shipment memory)
    {
        return shipments[_id];
    }

    function getHistory(uint256 _id)
        external
        view
        override
        shipmentExists(_id)
        returns (StatusUpdate[] memory)
    {
        return shipmentHistory[_id];
    }

    function getHistoryCount(uint256 _id) external view override returns (uint256) {
        return shipmentHistory[_id].length;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title ILogisticsTracking
 * @notice Interface cua hop dong theo doi chuoi cung ung (logistics).
 */
interface ILogisticsTracking {
    enum Status {
        Created,
        PickedUp,
        InTransit,
        Delivered,
        Cancelled
    }

    struct Shipment {
        uint256 id;
        address sender;
        address carrier;
        address receiver;
        string description;
        string originLocation;
        string destination;
        uint256 createdAt;
        uint256 deliveredAt;
        Status status;
    }

    struct StatusUpdate {
        Status status;
        string location;
        string note;
        uint256 timestamp;
        address updatedBy;
    }

    event ShipmentCreated(
        uint256 indexed shipmentId,
        address indexed sender,
        address indexed carrier,
        address receiver
    );

    event StatusUpdated(
        uint256 indexed shipmentId,
        Status status,
        string location,
        address updatedBy
    );

    event ShipmentDelivered(uint256 indexed shipmentId, uint256 timestamp);
    event ShipmentCancelled(uint256 indexed shipmentId, string reason);
    event CarrierAuthorized(address indexed carrier, bool authorized);

    function setCarrierAuthorization(address _carrier, bool _authorized) external;

    function createShipment(
        address _carrier,
        address _receiver,
        string calldata _description,
        string calldata _origin,
        string calldata _destination
    ) external returns (uint256);

    function updateStatus(
        uint256 _id,
        Status _newStatus,
        string calldata _location,
        string calldata _note
    ) external;

    function cancelShipment(uint256 _id, string calldata _reason) external;

    function getShipment(uint256 _id) external view returns (Shipment memory);

    function getHistory(uint256 _id) external view returns (StatusUpdate[] memory);

    function getHistoryCount(uint256 _id) external view returns (uint256);
}

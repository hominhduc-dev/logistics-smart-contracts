# Logistics Smart Contracts

Bo smart contract Solidity minh hoa theo doi lo hang (logistics) va quan ly kho (warehouse) tren blockchain.

## Cau truc

contracts/LogisticsTracking.sol: Theo doi vong doi lo hang Created den PickedUp den InTransit den Delivered, hoac Cancelled.
contracts/Warehouse.sol: Quan ly ton kho, nhap hang, lay hang len ke, tra hang ve kho.
diagrams/logistics-flow.workflow.json: Dac ta so do workflow Archify.
diagrams/logistics-flow.html: So do workflow tuong tac, mo truc tiep bang trinh duyet.

## LogisticsTracking.sol

Theo doi lo hang qua cac trang thai Created den PickedUp den InTransit den Delivered, hoac Cancelled. Chi Sender huy duoc, va chi khi con Created hoac PickedUp.

Moi lan doi trang thai deu duoc ghi vao lich su StatusUpdate va phat ra event tuong ung de dApp lang nghe real time.

Ham chinh gom createShipment, updateStatus, cancelShipment, getShipment, getHistory.

## Warehouse.sol

Quan ly ton kho trung tam cung cap hang cho sieu thi. Ham chinh gom receiveStock, takeForShelf, returnFromShelf, getWarehouseItem, getStock.

## Chay thu

Dan code vao Remix IDE hoac dung Hardhat, Foundry. Compile voi Solidity 0.8.24 cho LogisticsTracking, va 0.8.0 cho Warehouse. Deploy len mang test Sepolia hoac chay local node.

## So do

Mo diagrams/logistics-flow.html bang trinh duyet de xem so do workflow tuong tac.

## License

MIT

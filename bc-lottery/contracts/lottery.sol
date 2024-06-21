// SPDX-License-Identifier: MIT
pragma solidity ^0.4.26;

contract Lottery {
    address public manager;
    // 0.8.14 change below to: address payable[] public players;
    address[] public players;
    address[] public winners;

    struct PlayerHistory {
        uint256 id;
        address addressId;
        uint256 weiSent;
        uint256 seriesId;
        uint256 timestamp;
    }
    PlayerHistory[] public playersHistory;

    struct WinnerHistory {
        uint256 id;
        address addressId;
        uint256 weiReceived;
        uint256 timestamp;
    }
    WinnerHistory[] public winnersHistory;

    event Enter();
    event PickWinner();

    // 0.8.14 change below to:
    /* constructor() {
        manager = msg.sender;
    } */
    constructor() public {
        manager = msg.sender;
    }

    // In Remix use Gwei 11.000.000 for sending 0.011 ether
    function enter() public payable {
        require(msg.value > .01 ether);
        // 0.8.14 change below to: players.push(payable(msg.sender));
        players.push(msg.sender);

        uint256 playerId = playersHistory.length + 1;

        PlayerHistory memory newDetail = PlayerHistory({
            id: playerId,
            addressId: msg.sender,
            weiSent: msg.value,
            seriesId: winnersHistory.length + 1,
            timestamp: block.timestamp
        });
        playersHistory.push(newDetail);
        emit Enter();
    }

    function random() private view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(block.difficulty, block.timestamp, players)
                )
            );
    }

    function pickWinner() public restricted {
        uint256 index = random() % players.length;
        uint256 thisBalance = address(this).balance;
        players[index].transfer(address(this).balance);

        winners.push(players[index]);

        uint256 winnerId = winnersHistory.length + 1;

        WinnerHistory memory newDetail = WinnerHistory({
            id: winnerId,
            addressId: players[index],
            weiReceived: thisBalance,
            timestamp: block.timestamp
        });
        winnersHistory.push(newDetail);

        // 0.8.14 change below to: players = new address payable[](0);
        players = new address[](0);
        emit PickWinner();
    }

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    // 0.8.14 change below to:
    /* function getPlayers() public view returns (address payable[] memory) {
        return players;
    } */
    function getPlayersArray() public view returns (address[]) {
        return players;
    }

    function getWinnersArray() public view returns (address[]) {
        return winners;
    }

    function getPlayersHistory() external view returns (uint256) {
        return playersHistory.length;
    }

    function getWinnersHistory() external view returns (uint256) {
        return winnersHistory.length;
    }

    function getPlayerDetails(
        uint256 _id
    ) external view returns (uint256, address, uint256, uint256, uint256) {
        return (
            playersHistory[_id].id,
            playersHistory[_id].addressId,
            playersHistory[_id].weiSent,
            playersHistory[_id].seriesId,
            playersHistory[_id].timestamp
        );
    }

    function getWinnerDetails(
        uint256 _id
    ) external view returns (uint256, address, uint256, uint256) {
        return (
            winnersHistory[_id].id,
            winnersHistory[_id].addressId,
            winnersHistory[_id].weiReceived,
            winnersHistory[_id].timestamp
        );
    }
}

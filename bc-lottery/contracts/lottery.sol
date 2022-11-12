// SPDX-License-Identifier: MIT
pragma solidity ^0.4.26;

// pragma solidity ^0.8.14;

contract Lottery {
    address public manager;
    // 0.8.14 change below to: address payable[] public players;
    address[] public players;

    // 0.8.14 change below to:
    /* constructor() {
        manager = msg.sender;
    } */
    constructor() public {
        manager = msg.sender;
    }

    // In Remix use Gwei 11000000 for sending 0.011 ether
    function enter() public payable {
        require(msg.value > .01 ether);
        // 0.8.14 change below to: players.push(payable(msg.sender));
        players.push(msg.sender);
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
        players[index].transfer(address(this).balance);
        // 0.8.14 change below to: players = new address payable[](0);
        players = new address[](0);
    }

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    // 0.8.14 change below to:
    /* function getPlayers() public view returns (address payable[] memory) {
        return players;
    } */
    function getPlayers() public view returns (address[] memory) {
        return players;
    }
}

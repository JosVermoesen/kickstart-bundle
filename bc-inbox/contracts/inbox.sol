// SPDX-License-Identifier: MIT
pragma solidity ^0.4.26;

// pragma solidity ^0.8.14;

contract Inbox {
    string public message;

    constructor(string initialMessage) public {
        message = initialMessage;
    }

    // 0.8.14 change above to:
    /* constructor(string memory initialMessage) {
        message = initialMessage;
    } */

    function setMessage(string newMessage) public {
        message = newMessage;
    }
    // 0.8.14 change above to:
    /* function setMessage(string memory newMessage) public {
        message = newMessage;
    } */
}

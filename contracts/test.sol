// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Payable {

    address payable public owner;

    constructor() payable {
        owner = payable(msg.sender);
    }

    function transfer(address payable _to, uint _amount) public {

    }
}
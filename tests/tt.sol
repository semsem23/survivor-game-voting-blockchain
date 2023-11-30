// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract VendingMachine {

    address public owner;
    mapping (string => uint) public itemStocks;
    mapping (address => mapping(string => uint)) public customerPurchases;

    string[] public items = ["pepsi", "coca-cola", "fanta", "ice tea"];

    constructor() {
        owner = msg.sender;
        for(uint i = 0; i < items.length; i++) {
            itemStocks[items[i]] = 100;
        }
    }

    function getItemStock(string memory item) public view returns (uint) {
        return itemStocks[item];
    }

    function restock(string memory item, uint amount) public {
        require(msg.sender == owner, "Only the owner can restock.");
        itemStocks[item] += amount;
    }

    function purchase(string memory item, uint amount) public payable {
        require(msg.value >= amount * 1 ether, "You must pay at least 1 ETH");
        require(itemStocks[item] >= amount, "Not enough in stock to complete this purchase");
        itemStocks[item] -= amount;
        customerPurchases[msg.sender][item] += amount;
    }
}
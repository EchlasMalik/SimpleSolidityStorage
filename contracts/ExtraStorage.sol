// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

//Inherit all functionality of SimpleStorage
import "./SimpleStorage.sol";

contract ExtraStorage is SimpleStorage {
    // Override Function
    function store(uint256 _favouriteNumber) public override {
        favouriteNumber = _favouriteNumber + 5;
    }
}
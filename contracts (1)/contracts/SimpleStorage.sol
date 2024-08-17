// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

//Compiles to EVM - The Ethereum Virtual Machine

contract SimpleStorage {
    // boolean, unint, int, address, bytes

    //This gets initialised to 0
    uint256 favouriteNumber;

    mapping(string => uint256) public nameToFavouriteNumber;

    struct People {
        uint256 favouriteNumber;
        string name;
    }

    // uint256[] public favouriteNumbersList;
    People[] public people;
    
    
    function store(uint256 _favouriteNumber) public virtual  {
        favouriteNumber = _favouriteNumber;
        retrieve();
    }

    // view, pure
    function retrieve() public view returns(uint256){
        return favouriteNumber;
    }

    // Adds to the mapping AND the Array
    function addPerson(string memory _name, uint256 _favouriteNumber) public {
        people.push(People(_favouriteNumber, _name));
        nameToFavouriteNumber[_name] = _favouriteNumber;
    }
}
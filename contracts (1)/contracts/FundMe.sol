// Get Funds from Users
// Withdraw Funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./PriceConverter.sol";

// Constant and Immutable save GAS!

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;
    uint256 public constant MINIMUM_USD = 50 * 1e18;  // Constant Variable and does not get changed and saves gas fees.

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    address public immutable i_owner;

    constructor(){
        i_owner = msg.sender;
    }

    function fund() public payable{
        // Want to be able to set a minimum fund amount in USD
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't send enough!"); // 1e18 == 1 * 10 ** 18 == 
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        
        //For loop to reset funder's amount to 0
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // Reset the Array
        funders = new address[](0);
        // Withdrawal of the funds
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");

        // 3 WAYS OF SENDING ETHEREUM:

        // // transfer by wrapping the address {Max 2300 gas, throws error}
        // payable(msg.sender).transfer(address(this).balance);

        // // send {Max 2300 gas, returns bool}
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");

        // // call {forward all gas or set gas, returns bool}
        // (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        // require(callSuccess, "Call failed");
    }

    modifier onlyOwner {    //Modifier that gets executed before running the function!
        // require(msg.sender == i_owner, "Sender is not owner!");
        if(msg.sender != i_owner) { revert NotOwner(); }    // => More gas efficient
        _;
    }

    // What happens if someone sends this contract ETH without calling the fund function?

    receive() external payable {    // Can be used at most ONCE in a whole contract. gets triggered when something gets sent to the contract
        fund();
    }

    fallback() external payable {   // Gets called when the contract does not know where to redirect the user after input of data.
        fund();
    }
}
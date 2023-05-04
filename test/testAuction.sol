// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "truffle/Assert.sol";
import "../contracts/Auction.sol";

contract TestAuction {
    Auction auction;
    string itemName = "Test Item";
    uint256 startingPrice = 10;
    uint256 bidAmount = 20;
    address bidder = 0x5dD556Ba34E7aFc6eb9882b43Ba2c27F8B1B28bd;

    function beforeEach() public {
        auction = new Auction(startingPrice, itemName);
        
    }

    function testAddItem() public {
        auction.addItem("Another Item", 20);
        (address owner, uint256 price, , , ) = auction.getItem("Another Item");

        Assert.equal(owner, address(this), "Owner should be the current contract");
        Assert.equal(price, 20, "Starting price should be 20");
    }

    
}

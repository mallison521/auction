// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Auction {
    // Structure to hold information about an item being auctioned
    struct Item {
        address owner;  // Address of the item owner
        uint256 startingPrice;  // Starting price of the item
        uint256 highestBid;  // Highest bid placed on the item
        address highestBidder;  // Address of the highest bidder
        bool ended;  // Flag indicating if the auction has ended
    }

    // Mapping of item names to their corresponding Item struct
    mapping(string => Item) private items;
    mapping(address => uint) public bids;

    constructor(uint256 startingPrice,  string memory itemName){
        Item storage newItem = items[itemName];
        newItem.owner = msg.sender;
        newItem.startingPrice = startingPrice;
        newItem.highestBid = startingPrice;
    }

    // Event emitted when a new item is added to the auction
    event ItemAdded(string itemName, address owner, uint256 startingPrice);

    // Event emitted when a bid is placed on an item
    event BidPlaced(string itemName, address bidder, uint256 bidAmount);

    // Event emitted when an item's auction has ended
    event AuctionEnded(string itemName, address winner, uint256 highestBid);

    // Function to add a new item to the auction
    function addItem(string memory itemName, uint256 startingPrice) public payable {
        require(items[itemName].owner == address(0), "Item already exists");

        Item storage newItem = items[itemName];
        newItem.owner = msg.sender;
        newItem.startingPrice = startingPrice;

        emit ItemAdded(itemName, msg.sender, startingPrice);
    }

    // Function to place a bid on an item
    function placeBid(string memory itemName) public payable {
        require(!items[itemName].ended, "Auction has ended");
        require(msg.sender != items[itemName].owner, "Owner cannot bid on their own item");
        require(msg.value > items[itemName].highestBid, "Bid amount must be higher than current highest bid");

        // Refund previous highest bidder if there was one
        if (items[itemName].highestBidder != address(0)) {
            payable(items[itemName].highestBidder).transfer(items[itemName].highestBid);
        }

        // Update item information
        items[itemName].highestBid = msg.value;
        items[itemName].highestBidder = msg.sender;

        emit BidPlaced(itemName, msg.sender, msg.value);
    }

    // Function to end an item's auction and transfer ownership to the highest bidder
    function endAuction(string memory itemName) public {
        require(!items[itemName].ended, "Auction has already ended");

        items[itemName].ended = true;

        // Transfer ownership of the item to the highest bidder
        payable(items[itemName].owner).transfer(items[itemName].highestBid);

        emit AuctionEnded(itemName, items[itemName].highestBidder, items[itemName].highestBid);
    }

    // Function to retrieve information about an item
    function getItem(string memory itemName) public view returns (address owner, uint256 startingPrice, uint256 highestBid, address highestBidder, bool ended) {
        Item storage item = items[itemName];

        owner = item.owner;
        startingPrice = item.startingPrice;
        highestBid = item.highestBid;
        highestBidder = item.highestBidder;
        ended = item.ended;
    }
}
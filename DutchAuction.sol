//SPDX-License-Identifier: MIT 
pragma solidity ^0.8.31; 
 
interface IERC721 { 
    function transferFrom (address _from,address _to,uint256 _nftId)external; 
} 
 
contract DutchAuction { 

    error dutchAuction_TransferFailed();
    error dutchAuction_HitMinStartingPrice();
    error dutchAuction_AuctionEnded();
    error dutchAuction_NotEnoughPrice();

    uint256 private constant DURATION = 100; 
 
    IERC721 public immutable nft; 
    uint256 public immutable nftId; 
 
    address payable  public immutable seller; 
    uint256 public immutable startingPrice; 
    uint256 public immutable startAt; 
    uint256 public immutable endAt; 
    uint256 public immutable discountRate; 
 
    constructor ( 
        address _nft, 
        uint256 _nftId, 
        uint256 _startingPrice, 
        uint256 _discountRate) { 
 
        seller = payable(msg.sender);  
        startingPrice = _startingPrice; 
        discountRate = _discountRate; 
        startAt = block.timestamp; 
        endAt = block.timestamp + DURATION; 
 
        require(startingPrice >= discountRate * DURATION, dutchAuction_HitMinStartingPrice()); 
 
        nft = IERC721(_nft); 
        nftId = _nftId; 
    } 
    function getPrice() public view returns (uint256){ 
        uint256 timeElapsed = block.timestamp - startAt; 
        uint256 discount = timeElapsed * discountRate; 
        return startingPrice - discount; 
    } 
    function buy () external payable { 
        require(block.timestamp < endAt, dutchAuction_AuctionEnded()); 
 
        uint256 price = getPrice(); 
        require(msg.value >= price, dutchAuction_NotEnoughPrice()); 
 
        nft.transferFrom(seller, msg.sender, nftId); 
        uint256 refund = msg.value - price; 
 
        if (refund > 0){ 
            (bool success, ) = msg.sender.call{value: refund}(""); 
            require(success, dutchAuction_TransferFailed()); 
        } 
        (bool success, ) = seller.call{value: address(this).balance}(""); 
        require(success, dutchAuction_TransferFailed()); 
    } 
} 

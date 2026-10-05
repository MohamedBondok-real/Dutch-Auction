# Dutch Auction

A Solidity implementation of a **Dutch Auction for ERC-721 NFTs**.

A Dutch Auction starts with a high price that decreases over time. The first buyer willing to pay the current price can purchase the NFT.

## Features

* ERC-721 NFT auction
* Automatically decreasing price
* Fixed auction duration
* Custom Solidity errors
* Automatic ETH refund for overpayment
* Automatic payment to the seller
* Uses `immutable` variables
* Built with Solidity `^0.8.31`

## How It Works

The auction price decreases according to the elapsed time:

```text
currentPrice = startingPrice - (timeElapsed × discountRate)
```

The auction duration is currently set to:

```solidity
DURATION = 100;
```

The seller specifies the NFT, starting price, and discount rate when deploying the contract.

The current price can be checked using:

```solidity
auction.getPrice();
```

A buyer can purchase the NFT by calling:

```solidity
auction.buy{value: price}();
```

If the buyer sends more ETH than the current price, the contract automatically refunds the difference.

## Constructor

The contract requires:

```solidity
constructor(
    address _nft,
    uint256 _nftId,
    uint256 _startingPrice,
    uint256 _discountRate
)
```

| Parameter        | Description               |
| ---------------- | ------------------------- |
| `_nft`           | ERC-721 contract address  |
| `_nftId`         | NFT token ID              |
| `_startingPrice` | Initial auction price     |
| `_discountRate`  | Price decrease per second |

The deployer automatically becomes the seller.

## NFT Approval

Before a buyer can purchase the NFT, the seller must approve the Dutch Auction contract to transfer the NFT.

For example:

```solidity
nft.approve(auctionAddress, nftId);
```

The auction then transfers the NFT using:

```solidity
nft.transferFrom(seller, msg.sender, nftId);
```

## Security Checks

The contract includes checks for:

* Auction expiration
* Sufficient payment
* Valid starting price
* Successful NFT transfer
* Successful ETH transfers

Custom errors are used to make revert conditions clear and gas-efficient.

## Tech Stack

* **Solidity:** `^0.8.31`
* **NFT Standard:** ERC-721
* **Framework:** Foundry / Forge
* **Network:** EVM-compatible blockchains
* **License:** MIT

## Learning Objectives

This project demonstrates:

* Solidity interfaces
* ERC-721 interactions
* Payable functions
* `msg.value` and `msg.sender`
* `block.timestamp`
* Immutable state variables
* Custom errors
* ETH transfers using `call`
* Dynamic price calculations
* NFT approvals and transfers

## License

This project is licensed under the **MIT License**.

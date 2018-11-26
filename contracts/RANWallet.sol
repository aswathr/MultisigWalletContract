pragma solidity >=0.4.20 <0.5.6;

import "contracts/Transaction.sol";
import "contracts/WalletInterface.sol";
import "contracts/MultiSigWalletInterface.sol";

contract RANMultiSigWallet is MultiSigWallet {

  // address private _primaryOwner;
  // mapping (address => Privilege) private _secondaryOwners;
  //
  // event DepositFunds(address sender, uint256 amount);
  // event WithdrawFunds(address receiver, uint256 amount);
  // event TransferFunds(address sender, address receiver, uint256 amount);

  uint8 private _minimumSignaturesRequired;
  mapping (uint256 => TransactionLibrary.Transaction) private _transactions;
  uint8[] private _pendingTransactions;

  constructor (uint8 minimumSignaturesRequired) public {

    _minimumSignaturesRequired = minimumSignaturesRequired;
  }

  modifier primaryOwner(address anAddress) {

    require(_primaryOwner == anAddress);
    _;
  }

  modifier validOwner(address anAddress) {

    require(_secondaryOwners[anAddress] == Privilege.Owner);
    _;
  }

  function transferTo(address payable to, uint256 amount) public payable {

    to.transfer(amount);
  }

  function withdraw(uint256 amount) primaryOwner(msg.sender) public payable {

    transferTo(msg.sender, amount);
  }

  function setOwner(address anAddress, Privilege state) validOwner(msg.sender) public {

    _secondaryOwners[anAddress] = state;
  }
}

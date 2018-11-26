pragma solidity >=0.4.20 <0.5.6;

import "contracts/WalletInterface.sol";

contract MultiSigWallet is Wallet {

  mapping (address => Privilege) internal _secondaryOwners;

  function withdraw(uint256 amount) public payable;
  function transferTo(address payable to, uint256 amount) public payable;
  function setOwner(address anAddress, Privilege state) public;
}

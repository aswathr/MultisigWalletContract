pragma solidity >=0.4.0 <0.5.6;

contract Wallet {

  enum Privilege {Unknown, Owner}

  address internal _primaryOwner;

  event DepositFunds(address sender, uint256 amount);
  event WithdrawFunds(address receiver, uint256 amount);
  event TransferFunds(address sender, address receiver, uint256 amount);
}

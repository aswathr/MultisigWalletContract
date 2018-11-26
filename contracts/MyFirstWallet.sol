pragma solidity >=0.4.20 <0.5.0;

import "contracts/WalletInterface.sol";

contract MyFirstWallet is Wallet {

  modifier validOwner(address anAddress) {

    require(anAddress == _primaryOwner);
    _;
  }

  modifier sufficientFunds(address _address, uint256 amount) {

    require(_address.balance >= amount);
    _;
  }

  function () external payable {

    emit DepositFunds(msg.sender, msg.value);
  }

  function withdraw(uint256 amount) validOwner(msg.sender) sufficientFunds(address(this), amount) public payable {

    msg.sender.transfer(amount);
    emit WithdrawFunds(msg.sender, amount);
  }

  function transferTo(address payable to, uint256 amount) validOwner(msg.sender) sufficientFunds(address(this), amount) public payable {

    to.transfer(amount);
    emit TransferFunds(msg.sender, to, amount);
  }
}

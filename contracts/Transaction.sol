pragma solidity >=0.4.20 <0.5.6;

library TransactionLibrary {

  enum SignatureStatus { Unsigned, Signed, AuthorSigned}

  struct Transaction {

    address _from;
    address _to;
    uint256 _amount;
    address _transactionAuthor;
    mapping (address => SignatureStatus) _signatures;
  }

  function sign(Transaction storage _transaction, address by) internal {

    _transaction._signatures[by] = SignatureStatus.Signed;
  }

  function unsign(Transaction  storage _transaction, address by) internal {

    _transaction._signatures[by] = SignatureStatus.Unsigned;
  }
}

library TransactionQueueLibrary {

  struct TransactionQueue {

    uint256 _transactionIndex;
    uint256[] _pendingTransactions;
    mapping (uint256 => TransactionLibrary.Transaction) _transactions;
  }

  event TransactionSigned(address signee, uint256 transactionId);
  event TransactionUnsigned(address signee, uint256 transactionId);
  event TransactionCompleted(address _from, address _to, uint256 amount);

  function addTransaction(TransactionQueue storage toQueue, TransactionLibrary.Transaction memory transaction) internal {

    toQueue._transactions[toQueue._transactionIndex] = transaction;
    toQueue._pendingTransactions.push(toQueue._transactionIndex++);
  }

  function addTransaction(TransactionQueue storage toQueue, address transactionAuthor, address to, uint256 amount) {

    TransactionLibrary.Transaction memory newTransaction = TransactionLibrary.Transaction({_from: msg.sender, _to: to, _amount: amount, _transactionAuthor: msg.sender});
    addTransaction(toQueue, newTransaction);
  }

  function removeTransaction(TransactionQueue storage fromQueue, uint256 transactionIndex) internal {

    delete fromQueue._transactions[transactionIndex];

    uint8 replaceFlag = 0;
    for(uint256 i = 0; i < fromQueue._pendingTransactions.length; i++) {

      if(replaceFlag == 1) {

        fromQueue._pendingTransactions[i-1] = fromQueue._pendingTransactions[i];
      }

      if(fromQueue._pendingTransactions[i] == transactionIndex) {

        replaceFlag = 1;
      }
    }
  }
}

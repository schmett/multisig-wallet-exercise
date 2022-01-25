pragma solidity ^0.5.0;

address[] public owners;
uint public required;
mapping(address => bool) public isOwner;
uint public transactionCount; 
mapping (uint => Transaction) public transactions; 

contract MultiSignatureWallet {

    struct Transaction {
      bool executed;
      address destination;
      uint value;
      bytes data;
    }

    event Deposit(address indexed sender, uint value);

    /// @dev Fallback function allows to deposit ether.
    function()
    	external
        payable
    {
        if (msg.value > 0) {
            emit Deposit(msg.sender, msg.value);
	}
    }

    /*
     * Public functions
     */
    /// @dev Contract constructor sets initial owners and required number of confirmations.
    /// @param _owners List of initial owners.
    /// @param _required Number of required confirmations.
    
    // make sure that a user does not require more confirmations than there are owners
    // the contract requires at least one confirmation before sending a transaction
    // the owner array contains at least one address
    modifier validRequirement(uint ownerCount, uint _required) {
      if (_required > ownerCount || _required == 0 || ownerCount == 0)
        revert(); 
      _;       
    }
    
    constructor(address[] memory _owners, uint _required) 
      event Submission(uint indexed transactionId);

      public 
      validRequirement(_owners.length, _required) {
        for (uint i=0; i<_owners.length; i++) {
          isOwner[_owners[i]] = true; 
        }
        owners = _owners;
        required = _required; 
      }

    /// @dev Allows an owner to submit and confirm a transaction.
    /// @param destination Transaction target address.
    /// @param value Transaction ether value.
    /// @param data Transaction data payload.
    /// @return Returns transaction ID.
    function submitTransaction(address destination, uint value, bytes memory data) 
      public 
      returns (uint transactionId) {
        require(isOwner[msg.sender]);
        transactionId = addTransaction(destination, value, data);
        confirmTransaction(transactionId);
      }

    /// @dev Allows an owner to confirm a transaction.
    /// @param transactionId Transaction ID.
    function confirmTransaction(uint transactionId) public {}

    /// @dev Allows an owner to revoke a confirmation for a transaction.
    /// @param transactionId Transaction ID.
    function revokeConfirmation(uint transactionId) public {}

    /// @dev Allows anyone to execute a confirmed transaction.
    /// @param transactionId Transaction ID.
    function executeTransaction(uint transactionId) public {}

		/*
		 * (Possible) Helper Functions
		 */
    /// @dev Returns the confirmation status of a transaction.
    /// @param transactionId Transaction ID.
    /// @return Confirmation status.
    function isConfirmed(uint transactionId) internal view returns (bool) {}

    /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
    /// @param destination Transaction target address.
    /// @param value Transaction ether value.
    /// @param data Transaction data payload.
    /// @return Returns transaction ID.
    function addTransaction(address destination, uint value, bytes memory data) 
      internal 
      returns (uint transactionId) {
        transactionId = transactionCount;
        transactions[transactionId] = Transaction({
          destination: destination,
          value: value,
          data: data, 
          executed: false
        });
        transactionCount += 1;
        emit Submission(transactionId);
      }
}

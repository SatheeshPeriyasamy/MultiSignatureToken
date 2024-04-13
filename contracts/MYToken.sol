// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiSigToken {
    address[] public owners;
    uint public requiredSignatures;
    string public token="MyToken";

    struct Transaction {
        bool executed;
        uint signatureCount;
        uint256 amount;
        bool isMint;
        mapping(address => bool) signatures;
    }

    Transaction[] public transactions;

    uint256 public initialSupply;
    mapping(address => uint256) balances;

    event TransactionProposed(uint indexed transactionId, uint256 amount, bool isMint);
    event TransactionSigned(uint indexed transactionId, address indexed signer);
    event TransactionExecuted(uint indexed transactionId);

    constructor(
        address[] memory _owners,
        uint _requiredSignatures,
        uint256 _initialSupply
    ) {
        require(_owners.length >= _requiredSignatures, "Insufficient owners for required signatures");
        require(_requiredSignatures > 0, "At least one signature is required");

        for (uint i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "Invalid owner address");

            for (uint j = 0; j < i; j++) {
                require(owner != _owners[j], "Owner addresses must be unique");
            }

            owners.push(owner);
        }

        requiredSignatures = _requiredSignatures;
        initialSupply = _initialSupply;
        balances[msg.sender] = initialSupply;
    }

    modifier onlyOwner() {
        require(isOwner(msg.sender), "Caller is not an owner");
        _;
    }

    function isOwner(address account) private view returns (bool) {
        for (uint i = 0; i < owners.length; i++) {
            if (owners[i] == account) {
                return true;
            }
        }
        return false;
    }

    function proposeTransaction(uint256 amount, bool isMint) public onlyOwner {
        uint transactionId = transactions.length;
        transactions.push();
        
        transactions[transactionId].executed = false;
        transactions[transactionId].signatureCount = 0;
        transactions[transactionId].amount = amount;
        transactions[transactionId].isMint = isMint;

        for (uint i = 0; i < owners.length; i++) {
            transactions[transactionId].signatures[owners[i]] = false;
        }

        emit TransactionProposed(transactionId, amount, isMint);
    }

    function signTransaction(uint transactionId) public onlyOwner {
        require(transactionId < transactions.length, "Transaction does not exist");
        require(!transactions[transactionId].executed, "Transaction already executed");
        require(!transactions[transactionId].signatures[msg.sender], "Transaction already signed by this owner");

        transactions[transactionId].signatures[msg.sender] = true;
        transactions[transactionId].signatureCount++;
        emit TransactionSigned(transactionId, msg.sender);
    }

    function executeTransaction(uint transactionId) public onlyOwner {
        require(transactionId < transactions.length, "Transaction does not exist");
        require(!transactions[transactionId].executed, "Transaction already executed");
        require(transactions[transactionId].signatureCount >= requiredSignatures, "Not enough signatures");

        if (transactions[transactionId].isMint) {
            initialSupply += transactions[transactionId].amount;
            balances[msg.sender] += transactions[transactionId].amount;
        } else {
            initialSupply /= 2;
            balances[msg.sender] = initialSupply;
        }

        transactions[transactionId].executed = true;
        emit TransactionExecuted(transactionId);
    }

    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }
}

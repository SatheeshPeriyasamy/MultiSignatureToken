# MultiSignatureToken Contract
The MultiSigToken contract implements a multi-signature wallet functionality for managing a cryptocurrency token within a group of owners. This system requires a predefined number of approvals from the group before any transaction can be executed, enhancing security and providing a decentralized governance model.

The contract allows for:
- Adding and managing owners.
- Proposing transactions (e.g., minting new tokens).
- Signing and executing transactions with multi-signature validation.
- Querying balances of token holders.

### Prerequisites
- Node.js and npm
- Truffle Suite

### Setup
Clone the repository and install dependencies:
```
git clone https://github.com/SatheeshPeriyasamy/MultiSignatureToken
cd MultiSignatureToken
npm install
truffle compile
```


#### Usage
### Deploying the Contract
Deploy your contract using Truffle:
```bash
truffle migrate --network development
```

## Function Descriptions

### 1. `proposeTransaction(uint256 amount, bool isMint)`
Proposes a new transaction to either mint new tokens or halve the total supply. This function can only be called by an owner of the contract.

- **Parameters:**
  - `amount` (uint256): The amount of tokens to be minted or used as a basis for calculations when halving the supply.
  - `isMint` (bool): If true, the transaction will mint the specified amount of tokens. If false, the transaction will halve the total token supply.
  
- **Usage:**
  ```solidity
  proposeTransaction(1000, true); // Propose to mint 1000 new tokens.
  proposeTransaction(0, false); // Propose to halve the total supply of tokens.

### 2. `signTransaction(uint transactionId)`
Allows an owner to sign a proposed transaction. It is necessary to gather the required number of signatures from different owners to approve and enable the execution of the transaction.
- **Parameters:**
  - `transactionId` (uint): The ID of the transaction that needs to be signed.
- **Usage:**
  ```solidity
  signTransaction(1); // Sign the transaction with ID 1.

### 3. `executeTransaction(uint transactionId)`
Executes a transaction once it has received the necessary approvals (signatures). This function will carry out the action specified in the transaction, such as minting new tokens or halving the total token supply.
- **Parameters:**
  - `transactionId` (uint): The ID of the transaction that needs to be signed.
- **Usage:**
  ```solidity
  executeTransaction(1); // Execute the transaction with ID 1.

#### Contributing
```markdown
Contributions are welcome! Please read our contributing guidelines and submit pull requests to our repository.
```

#### Contributing
```markdown
This project is licensed under the MIT License - see the LICENSE file for details.


# 🏦 CryptoBank

![Ethereum](https://img.shields.io/badge/Ethereum-Blockchain-3C3C3D?logo=ethereum&logoColor=white)
![Solidity](https://img.shields.io/badge/Solidity-%5E0.8.x-363636?logo=solidity)
![Foundry](https://img.shields.io/badge/Built%20with-Foundry-black)
![License](https://img.shields.io/badge/License-Unlicensed-lightgrey)

CryptoBank is a simple decentralized banking smart contract built on Ethereum.

It allows users to **deposit Ether into a smart contract and withdraw it later**, simulating the most basic behavior of a crypto bank.

This project is intended for **educational and learning purposes**, focusing on Solidity fundamentals and Ether handling.

---

## 🧠 Overview

CryptoBank provides a minimal implementation of a smart contract that:

- Accepts Ether deposits  
- Keeps track of user balances  
- Allows users to withdraw their own Ether  

No tokens, no interest, no lending — just Ether in and Ether out.

---

## 📦 Project Structure

```text
.
├── lib/
├── script/
├── src/
└── test/
```

---

## 🛠 Tech Stack

- **Solidity** — Smart contract language  
- **Foundry** — Ethereum development framework  
- **Forge** — Build and testing tool  
- **Ethereum** — Blockchain platform  

---

## 🚀 Getting Started

### Prerequisites

- **Foundry**

---

## 🧪 Build and Test

### Compile contracts

```bash
forge build
```

### Run tests

```bash
forge test
```

---

## 🧩 Smart Contract Behavior

The smart contract allows users to:

- Deposit Ether into the contract
- Store balances mapped to user addresses
- Withdraw their Ether at any time

Each user can only withdraw their own balance.

---

## 👤 Author

Developed by **jherrador** as a learning project for Ethereum smart contracts.
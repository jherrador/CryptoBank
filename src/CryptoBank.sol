// SPDX-License-Identifier: LGPL-3.0
pragma solidity 0.8.30;

contract CryptoBank {
    // Variables
    mapping(address => uint256) public userBalance;
    uint256 public maxBalance;
    address public admin;

    // Events
    event DepositEther(address user_, uint256 etherAmount_);
    event WithdrawEther(address user_, uint256 etherAmount_);
    event MaxBalanceUpdated(uint256 maxBalance);

    // Modifiers
    modifier onlyAdmin() {
        require(msg.sender == admin, "Not authorized");
        _;
    }

    constructor(uint256 maxBalance_) {
        maxBalance = maxBalance_;
        admin = msg.sender;
    }

    // Functions
    function setMaxBalance(uint256 maxBalance_) external onlyAdmin {
        maxBalance = maxBalance_;
        emit MaxBalanceUpdated(maxBalance_);
    }

    function depositEther() external payable {
        require(msg.value > 0, "Eth amount cannot be Zero");
        require(userBalance[msg.sender] + msg.value <= maxBalance, "MaxBalance exceed");
        userBalance[msg.sender] += msg.value;
        emit DepositEther(msg.sender, msg.value);
    }

    function withdrawEther(uint256 amount_) external {
        require(amount_ > 0, "Eth amount cannot be Zero");
        require(amount_ <= userBalance[msg.sender], "Amount exceeded the available Balance");

        userBalance[msg.sender] -= amount_;

        (bool success,) = msg.sender.call{value: amount_}("");
        require(success, "Transfer failed");

        emit WithdrawEther(msg.sender, amount_);
    }
}

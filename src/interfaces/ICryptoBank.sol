// SPDX-License-Identifier: LGPL-3.0
pragma solidity 0.8.30;

interface ICryptoBank {
    // Events
    event DepositEther(address user_, uint256 etherAmount_);
    event WithdrawEther(address user_, uint256 etherAmount_);
    event MaxBalanceUpdated(uint256 maxBalance);

    // Functions
    function setMaxBalance(uint256 maxBalance_) external;
    function depositEther() external payable;
    function withdrawEther(uint256 amount_) external;
}

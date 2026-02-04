// SPDX-License-Identifier: LGPL-3.0

pragma solidity 0.8.30;

import "forge-std/Test.sol";
import "forge-std/console2.sol";
import "../src/CryptoBank.sol";
import "../src/interfaces/ICryptoBank.sol";

contract CryptoBankTest is Test{
  CryptoBank bank;
  uint256 initialMaxBalance = 10 ether;
  function setUp() public {
    bank = new CryptoBank(initialMaxBalance);
  }

  // Deposit Tests
  function testDeposit() public payable{
    uint256 initialDeposit = 1 ether;
    ICryptoBank(address(bank)).depositEther{value: initialDeposit}();
    
    assertEq(address(bank).balance, 1 ether);
    assertEq(bank.userBalance(address(this)), initialDeposit);

    ICryptoBank(address(bank)).depositEther{value: initialDeposit}();
    assertEq(bank.userBalance(address(this)), initialDeposit*2);
  }

  function testDepositMultipleUsers() public {
    address wallet1 = address(0x1);
    address wallet3 = address(0x3);
    uint256 depositWallet1 = 2 ether;
    uint256 depositWallet3 = 5 ether;

    vm.deal(wallet1, 100 ether);
    vm.deal(wallet3, 100 ether);

    vm.prank(wallet1);
    ICryptoBank(address(bank)).depositEther{value: depositWallet1}();
    assertEq(bank.userBalance(wallet1), depositWallet1);
    
    vm.prank(wallet3);
    ICryptoBank(address(bank)).depositEther{value: depositWallet3}();
    assertEq(bank.userBalance(wallet3), depositWallet3);

    assertEq(address(bank).balance, depositWallet1 + depositWallet3);

  }

  function testRevertDepositMaxBalanceExceeded() public {
    vm.startPrank(msg.sender);
    uint256 amount = bank.maxBalance() + 1;
    vm.expectRevert("MaxBalance exceed");
    ICryptoBank(address(bank)).depositEther{value: amount }();
    vm.stopPrank();
  }

  // Withdraw Tests
  function testWithdraw() public {
    vm.startPrank(msg.sender);
    uint256 initialDeposit = 1 ether;
    ICryptoBank(address(bank)).depositEther{value: initialDeposit}();

    ICryptoBank(address(bank)).withdrawEther(initialDeposit);

    assertEq(address(bank).balance, 0);
    assertEq(bank.userBalance(msg.sender), 0);
    vm.stopPrank();
  }

  function testRevertWithdrawExceededBankBalance() public {
    vm.startPrank(msg.sender);
    uint256 initialDeposit = 1 ether;
    ICryptoBank(address(bank)).depositEther{value: initialDeposit}();

    vm.expectRevert("Amount exceeded the available Balance");
    ICryptoBank(address(bank)).withdrawEther(initialDeposit + 1 ether);
    vm.stopPrank();
  }

  function testRevertWithdrawAvailableUserBalanceExceeded() public {
    address wallet1 = address(0x1);
    address wallet3 = address(0x3);
    uint256 depositWallet1 = 2 ether;
    uint256 depositWallet3 = 5 ether;

    vm.deal(wallet1, 100 ether);
    vm.deal(wallet3, 100 ether);

    vm.prank(wallet1);
    ICryptoBank(address(bank)).depositEther{value: depositWallet1}();
    assertEq(bank.userBalance(wallet1), depositWallet1);
    
    vm.prank(wallet3);
    ICryptoBank(address(bank)).depositEther{value: depositWallet3}();
    assertEq(bank.userBalance(wallet3), depositWallet3);

    vm.prank(wallet1);
    vm.expectRevert("Amount exceeded the available Balance");
    ICryptoBank(address(bank)).withdrawEther(depositWallet3);
    assertEq(bank.userBalance(wallet1), depositWallet1);
    assertEq(bank.userBalance(wallet3), depositWallet3);

    vm.prank(wallet1);
    ICryptoBank(address(bank)).withdrawEther(depositWallet1);
    assertEq(bank.userBalance(wallet1), 0);

  }

  function testRevertNotAllowedWithdrawFromDifferentAccount() public {
    uint256 initialDeposit = 1 ether;
    address depositWallet = address(0x1);
    address walletNonDeposits = address(0x3);

    vm.deal(depositWallet, 100 ether);
    vm.deal(walletNonDeposits, 100 ether);

    console2.log("Balance=>", depositWallet.balance);
    vm.prank(depositWallet);
    ICryptoBank(address(bank)).depositEther{value: initialDeposit}();
    assertEq(bank.userBalance(depositWallet), initialDeposit);
    assertEq(bank.userBalance(walletNonDeposits), 0);

    vm.prank(walletNonDeposits);
    vm.expectRevert("Amount exceeded the available Balance");
    ICryptoBank(address(bank)).withdrawEther(initialDeposit);

    assertEq(address(bank).balance, initialDeposit);
    assertEq(bank.userBalance(depositWallet), initialDeposit);
    assertEq(bank.userBalance(walletNonDeposits), 0);

  }

  // MaxBalance Tests
  function testSetMaxBalance() public {
    uint256 newMaxBalance = 5 ether;

    assertNotEq(initialMaxBalance, newMaxBalance);
    assertEq(bank.maxBalance(), initialMaxBalance);
    ICryptoBank(address(bank)).setMaxBalance(newMaxBalance);
    assertEq(bank.maxBalance(), newMaxBalance);
  }

  function testOnlyAdminCanSetMaxBalance() public {
    uint256 newMaxBalance = 1 ether;
    address walletNotAdmin = address(0x3);
    
    vm.startPrank(walletNotAdmin);
    vm.expectRevert("Not authorized");
    ICryptoBank(address(bank)).setMaxBalance(newMaxBalance);
    vm.stopPrank();
  }

}
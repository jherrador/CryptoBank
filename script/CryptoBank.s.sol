// SPDX-License-Identifier: LGPL-3.0

pragma solidity 0.8.30;


import "forge-std/Script.sol";
import "../src/CryptoBank.sol";

contract CryptoBankScript is Script {
  function run() external {
        vm.startBroadcast();
        CryptoBank bank = new CryptoBank(10);

        console2.log("Result deployed at:", address(bank));
        vm.stopBroadcast();
    }

}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";
import { MaxBTCERC20 } from "../src/MaxBTCERC20.sol";

contract DeployMaxBTCERC20Implementation is Script {
    function run() external {
        vm.startBroadcast();
        MaxBTCERC20 maxBTCERC20 = new MaxBTCERC20();
        vm.stopBroadcast();

        console.log("MaxBTCERC20 address: ", address(maxBTCERC20));
    }
}

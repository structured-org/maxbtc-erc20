// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {MockAumOracle} from "../src/MockAumOracle.sol";

contract DeployMockAumOracle is Script {
    function run() external {
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerKey);
        MockAumOracle oracle = new MockAumOracle();
        vm.stopBroadcast();

        console.log("MockAumOracle address:", address(oracle));
    }
}
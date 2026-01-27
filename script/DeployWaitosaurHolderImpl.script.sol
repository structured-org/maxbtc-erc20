// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

import {WaitosaurHolder} from "../src/WaitosaurHolder.sol";

contract DeployWaitosaurHolderImplementation is Script {
    function run() external {
        vm.startBroadcast();
        WaitosaurHolder impl = new WaitosaurHolder();
        vm.stopBroadcast();

        console.log("WaitosaurHolder implementation:", address(impl));
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {WaitosaurObserver} from "../src/WaitosaurObserver.sol";

contract DeployWaitosaurObserverImpl is Script {
    function run() external {
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerKey);
        WaitosaurObserver impl = new WaitosaurObserver();
        vm.stopBroadcast();

        console.log("WaitosaurObserver implementation:", address(impl));
    }
}
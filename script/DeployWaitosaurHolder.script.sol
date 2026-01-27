// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

import {WaitosaurHolder} from "../src/WaitosaurHolder.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployWaitosaurHolder is Script {
    function run() external {
        address implementation = vm.envAddress("IMPLEMENTATION");
        address owner = vm.envAddress("OWNER");
        address token = vm.envAddress("TOKEN");
        address locker = vm.envAddress("LOCKER");
        address unlocker = vm.envAddress("UNLOCKER");
        address receiver = vm.envAddress("RECEIVER");

        bytes memory initializeCall = abi.encodeCall(
            WaitosaurHolder.initialize,
            (owner, token, locker, unlocker, receiver)
        );

        vm.startBroadcast();
        ERC1967Proxy proxy = new ERC1967Proxy(implementation, initializeCall);
        vm.stopBroadcast();

        console.log("WaitosaurHolder proxy:", address(proxy));
        console.log("Configuration:");
        console.log("  Implementation:", implementation);
        console.log("  Owner:         ", owner);
        console.log("  Token:         ", token);
        console.log("  Locker:        ", locker);
        console.log("  Unlocker:      ", unlocker);
        console.log("  Receiver:      ", receiver);
    }
}
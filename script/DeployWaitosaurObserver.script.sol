// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {WaitosaurObserver} from "../src/WaitosaurObserver.sol";
import {
    ERC1967Proxy
} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployWaitosaurObserver is Script {
    function run() external {
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");

        address implementation = vm.envAddress("IMPLEMENTATION");
        address owner = vm.envAddress("OWNER");
        address locker = vm.envAddress("LOCKER");
        address unlocker = vm.envAddress("UNLOCKER");
        address oracle = vm.envAddress("ORACLE");
        string memory asset = vm.envString("ASSET");

        require(implementation.code.length > 0, "Implementation has no code");

        bytes memory initializeCall = abi.encodeCall(
            WaitosaurObserver.initialize,
            (
                owner,
                locker,
                unlocker,
                oracle,
                asset
            )
        );

        vm.startBroadcast(deployerKey);
        ERC1967Proxy proxy = new ERC1967Proxy(
            implementation,
            initializeCall
        );
        vm.stopBroadcast();

        console.log("WaitosaurObserver proxy address:", address(proxy));
        console.log("Configuration:");
        console.log("  Implementation:     ", implementation);
        console.log("  Owner:              ", owner);
        console.log("  Locker:             ", locker);
        console.log("  Unlocker:           ", unlocker);
        console.log("  Oracle:             ", oracle);
        console.log("  Asset:              ", asset);
    }
}
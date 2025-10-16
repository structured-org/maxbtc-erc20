// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { Test } from "forge-std/Test.sol";
import { MaxBTCERC20 } from "../src/MaxBTCERC20.sol";
import { ERC1967Proxy } from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract MaxBTCERC20Test is Test {
    address private constant OWNER = address(1);
    address private constant ICS20 = address(2);
    address private constant ESCROW = address(3);

    MaxBTCERC20 private maxBTCERC20;

    function setUp() external {
        MaxBTCERC20 implementation = new MaxBTCERC20();
        bytes memory maxBTCERC20InitializeCall =
            abi.encodeCall(MaxBTCERC20.initialize, (OWNER, ICS20, "Structured maxBTC", "maxBTC"));
        ERC1967Proxy proxy = new ERC1967Proxy(address(implementation), maxBTCERC20InitializeCall);
        maxBTCERC20 = MaxBTCERC20(address(proxy));
    }

    function testMintSuccess() external {
        vm.startPrank(ICS20);
        maxBTCERC20.mint(ESCROW, 100);
        assertEq(maxBTCERC20.balanceOf(ESCROW), 100);
    }

    function testMintUnauthorized() external {
        vm.startPrank(OWNER);
        vm.expectRevert(abi.encodeWithSelector(MaxBTCERC20.CallerIsNotICS20.selector, OWNER));
        maxBTCERC20.mint(ESCROW, 100);
    }

    function testBurnSuccess() external {
        vm.startPrank(ICS20);
        maxBTCERC20.mint(ESCROW, 100);
        maxBTCERC20.burn(ESCROW, 20);
        assertEq(maxBTCERC20.balanceOf(ESCROW), 80);
    }

    function testBurnUnauthorized() external {
        vm.startPrank(ICS20);
        maxBTCERC20.mint(ESCROW, 100);
        vm.startPrank(OWNER);
        vm.expectRevert(abi.encodeWithSelector(MaxBTCERC20.CallerIsNotICS20.selector, OWNER));
        maxBTCERC20.burn(ESCROW, 20);
    }
}

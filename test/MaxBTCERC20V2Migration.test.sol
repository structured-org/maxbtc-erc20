// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

// Run with `forge test --fork-url https://reth-ethereum.ithaca.xyz/rpc --match-contract MaxBTCERC20V2MigrationTest`

import { Test } from "forge-std/Test.sol";
import { MaxBTCERC20 } from "../src/MaxBTCERC20.sol";

contract MaxBTCERC20V2MigrationTest is Test {
    bool isOnEthereumFork;

    MaxBTCERC20 maxBtcErc20 = MaxBTCERC20(0xedBd0f9b4344fBCB9B6B747063bDfb9fE246498b);
    address constant MAXBTC_WHALE = 0xd8cbA23cdaF8e969Fd17c8EAbeCF82a4f002ee8D;

    address constant MOCK_CORE = address(1);
    address constant MOCK_RECEIVER = address(2);
    address constant MOCK_NEW_OWNER = address(3);

    function setUp() public {
        if (block.chainid == 1) {
            isOnEthereumFork = true;
        } else {
            isOnEthereumFork = false;
        }
    }

    modifier onlyOnEthereumFork() {
        vm.skip(!isOnEthereumFork);
        _;
    }

    function doMigration() private {
        address owner = maxBtcErc20.owner();

        address newImplementation = address(new MaxBTCERC20());
        bytes memory initializeV2Encoded = abi.encodeCall(MaxBTCERC20.initializeV2, (MOCK_CORE));

        vm.prank(owner);
        maxBtcErc20.upgradeToAndCall(newImplementation, initializeV2Encoded);
    }

    modifier afterMigration() {
        doMigration();
        _;
    }

    // ===== TESTS =====

    function test_migrationSuccess() public onlyOnEthereumFork {
        doMigration();
    }

    function test_owner() public onlyOnEthereumFork afterMigration {
        // expected owner is our Gnosis Safe multisig
        assertEq(maxBtcErc20.owner(), 0x20a9c004dE10D372ff021752083c8Cc8996550C1);
    }

    function test_transfers() public onlyOnEthereumFork afterMigration {
        uint256 whaleBalanceBefore = maxBtcErc20.balanceOf(MAXBTC_WHALE);

        vm.prank(MAXBTC_WHALE);
        maxBtcErc20.transfer(MOCK_RECEIVER, 1);

        assertEq(maxBtcErc20.balanceOf(MOCK_RECEIVER), 1);
        assertEq(maxBtcErc20.balanceOf(MAXBTC_WHALE), whaleBalanceBefore - 1);
    }

    function test_ownership() public onlyOnEthereumFork afterMigration {
        address owner = maxBtcErc20.owner();

        vm.prank(owner);
        maxBtcErc20.transferOwnership(MOCK_NEW_OWNER);

        vm.prank(MOCK_NEW_OWNER);
        maxBtcErc20.acceptOwnership();

        assertEq(maxBtcErc20.owner(), MOCK_NEW_OWNER);
    }
}

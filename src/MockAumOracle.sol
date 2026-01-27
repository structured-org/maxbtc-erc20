// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract MockAumOracle {
    mapping(string => uint256) public balances;

    function setSpotBalance(string calldata asset, uint256 amount) external {
        balances[asset] = amount;
    }

    function getSpotBalance(
        string calldata asset
    ) external view returns (uint256) {
        return balances[asset];
    }
}

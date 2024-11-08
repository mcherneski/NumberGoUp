// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {NumberGoUp} from "../src/NumberGoUp.sol";

contract DeployNumberGoUp is Script {
    function run() external {
        // Start broadcasting transactions
        vm.startBroadcast();

        // Deploy the NumberGoUp contract
        NumberGoUp numberGoUp = new NumberGoUp(
            "NumberGoUpToken", // name
            "NGU",             // symbol
            18,                // decimals
            1000000,           // maxTotalSupply
            msg.sender,        // initialOwner
            msg.sender,        // initialMintRecipient
            0xE592427A0AEce92De3Edee1F18E0157C05861564, // Updated Uniswap V3 SwapRouter02 address
            0xC36442b4a4522E871399CD717aBDD847Ab11FE88  // Updated Uniswap V3 NonfungiblePositionManager address
        );

        // Stop broadcasting transactions
        vm.stopBroadcast();
    }
} 
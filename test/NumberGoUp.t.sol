// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {NumberGoUp} from "../src/NumberGoUp.sol";

contract NumberGoUpTest is Test {
   NumberGoUp public numberGoUp;

   address public owner = makeAddr("owner");
   address public sara = makeAddr("sara");
   address public rob = makeAddr("rob");
   address public uniswapV3Router = makeAddr("uniswapV3Router");
   address public uniswapV3NonfungiblePositionManager = makeAddr("uniswapV3NonfungiblePositionManager");

uint8 public constant decimals = 18;
uint256 public constant maxTotalSupply = 10000;

   function setUp() public {
        numberGoUp = new NumberGoUp(
            "Number Go Up",
            "NGU",
            decimals,
            maxTotalSupply,
            owner,
            sara,
            uniswapV3Router,
            uniswapV3NonfungiblePositionManager
        );
   }

       function testInitialSetup() public view {
        // Test basic token information
        assertEq(numberGoUp.name(), "Number Go Up");
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {NumberGoUp} from "../src/NumberGoUp.sol";
import {console} from "forge-std/console.sol";

contract NumberGoUpTest is Test {

   NumberGoUp public numberGoUp;

   address public owner = makeAddr("owner");
   address public sara = makeAddr("sara");
   address public rob = makeAddr("rob");

   uint8 public constant decimals = 18;
   uint256 public constant maxTotalSupply = 10000;

   function setUp() public {
      numberGoUp = new NumberGoUp(
         "Number Go Up",
         "NGU",
         decimals,
         maxTotalSupply,
         owner,
         owner
      );
   }

   function test_InitialSetup() public view {
      assertEq(numberGoUp.name(), "Number Go Up");
      assertEq(numberGoUp.symbol(), "NGU");
      assertEq(numberGoUp.decimals(), decimals);
      assertEq(numberGoUp.totalSupply(), maxTotalSupply * 10 ** decimals);
      assertTrue(numberGoUp.erc721TransferExempt(owner));


      console.log("Owner:", owner);
   console.log("Sara:", sara);
   console.log("Rob:", rob);
   }

   function test_transferThreeTokensToSara() public {
      vm.prank(owner);
      numberGoUp.transfer(sara, 3);
      assertEq(numberGoUp.balanceOf(sara), 3 * (10 ** decimals));
      assertEq(numberGoUp.erc721BalanceOf(sara), 3);
      assertEq(numberGoUp.getQueueLength(sara), 3);

      // Log Sara's selling queue, can be viewed with -vvv 
      uint256 queueLength = numberGoUp.getQueueLength(sara);
      for (uint256 i = 0; i < queueLength; i++) {
         uint256 tokenId = numberGoUp.getIdAtQueueIndex(sara, uint128(i));
         console.log("Token ID at index", i, ":", tokenId);
      }
   }

   function test_stakeNFT() public {
      vm.prank(owner);
      numberGoUp.transfer(sara, 3);
      assertEq(numberGoUp.erc721BalanceOf(sara), 3);
      assertEq(numberGoUp.getQueueLength(sara), 3);
      vm.prank(sara);
      numberGoUp.stakeNFT(1);
      // Log Sara's selling queue
      console.log("Sara's Queue after staking tokens:");
      uint256 queueLength = numberGoUp.getQueueLength(sara);
      for (uint256 i = 0; i < queueLength; i++) {
         uint256 tokenId = numberGoUp.getIdAtQueueIndex(sara, uint128(i));
         console.log("Token ID at index", i, ":", tokenId);
      }
   }

   function test_unstakeNFT() public {
      test_stakeNFT();

      vm.prank(sara);
      numberGoUp.unstakeNFT(1);
      assertEq(numberGoUp.erc721BalanceOf(sara), 3);
      assertEq(numberGoUp.getQueueLength(sara), 3);
      console.log("Sara's Queue after unstaking tokens:");
      uint256 queueLength = numberGoUp.getQueueLength(sara);
      for (uint256 i = 0; i < queueLength; i++) {
         uint256 tokenId = numberGoUp.getIdAtQueueIndex(sara, uint128(i));
         console.log("Token ID at index", i, ":", tokenId);
      }
   }

   function test_transferTokensToExemptAddress() public {
      vm.prank(owner);
      numberGoUp.transfer(sara, 3);
      assertEq(numberGoUp.balanceOf(sara), 3 * (10 ** decimals));
      assertEq(numberGoUp.erc721BalanceOf(sara), 3);
      assertEq(numberGoUp.getQueueLength(sara), 3);

      vm.prank(owner);
      numberGoUp.setERC721TransferExempt(rob, true);
      assertEq(numberGoUp.erc721TransferExempt(rob), true);

      vm.prank(sara);
      numberGoUp.transfer(rob, 1);

      assertEq(numberGoUp.erc721BalanceOf(rob), 0);
      assertEq(numberGoUp.getQueueLength(rob), 0);
      assertEq(numberGoUp.erc20BalanceOf(rob), 1 * (10 ** decimals));

      assertEq(numberGoUp.getOwnerOfId(1), address(0), "Owner of token 1 should be 0x0");
      assertEq(numberGoUp.erc721BalanceOf(sara), 2);
      assertEq(numberGoUp.getQueueLength(sara), 2);
      console.log('Saras queue after transfer to exempt rob:');
      uint256 queueLength = numberGoUp.getQueueLength(sara);
      for (uint256 i = 0; i < queueLength; i++) {
         uint256 tokenId = numberGoUp.getIdAtQueueIndex(sara, uint128(i));
         console.log("Token ID at index", i, ":", tokenId);
      }
   }

   function test_transferTokensFromExemptAddress() public {
      vm.prank(owner);
      numberGoUp.setERC721TransferExempt(rob, true);
      assertEq(numberGoUp.erc721TransferExempt(rob), true);

      vm.prank(owner);
      numberGoUp.transfer(rob, 5);
      assertEq(numberGoUp.erc721BalanceOf(rob), 0);

      vm.prank(rob);
      numberGoUp.transfer(sara, 2);
      assertEq(numberGoUp.erc721BalanceOf(sara), 2);
      assertEq(numberGoUp.erc20BalanceOf(sara), 2 * (10 ** decimals));
      assertEq(numberGoUp.getQueueLength(sara), 2);

      console.log('Saras queue after transfer from exempt rob:');
      uint256 queueLength = numberGoUp.getQueueLength(sara);
      for (uint256 i = 0; i < queueLength; i++) {
         uint256 tokenId = numberGoUp.getIdAtQueueIndex(sara, uint128(i));
         console.log("Token ID at index", i, ":", tokenId);
      }
   }

   function test_TransferERC721TokensBetweenExemptAddresses() public {
      vm.prank(owner);
      numberGoUp.setERC721TransferExempt(rob, true);
      vm.prank(owner);
      numberGoUp.setERC721TransferExempt(sara, true);

      assertEq(numberGoUp.erc721TransferExempt(rob), true, "Rob should be exempt from ERC-721 transfers");
      assertEq(numberGoUp.erc721TransferExempt(sara), true, "Sara should be exempt from ERC-721 transfers");

      vm.prank(owner);
      numberGoUp.transfer(sara, 3);
      assertEq(numberGoUp.erc721BalanceOf(sara), 0);
      assertEq(numberGoUp.getQueueLength(sara), 0);
      assertEq(numberGoUp.erc20BalanceOf(sara), 3 * (10 ** decimals), "Sara should have 3 ERC-20 tokens");
      vm.prank(sara);
      numberGoUp.transfer(rob, 1);
      assertEq(numberGoUp.erc721BalanceOf(rob), 0);
      assertEq(numberGoUp.getQueueLength(rob), 0);

      assertEq(numberGoUp.erc20BalanceOf(sara), 2 * (10 ** decimals));
      assertEq(numberGoUp.erc20BalanceOf(rob), 1 * (10 ** decimals));
   }

}
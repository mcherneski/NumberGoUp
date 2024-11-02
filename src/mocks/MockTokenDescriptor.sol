// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {INonfungibleTokenPositionDescriptor} from "lib/v3-periphery/contracts/interfaces/INonfungibleTokenPositionDescriptor.sol";

contract MockTokenDescriptor is INonfungibleTokenPositionDescriptor {
    function tokenURI(INonfungiblePositionManager /*positionManager*/, uint256 /*tokenId*/)
        external
        pure
        override
        returns (string memory)
    {
        return "MockTokenDescriptor";
    }
}

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

import "./interfaces/IWETH.sol";

contract SmartWalletWETH {
    /***********************************|
    |   Constants                       |
    |__________________________________*/
    IWETH public WETH = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);

    /***********************************|
    |   Constructor                     |
    |__________________________________*/

    constructor(address[] memory _targets) public {
        for (uint256 index = 0; index < _targets.length; index++) {
            WETH.approve(_targets[index], uint256(-1));
        }
    }

    /**
     * @notice SmartWallet WETH balance
     * @dev SmartWallet WETH balance
     */
    function wethBalance() internal returns (uint256 balance) {
        return WETH.balanceOf(address(this));
    }
}

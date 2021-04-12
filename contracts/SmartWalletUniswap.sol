// SPDX-License-Identifier: MIT

pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

import "./interfaces/IUniswapV2Router.sol";

contract SmartWalletUniswap {
    /***********************************|
    |   Constants                       |
    |__________________________________*/
    IUniswapV2Router private router =
        IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

    /***********************************|
    |   Constructor                     |
    |__________________________________*/

    constructor() public {}

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) internal returns (uint256[] memory amounts) {
        // Execute Swap
        router.swapExactTokensForTokens(
            amountIn,
            amountOutMin,
            path,
            to,
            deadline
        );
    }
}

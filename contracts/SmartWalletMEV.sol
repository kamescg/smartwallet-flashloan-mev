pragma solidity ^0.6.10;

// pragma experimental ABIEncoderV2;

/**
 * @notice MEV (Maximal Extractable Value)
 * @dev Essential smart contract functions for MEV execution.
 */
contract SmartWalletMEV {
    /**
     * @dev Reward Miner
     * @param _ethAmountToCoinbase ETH amount to send to Block coinbase.
     */
    function rewardCoinbase(uint256 _ethAmountToCoinbase) internal {
        block.coinbase.transfer(_ethAmountToCoinbase);
    }
}

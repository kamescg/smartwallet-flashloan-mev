pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

import "./SmartWalletFlashLoan.sol";
import "./SmartWalletWETH.sol";
import "./SmartWalletMEV.sol";

/**
 * @notice SmartWallet (SmartWalletFlashLoan, ICalle)
 * @dev Deploys the SmartWallet smart contract with flashloans enabled.
 */
contract SmartWallet is SmartWalletFlashLoan, SmartWalletWETH, SmartWalletMEV {
    /***********************************|
    |   Constants                       |
    |__________________________________*/
    mapping(address => bool) public auth;

    /***********************************|
    |     		    Events              |
    |__________________________________*/
    event FlashCast(address origin, uint256 amount);

    /***********************************|
    |     		  Constructor           |
    |__________________________________*/

    /**
     * @notice Setup SmartWallet
     * @dev Create SmartWallet with deployer as authorized sender.
     */
    constructor(address[] memory _targets) public SmartWalletWETH(_targets) {
        auth[msg.sender] = true;
    }

    receive() external payable {}

    fallback() external payable {
        revert("SmartWallet:invalid-function");
    }

    /***********************************|
    |     		   Functions            |
    |__________________________________*/

    /**
     * @dev Check for Auth if enabled.
     * @param user address/user/owner.
     */
    function isAuth(address user) public view returns (bool) {
        return auth[user];
    }

    /**
     * @notice Execute "spell" a smart contract call.
     * @dev Execute call on target address.
     * @param _target Smart contract target
     * @param _data Calldata for execution
     * @param _value ETH amount during method executation
     */
    function spell(
        address _target,
        bytes memory _data,
        uint256 _value
    ) internal {
        require(_target != address(0), "target-invalid");
        (bool success, bytes memory returnData) =
            _target.call{value: _value}(_data);
        require(success);
    }

    /**
     * @dev Callback from DyDx flashloan
     * @dev Callback from DyDx flashloan with spells passed.
     * @param _sender description
     * @param _loanAmount description
     * @param _transferProfits description
     */
    function execution(
        address payable _sender,
        uint256 _loanAmount,
        uint256 _ethAmountToCoinbase,
        bool _transferProfits
    ) internal override {
        console.log("Coinbase", block.coinbase);
        console.log("Coinbase Reward Amount", _ethAmountToCoinbase);

        require(isAuth(_sender), "SmartWallet:unauthorized");

        // Ensure Targets/Data Match
        require(
            targets.length == payloads.length,
            "SmartWallet:array-length-invalid"
        );

        // Cast Spells (Iterate over Targets/Data/Value)
        for (uint256 i = 0; i < targets.length; i++) {
            spell(targets[i], payloads[i], values[i]);
        }

        // Check Execution was Profitable
        require(
            WETH.balanceOf(address(this)) > _loanAmount + 2,
            "SmartWallet:cannot-repay-loan"
        );

        console.log("WETH Balance", wethBalance());
        console.log("ETH Balance", address(this).balance);

        // Reward Miner/Staker Coinbase
        rewardCoinbase(_ethAmountToCoinbase);

        // Transfer Profits to Sender Address
        if (_transferProfits) {
            WETH.withdraw(WETH.balanceOf(address(this)) - _loanAmount - 2);
            _sender.transfer(address(this).balance);
        }

        // Delete Values for potential gas savings
        delete targets;
        delete payloads;
        delete values;
    }
}

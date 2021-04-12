// SPDX-License-Identifier: MIT

pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

/* --- Global Contracts --- */
import "hardhat/console.sol";

/* --- Local Contracts --- */
import "./interfaces/External.sol";
import "./interfaces/IUniswapV2Router.sol";

interface ICallee {
    function callFunction(
        address sender,
        Account.Info memory accountInfo,
        bytes memory data
    ) external;
}

contract SmartWalletFlashLoan is ICallee {
    address[] private path;
    address[] internal targets;
    bytes[] internal payloads;
    uint256[] internal values;

    // DyDx
    ISoloMargin private dydx =
        ISoloMargin(0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e);

    /***********************************|
    |     		  Constructor           |
    |__________________________________*/

    /**
     * @notice SmartWalletFlashLoan constructor
     * @dev SmartWalletFlashLoan constructor which "infinite" approves WETH Uniswap and DyDx
     */
    constructor() public {}

    /**
     * @dev Execute Flash loan
     * @param loanAmount The Citadel Owner
     */
    function flashLoan(
        uint256 loanAmount,
        uint256 _ethAmountToCoinbase,
        address[] memory _targets,
        bytes[] memory _payloads,
        uint256[] memory _values
    ) external payable {
        // Store Execution for Callback
        // The target, data and value arrays are stored in the smart contract memory
        // for use when the DyDx smart contract executes the "callFunction" function.
        // The values are deleted upon exection completition for potential gas savings.
        targets = _targets;
        payloads = _payloads;
        values = _values;

        // Configure FlashLoan
        Actions.ActionArgs[] memory operations = new Actions.ActionArgs[](3);

        // Withdraw : Operation
        operations[0] = Actions.ActionArgs({
            actionType: Actions.ActionType.Withdraw,
            accountId: 0,
            amount: Types.AssetAmount({
                sign: false,
                denomination: Types.AssetDenomination.Wei,
                ref: Types.AssetReference.Delta,
                value: loanAmount // Amount to borrow
            }),
            primaryMarketId: 0, // WETH
            secondaryMarketId: 0,
            otherAddress: address(this),
            otherAccountId: 0,
            data: ""
        });

        // Call Smart Wallet : Operation
        operations[1] = Actions.ActionArgs({
            actionType: Actions.ActionType.Call,
            accountId: 0,
            amount: Types.AssetAmount({
                sign: false,
                denomination: Types.AssetDenomination.Wei,
                ref: Types.AssetReference.Delta,
                value: 0
            }),
            primaryMarketId: 0,
            secondaryMarketId: 0,
            otherAddress: address(this),
            otherAccountId: 0,
            data: abi.encode(msg.sender, loanAmount, _ethAmountToCoinbase, true)
        });

        // Deposit Funds : Operation
        operations[2] = Actions.ActionArgs({
            actionType: Actions.ActionType.Deposit,
            accountId: 0,
            amount: Types.AssetAmount({
                sign: true,
                denomination: Types.AssetDenomination.Wei,
                ref: Types.AssetReference.Delta,
                value: loanAmount + 2 // Repayment amount with 2 wei fee
            }),
            primaryMarketId: 0, // WETH
            secondaryMarketId: 0,
            otherAddress: address(this),
            otherAccountId: 0,
            data: ""
        });

        Account.Info[] memory accountInfos = new Account.Info[](1);
        accountInfos[0] = Account.Info({owner: address(this), number: 1});

        dydx.operate(accountInfos, operations);
    }

    function execution(
        address payable _sender,
        uint256 _loanAmount,
        uint256 _ethAmountToCoinbase,
        bool _transferProfits
    ) internal virtual {}

    /**
     * @dev Callback from DyDx flashloan
     * @dev Callback from DyDx flashloan with spells passed.
     * @param sender description
     * @param accountInfo description
     * @param data description
     */
    function callFunction(
        address sender,
        Account.Info memory accountInfo,
        bytes memory data
    ) external override {
        // Decode Data
        (
            address payable _sender,
            uint256 _loanAmount,
            uint256 _ethAmountToCoinbase,
            bool _transferProfits
        ) = abi.decode(data, (address, uint256, uint256, bool));

        // Execute Arbitrage Function
        execution(_sender, _loanAmount, _ethAmountToCoinbase, _transferProfits);
    }
}

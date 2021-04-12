## SmartWalletFlash

The SmartWallet smart contracts combine fee-less flashloans with MEV execution(Maximal Extractable Value) execution.

The smart contracts are a simple prototype for executing flashloans using DyDx (fee-less flashloans) and send transactions to "FlastBot" enabled miner provider endpoints.

A SmartWallet deplyoment allow "arbitrary" smart contract - the contract can interact with any deployed mainnet smart contract without prior interface knowledge. The target and payloads are generated off-chain and passed to the contract for execution. In other words the smart contract can interact with Uniswap, Aave, Compound, yEarn, any other decentralized finance protocol simply by "populating" a transaction payload and associating the payload with a target address.

- Flashloan Powered Smart Wallet
- Reward Block Miners (payment to block coinbase)
- Execute arbitrary smart contract functions.

#### To-Do

- [] Ephemeral Smart Contracts
- [] Transaction Payload Generation

An important feature for the SmartWallet will be a completely "ephemeral" smart contract that is created and destroyed in the same transaction - allowing for a completely "gasless" execution. In short 0 ETH will eventually be required to capitalize on arbitration opportunities. All that will be required is identification and execution using a SmartWallet factory and a "FlashBot" provider endpoint.

### Hardhat Tasks

The SmartWallet ETH tasks simulate SmartWallet execution with common tasks.

yarn hardhat smartwallet-test [SMART_WALLET] [AMOUNT] [COINBASE_REWARD]
yarn hardhat smartwallet-test 0x000...00000 100 0.1

# Resources

https://gist.github.com/cryptoscopia/1156a368c19a82be2d083e04376d261e

https://github.com/coryagroup/flash-loans/blob/master/dydxFlashLoan.sol

https://gist.github.com/cryptoscopia/1156a368c19a82be2d083e04376d261e

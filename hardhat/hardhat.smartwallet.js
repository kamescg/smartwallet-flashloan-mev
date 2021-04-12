const { utils } = require("ethers");

/**
 * @name deploy-flashloan-template
 * @description Deploy PoolPower DAI
 */
task("deploy-smartwallet", "").setAction(async ({}) => {
  const Contract = await ethers.getContractFactory("SmartWallet");
  const contract = await Contract.deploy();
  await contract.deployed();
  console.log("SmartWallet:", ethers.utils.getAddress(contract.address));
});

task("smartwallet-test", "")
  .addPositionalParam("address")
  .addPositionalParam("amount")
  .addPositionalParam("ethAmountToCoinbase")
  .setAction(async ({ address, amount, ethAmountToCoinbase }) => {
    const contract = await ethers.getContractAt("SmartWallet", address);

    const FLASH_AMOUNT = utils.parseEther(amount);
    const ETH_AMOUNT_TO_COINBASE = utils.parseEther(ethAmountToCoinbase);

    // The Smart Contract targets (WETH)
    const TARGETS = [
      "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2",
      "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2",
    ];

    // The Smart Contract execuation payload (WETH deposit/withdrawal)
    const PAYLOAD = [
      "0x2e1a7d4d0000000000000000000000000000000000000000000000000000000000000064", // WETH withdraw(100)
      "0xd0e30db0", // WETH Deposit
    ];

    // The Smart Contract execution value (0/10 ETH)
    const VALUE = ["0", utils.parseEther("10")];

    // Execute FlashLoan
    const transaction = await contract.flashLoan(
      FLASH_AMOUNT,
      ETH_AMOUNT_TO_COINBASE,
      TARGETS,
      PAYLOAD,
      VALUE,
      {
        value: utils.parseEther("100"),
      }
    );

    console.log("Transaction", transaction);
  });

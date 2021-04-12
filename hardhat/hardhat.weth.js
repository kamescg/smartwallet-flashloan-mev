const { constants } = require("ethers");

task("weth-withdraw-populate")
  .addPositionalParam("amount")
  .setAction(async ({ amount }) => {
    const contract = await ethers.getContractAt("IWETH", constants.AddressZero);
    const txPopulated = await contract.populateTransaction.withdraw(amount);
    console.log(txPopulated, "txPopulated");
  });

task("weth-deposit-populate").setAction(async ({}) => {
  const contract = await ethers.getContractAt("IWETH", constants.AddressZero);
  const txPopulated = await contract.populateTransaction.deposit();
  console.log("Deposit", txPopulated);
});

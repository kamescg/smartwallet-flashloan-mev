/**
 * @name SmartWallet
 * @description Deploy the SmartWallet smart contract.
 */
const SmartWallet = async ({ getNamedAccounts, deployments }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  await deploy("SmartWallet", {
    from: deployer,
    args: [
      [
        "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D", // Uniswap Router
        "0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e", // DyDx
      ],
    ],
    log: true,
  });
};

module.exports = SmartWallet;

module.exports.tags = ["SmartWallet"];

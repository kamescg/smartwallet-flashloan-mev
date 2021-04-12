/**
 * @name Multicall
 */
const Multicall = async ({ getNamedAccounts, deployments }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  await deploy("Multicall", {
    from: deployer,
    args: [],
    log: true,
  });
};

module.exports = Multicall;

module.exports.tags = ["Multicall"];

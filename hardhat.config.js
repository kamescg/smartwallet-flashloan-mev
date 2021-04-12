/* --- Global Modules --- */
require("dotenv").config();
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-waffle");
require("hardhat-deploy");

/* --- Local Modules --- */
require("./hardhat/hardhat.helpers");
require("./hardhat/hardhat.smartwallet");
require("./hardhat/hardhat.weth");
const networks = require("./hardhat.networks");

/* --- Hardhat Configuration --- */
module.exports = {
  defaultNetwork: "localhost",
  networks,
  etherscan: {
    apiKey: process.env.ETHERSCAN_KEY,
  },
  namedAccounts: {
    deployer: {
      default: 0,
    },
    admin: {
      default: 1,
    },
    artist: {
      default: 2,
    },
  },

  solidity: {
    compilers: [
      {
        version: "0.6.6",
      },
      {
        version: "0.6.10",
      },
    ],
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
};

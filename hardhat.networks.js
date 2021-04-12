const networks = {
  // Test Coverage
  coverage: {
    url: "http://127.0.0.1:8555",
    blockGasLimit: 200000000,
    allowUnlimitedContractSize: true,
  },

  // Localhost
  localhost: {
    url: "http://127.0.0.1:8545",
    blockGasLimit: 200000000,
    allowUnlimitedContractSize: true,
  },

  // Hardhat
  hardhat: {
    chainId: 1337,
    accounts: {
      mnemonic: process.env.MNEMONIC_MAINNET,
    },
    forking: {
      url: `https://eth-mainnet.alchemyapi.io/v2/${process.env.ALCHEMY_KEY}`,
    },
  },

  // MAINNET CONFIGURATION
  mainnet: {
    url: `https://eth-mainnet.alchemyapi.io/v2/${process.env.ALCHEMY_KEY}`,
    gasPrice: 1000000000,
    accounts: {
      mnemonic: process.env.MNEMONIC_MAINNET,
    },
  },

  // RINKEBY CONFIGURATION
  rinkeby: {
    url: `https://eth-rinkeby.alchemyapi.io/v2/${process.env.ALCHEMY_RINKEBY_KEY}`,
    accounts: {
      mnemonic: process.env.MNEMONIC_RINKEBY,
    },
  },
};

module.exports = networks;

require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
require("@openzeppelin/hardhat-upgrades");
const env = {
  url: process.env.SEPOLIA_RPC_URL,
  deploy: process.env.DEPLOY,
  test2: process.env.TEST2,
  test3: process.env.TEST3,
};
module.export = env;
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.5.16",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
          evmVersion: "istanbul",
        },
      },
      {
        version: "0.6.6",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
          evmVersion: "istanbul",
        },
      },
    ],
  },

  networks: {
    // localhost
    //   : {
    //   url: "http://127.0.0.1:8545"
    //   ,
    //   chainId: 31337, // 本地 Hardhat 网络的默认链 ID
    // },
    sepolia: {
      url: process.env.SEPOLIA_RPC_URL,
      accounts: [process.env.DEPLOY, process.env.TEST2, process.env.TEST2],
      gas: 600000,
    },
  },
  gasReporter: {
    currency: "USD",
    // enabled: process.env.REPORT_GAS ? true : false,
    enabled: true,
    excludeContracts: [],
    src: "./contracts",
  },
};

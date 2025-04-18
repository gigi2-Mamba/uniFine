const { ethers, upgrades } = require("hardhat");

async function multiSig() {
  const [deployer, test2] = await ethers.getSigners();
  //   console.log("Deploying contracts with the account:", deployer.address);
  //   console.log("Account balance:", (await deployer.getBalance()).toString());
  const MultiSig = await ethers.getContractFactory("multiSignature");
  const multiSig = await upgrades.deployProxy(
    MultiSig,
    [[deployer.address, test2.address], 2],
    { initializer: "Initialize" }
  );
  await multiSig.deployed();
  console.log("multiSig deployed to:", multiSig.address);
}

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("add:", deployer.address);
  const MultiSig = await ethers.getContractFactory("multiSignature");
  const multiSig = await MultiSig.attach(
    "0x091EcD3CDC9d1390a3AaaA842b9B9Ba4a4bdB91a"
  );
  //   await multiSig.validPeriod();
  // let validPeriod = await multiSig.validPeriod();
  const res = await multiSig.threshold(); // ethers版本太烂了
  // console.log("validPeriod: ", await multiSig.threshold());
  console.log("res: ", res);
}

// async function multiSig2() {
//   const [deployer] = await ethers.getSigners();
//   console.log("add:", deployer.address);

// }

multiSig()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    const WETH = await ethers.getContractFactory("WETH9");
    const weth = await WETH.deploy();
    await weth.waitForDeployment();
    const wethAddress = await weth.getAddress();
    console.log("WETH deployed to:", wethAddress);  //  0xdc64a140aa3e981100a9beca4e685f962f0cf6c9
}
// async function main() {
//     // 替换为你的合约地址
//     const contractAddress = "0x5fbdb2315678afecb367f032d93f642f64180aa3";

//     // 获取合约工厂并附加到已部署的合约地址
//     const MyContract = await ethers.getContractFactory("WETH9");
//     const myContract = MyContract.attach(contractAddress);

//     // 调用合约方法，例如 getValue()
//     const symbol = await myContract.symbol();
//     const decimal = await myContract.decimals();
//     console.log(`decimal ${decimal}`);
//     console.log(symbol);
// }

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });








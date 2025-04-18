const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);
    const router = await ethers.getContractFactory("UniswapV2Router02", deployer);
    //    const    koko = 0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0
    //    const coco =  0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9
    const factory = "0xe7f1725e7734ce288f8367e1bb143e90bb3f0512";
    const weth = "0x5fbdb2315678afecb367f032d93f642f64180aa3";
    const router02 = await router.deploy(factory, weth);
    const routeAddress = await router02.getAddress();
    console.log("Router address:", routeAddress);  //0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9



}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
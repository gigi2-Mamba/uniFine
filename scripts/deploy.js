const { ethers } = require("hardhat");

async function factory() {
    const [deployer] = await ethers.getSigners();

    console.log('部署合约的账户地址:', deployer.address);  //   factory合约

    // const Erc20 = await ethers.getContractFactory("UniswapV2ERC20");

    // console.log("Deploying ERC20");
    // const erc20 = await Erc20.deploy();
    // await erc20.deployed();

    const Factory = await ethers.getContractFactory("UniswapV2Factory");   // 部署要依赖hardhat 继承的ethers
    console.log("Deploying  factory");
    const factory = await Factory.deploy(deployer.address);  // 跟的是构造函数的参数
    // console.log("factory address:", factory.address);
    await factory.waitForDeployment();
    const factoryAddress = await factory.getAddress();
    console.log("Factory合约已部署到地址:", factoryAddress); //0x5FC8d32690cc91D4c39d9d3abcBD16989F875707

    // 验证是否本地部署成功
    // const provider = ethers.provider;
    // const address = "0x5fbdb2315678afecb367f032d93f642f64180aa3"; // 替换为实际的合约地址
    // const code = await provider.getCode(address);
    // if (code !== "0x") {
    //     console.log("合约存在于地址:", address);
    // } else {
    //     console.log("地址上没有合约:", address);
    // }
}

router()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });


async function router() {  // Router deploy
    const [deployer] = await ethers.getSigners();
    console.log('部署合约的账户地址:', deployer.address);
    const Router = await ethers.getContractFactory("UniswapV2Router02");  //  这里不填默认就是第一个
    const factory = "0x5FC8d32690cc91D4c39d9d3abcBD16989F875707";
    const weth = "0xdc64a140aa3e981100a9beca4e685f962f0cf6c9";
    const router = await Router.deploy(factory, weth);
    await router.waitForDeployment();
    const routerAddress = await router.getAddress();
    console.log("Router合约已部署到地址:", routerAddress); //0x0165878A594ca255338adfa4d48449f69242Eb8F



}

// 可升级部署
async function routerProxy() {

}
const { ethers } = require("hardhat");

async function main() {
    const [deployer] = ethers.getSigners();
    // 调用router大作战
    let Router = ethers.getContractFactory("UniswapV2Router02");

    let router = (await Router).attach("0x0165878A594ca255338adfa4d48449f69242Eb8F")
    let tokenA = "0x5FbDB2315678afecb367f032d93F642f64180aa3";
    let tokenB = "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512";
    router.addLiquidity()


}
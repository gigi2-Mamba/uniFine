const env = require("hardhat");
const { ethers } = require("hardhat");

async function main1() {
    const [deployer, one, two] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    // const ERC20 = await ethers.getContractFactory("ERC20", deployer);
    // const coco = await ERC20.deploy("Coco", "coco", 18);
    // const koko = await ERC20.deploy("Koko", "koko", 18);
    // // //     kokoToken 地址 0x5FbDB2315678afecb367f032d93F642f64180aa3
    // // // acToken 地址 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512
    // const kokoTokenAddress = await coco.getAddress();
    const acTokenAddress = await koko.getAddress();
    // console.log(`kokoToken 地址 ${kokoTokenAddress}`);
    console.log(`acToken 地址 ${acTokenAddress}`);

    // await coco.mint(100, {});
    // await koko.mint(300, {});


    console.log("ERC20 deployed and mint success ");

    //发起转移代币
    // let contract1 = await ERC20.attach("0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512");
    // let contract2 = await ERC20.attach("0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0");
    // 通过构造一个特定的 Wallet 来获得签名者
    // const specificSigner = new ethers.Wallet("0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80", provider);
    // contact1 = contract1.connect(deployer);
    // contract2 = contract2.connect(deployer);

    // await contract1.transfer(one, 100);
    // await contract2.transfer(one, 100);

    //    console.log()



}

async function sepolia() {
    const [deployer, one, two] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);
    const ERC20 = await ethers.getContractFactory("ERC20Sep", deployer);
    const coco = await ERC20.deploy("B1", "b1", 1);
    // const koko = await ERC20.deploy("Koko1", "koko1", 1);
    // //     kokoToken 地址 0x5FbDB2315678afecb367f032d93F642f64180aa3
    // // acToken 地址 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512
    const kokoTokenAddress = await coco.getAddress();
    // const acTokenAddress = await koko.getAddress();
    console.log(`kokoToken 地址 ${kokoTokenAddress}`);
    // console.log(`acToken 地址 ${acTokenAddress}`);

    await coco.mint(one, 100);
    // await koko.mint(one, 5);


    console.log("ERC20 deployed and mint success ");
}

async function main() {
    const [deployer, one, two] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);
    const ERC20 = await ethers.getContractFactory("ERC20Sep", deployer);
    let erc = await ERC20.attach("0x6331b5292b476937ee83507D19EB6F07b2CcDe77");
    await erc.mint(one, 60);
    console.log("ERC20 deployed and mint success ");


}
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });



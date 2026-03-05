const hre = require("hardhat");

async function main() {
  const [buyer, seller, arbiter] = await hre.ethers.getSigners();
  
  const Escrow = await hre.ethers.getContractFactory("Escrow");
  const escrow = await Escrow.deploy(seller.address, arbiter.address);

  await escrow.waitForDeployment();

  console.log("Escrow Contract deployed to:", await escrow.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

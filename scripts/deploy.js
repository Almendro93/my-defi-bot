const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const SimpleTradingBot = await ethers.getContractFactory("SimpleTradingBot");
  const simpleTradingBot = await SimpleTradingBot.deploy(
    // Dirección del token a intercambiar
    "0x123...",  // Reemplazar con la dirección real del token
    100,         // Precio de compra
    90           // Precio de venta
  );

  console.log("SimpleTradingBot address:", simpleTradingBot.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });

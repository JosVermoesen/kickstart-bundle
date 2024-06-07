const HDWalletProvider = require("@truffle/hdwallet-provider");
const { Web3 } = require("web3");
const { interface, bytecode } = require("./compile");

const secrets = require("./../secrets/secrets");
const provider = new HDWalletProvider(secrets.metamask, secrets.görli);

const web3 = new Web3(provider);

const deploy = async () => {
  const accounts = await web3.eth.getAccounts();

  console.log("Attempting to deploy from account", accounts[0]);

  const result = await new web3.eth.Contract(JSON.parse(interface))
    .deploy({ data: bytecode })
    .send({ gas: "1000000", from: accounts[0] });

  console.log(interface);
  console.log("Contract deployed to", result.options.address);
  provider.engine.stop();
};
deploy();

// Contract was deployed to:
// 0x95f54cDe5A5ABD4d1429a90ee02A87Abe30E05B2 (25/05/2022) datetime added in structs
// 0xC5852aBb836fe4401C593fb3aB98d4BAc708408F (26/05/2022) renaming functions
// 0xa75C82eA03AFC3a52513c60f8e3000974A340697 (11/11/2022) görli instead of rinkeby
// 0x6Eaf66F5fa7db3c0a41108ed8805C3565AF22572 (07/06/2024) Sepolia

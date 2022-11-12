const HDWalletProvider = require('@truffle/hdwallet-provider');
const Web3 = require('web3');
const { interface, bytecode } = require('./compile');

const secrets = require('./../secrets/secrets');
const provider = new HDWalletProvider(secrets.metamask, secrets.görli);

const web3 = new Web3(provider);

const deploy = async () => {
  const accounts = await web3.eth.getAccounts();

  console.log('Attempting to deploy from account', accounts[0]);

  const result = await new web3.eth.Contract(JSON.parse(interface))
    .deploy({ data: bytecode, arguments: ['Hi there!'] })
    .send({ gas: '1000000', from: accounts[0] });

  console.log('Contract deployed to', result.options.address);
  provider.engine.stop();
};
deploy();

// Contract was deployed to:
// 0xa75C82eA03AFC3a52513c60f8e3000974A340697

// Görli instead of rinkeby from 11/11/2022
// 0xFB211eAa46994050ca097406C8E61e7c81D0A15f 12/11/2022
//

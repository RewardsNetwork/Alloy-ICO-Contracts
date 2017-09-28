require('babel-register');
require('babel-polyfill');

var HDWalletProvider = require('truffle-hdwallet-provider');

const mnemonic = process.env.TEST_MNETONIC || 'mojo jojo mojo jojo mojo jojo mojo jojo mojo jojo mojo jojo';
const ropstenProvider = new HDWalletProvider(mnemonic, 'https://ropsten.infura.io/');
const kovanProvider = new HDWalletProvider(mnemonic, 'https://kovan.infura.io/');

module.exports = {
    networks: {
        development: {
            host: "localhost",
            port: 8545,
            network_id: "*"
        },
        mainnet: {
            network_id: 1,
            from: '',
            host: 'localhost',
            port: 8545,
            gas: 4e6
        },
        ropsten: {
            network_id: 3,
            provider: ropstenProvider,
            gas: 4.7e6
        },
        kovan: {
            network_id: 42,
            provider: kovanProvider,
            gas: 4.99e6
        }
    },
    build: {}
};

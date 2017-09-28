var Migrations = artifacts.require("./Migrations.sol");

module.exports = function(deployer) {

    // web3.personal.unlockAccount(web3.eth.accounts[0], '11111111');

    deployer.deploy(Migrations);

};
var AlloyToken = artifacts.require("./AlloyToken.sol");

module.exports = function(deployer, network, accounts) {

    const ALLOY_TOKEN_ADDRESS = null

    if(ALLOY_TOKEN_ADDRESS) return

    deployer.deploy(AlloyToken).then(function () {
        console.log('ALLOY Token Successfully deployed at ' + AlloyToken.address)
    });

};
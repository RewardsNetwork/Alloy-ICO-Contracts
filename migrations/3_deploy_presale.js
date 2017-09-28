var AlloyToken = artifacts.require("./AlloyToken.sol");
var AlloyPresale = artifacts.require("./AlloyPresale.sol");

module.exports = function(deployer, network, accounts) {

    const ALLOY_TOKEN_ADDRESS = AlloyToken.address

    if(!ALLOY_TOKEN_ADDRESS) return;

    // Timelines
    const startTime = new Date().getTime() / 1000
    const endTime = startTime + (3600 * 24)

    // Rate of ether to ALLOY in wei + 20% Pre-sale bonus
    const rate = 575 + 115

    // Multisigned Crowdsale wallet
    const wallet = '0x000862d3b8FaAa1d3a89Ae21F88Ba70426c67Cc0'

    // Hardcap
    const cap = web3.toWei(17391, "ether")

    deployer.deploy(AlloyPresale, ALLOY_TOKEN_ADDRESS, startTime, endTime, rate, wallet, cap);

    console.log("Presale Starts at : " + startTime);
    console.log("Presale Ends at : " + endTime);

};


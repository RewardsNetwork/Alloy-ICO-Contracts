var AlloyCrowdsale = artifacts.require("./AlloyCrowdsale.sol");
var AlloyToken = artifacts.require("./AlloyToken.sol");

module.exports = function(deployer, network, accounts) {

    const ALLOY_TOKEN_ADDRESS = AlloyToken.address

    if(!ALLOY_TOKEN_ADDRESS) return;

    const startTime = new Date().getTime() / 1000
    const endTime = startTime + (3600 * 24)
    const rate = 575    // rate of ether to ALLOY in wei

    // Multisigned Crowdsale wallet
    const wallet = '0x000862d3b8FaAa1d3a89Ae21F88Ba70426c67Cc0'

    // Hardcap
    const cap = web3.toWei(86956 - 17391, "ether")

    // Softcap
    const goal = web3.toWei(10000, "ether")

    deployer.deploy(AlloyCrowdsale, ALLOY_TOKEN_ADDRESS, startTime, endTime, rate, wallet, cap, goal);

    console.log("Sale Starts at : " + startTime);
    console.log("Sale Ends at : " + endTime);

};


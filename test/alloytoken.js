/*
 * More Tests to follow in upcoming days
 */
var AlloyToken = artifacts.require("./AlloyToken.sol");
var AlloyPresale = artifacts.require("./AlloyPresale.sol");

contract('AlloyToken', function(accounts) {
    it("transfer 1 eth to crowdsale", function() {
        var account1 = accounts[1];
        return AlloyPresale.deployed().then(function(crowdsale){
            return crowdsale;
        }).then(function (crowdsale) {
            return crowdsale.token().then(function(tokenAddress){
                console.log('ALLOY Token Address is ' + tokenAddress)
                return tokenAddress;
            })
        }).then(function(tokenAddress){
            return AlloyToken.at(tokenAddress);
        }).then(function(tokenInstance){
            tokenInstance.balanceOf(account1).then(function(balance){
                assert.equal(balance.toString(10), 0, "Account balance was not 0");
                console.log('ACCOUNT 1 ALLOY balance is ' + balance.toString(10))
            });
            return tokenInstance;
        }).then(function(tokenInstance){
            AlloyPresale.deployed().then(function(inst){
                inst.sendTransaction({ from: account1, value: web3.toWei(1, "ether")})
            });
            return tokenInstance;
        }).then(function(tokenInstance){
            return tokenInstance.balanceOf(account1).then(function(balance){
                account1AlloyTokenBalance = balance.toString(10);
                console.log('Updated ACCOUNT 1 ALLOY balance is ' + web3.fromWei(account1AlloyTokenBalance, "ether"));
                assert.equal(web3.fromWei(account1AlloyTokenBalance, "ether"), '575', "Account balance was not 575");
            })
        });
    });
});

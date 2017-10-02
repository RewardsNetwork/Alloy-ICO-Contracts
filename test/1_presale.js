/*
 * More Tests to follow in upcoming days
 */
var AlloyToken = artifacts.require("./AlloyToken.sol");
var AlloyPresale = artifacts.require("./AlloyPresale.sol");

contract('AlloyPresale', function(accounts) {
    it("transfer 1 eth to crowdsale", function() {
        var account = accounts[0];
        var token;

        // Start with the Deployed ALLOY Token instance
        return AlloyToken.deployed().then(function(tokenInstance){

            /*
             * Get the balance for account 0 before we start
             */

            token = tokenInstance

            // Return the promise
            return tokenInstance.balanceOf(account)

        }).then(function(balance){

            /*
             * Balance for account 0 should be 0
             */
            return assert.equal(balance.toString(10), 0, "Account balance was not 0");

        }).then(function(){

            /*
             * Get the Presale instance
             */

            return AlloyPresale.deployed().then(function(crowdsale){

                // Add the Presale contract to the Mint agent whitelist
                token.setMintAgent(crowdsale.address, true)

                return crowdsale;
            })

        }).then(function(crowdsale){

            /*
             * Transfer 1 ETH to the Presale contract from account 0
             */

            return crowdsale.sendTransaction({ from: account, value: web3.toWei(1, "ether")})

        }).then(function(){

            /*
             * Initiate a balance query & return the promise
             */

            return token.balanceOf(account)

        }).then(function(balance){

            /*
             * Check the account 0 balance - 1 ETH = 690 ALLOYs
             */

            return assert.equal(balance.toString(10), web3.toWei(690, "ether"), "Account balance was not 690");

        });

    });
});

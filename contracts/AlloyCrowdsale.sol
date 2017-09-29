pragma solidity ^0.4.11;

import './ownership/Ownable.sol';
import './lifecycle/Pausable.sol';
import './lifecycle/Destructible.sol';
import './crowdsale/CappedCrowdsale.sol';
import './crowdsale/RefundableCrowdsale.sol';

/**
 * @title AlloyCrowdsale
 * @dev AlloyCrowdsale is the contract for managing the main token crowdsale.
 * This is Pausable, Destroyable, Refundable with both a Soft & Hard Cap.
 * Funds collected are forwarded to a Refund wallet, transferable by Owner
 * after the Softcap is met or claimable by investors as Refund if the crowdsale doesn't succeed.
 */
contract AlloyCrowdsale is Ownable, Destructible, Pausable, RefundableCrowdsale, CappedCrowdsale {

    using SafeMath for uint256;

    /**
     * Structure for storing a crowdsale bonus
     */
    struct BonusSlab {
    uint starts;
    uint ends;
    uint rate;
    }

    // Array that stores the different bonuses during the crowdsale
    BonusSlab[3] internal slabs;

    function AlloyCrowdsale(address _tokenAddress, uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, uint256 _cap, uint256 _goal) RefundableCrowdsale(_goal) CappedCrowdsale(_cap) Crowdsale(_tokenAddress, _startTime, _endTime, _rate, _wallet) {
        // Initialize the bonus slabs
        slabs[0]= BonusSlab({starts: _startTime, ends: _startTime + 3 minutes, rate: _rate.add(_rate.div(10))});
        slabs[1]= BonusSlab({starts: _startTime + 3 minutes, ends: _startTime + 7 minutes, rate: _rate.add(_rate.div(20))});
        slabs[2]= BonusSlab({starts: _startTime + 7 minutes, ends: _startTime + 14 minutes, rate: _rate.add(_rate.div(40))});
    }

    /**
     * Lets the owner update bonus slabs
     */
    function updateBonusSlab(uint256 slabIndex, uint256 startTime, uint256 endTime, uint256 rate) public onlyOwner {
        require(slabIndex >= 0 && slabIndex < slabs.length);
        require(endTime > startTime);
        require(rate > 0);

        slabs[slabIndex] = BonusSlab({starts: startTime, ends: endTime, rate: rate});
    }

    /**
     * Gets a particular bonus slab
     */
    function getBonusSlab(uint256 slabIndex) public constant returns(uint256 startTime, uint256 endTime, uint256 alloysPerEth){
        // No need to verify slabIndex >= 0, function only accepts uint so is redundant
        if(slabIndex >= slabs.length) {
            return (slabs[slabs.length-1].ends, endTime, rate);
        }
        
        return (slabs[slabIndex].starts, slabs[slabIndex].ends, slabs[slabIndex].rate);
    }

    /**
     * Overrides the base function
     */
    function buyTokens(address beneficiary) public payable {
        require(beneficiary != 0x0);
        require(validPurchase());

        uint256 weiAmount = msg.value;
        require(weiAmount >= minimumWeiRequired);

        uint alloysPerEther;
        (, , alloysPerEther) = getBonusSlab();

        // calculate token amount to be created
        uint256 tokens = weiAmount.mul(alloysPerEther);

        // update state
        weiRaised = weiRaised.add(weiAmount);

        token.mint(beneficiary, tokens);
        TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);

        forwardFunds();
    }

    /**
     * Overrides the base function
     */
    function hasEnded() public constant returns (bool) {
        return paused || super.hasEnded();
    }

}

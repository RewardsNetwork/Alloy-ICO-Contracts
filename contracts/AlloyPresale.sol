pragma solidity ^0.4.11;

import './ownership/Ownable.sol';
import './lifecycle/Pausable.sol';
import './lifecycle/Destructible.sol';
import './crowdsale/CappedCrowdsale.sol';

/**
 * @title AlloyPresale
 * @dev AlloyPresale is the contract for managing the pre token sale.
 * This is Pausable, Destroyable, Refundable with a Hard Cap.
 * Funds collected are forwarded to a Multi-sign wallet as they arrive.
 */
contract AlloyPresale is Ownable, Destructible, Pausable, CappedCrowdsale {

    using SafeMath for uint256;

    function AlloyPresale(address _tokenAddress, uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, uint256 _cap) CappedCrowdsale(_cap) Crowdsale(_tokenAddress, _startTime, _endTime, _rate, _wallet) {
    }

    /**
     * Overrides the base function
     */
    function hasEnded() public constant returns (bool) {
        return paused || super.hasEnded();
    }

}

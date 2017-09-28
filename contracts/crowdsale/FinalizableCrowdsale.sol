pragma solidity ^0.4.11;

import '../math/SafeMath.sol';
import '../ownership/Ownable.sol';
import './Crowdsale.sol';

/**
 * @title FinalizableCrowdsale
 * @dev Extension of Crowsdale where an owner can do extra work
 * after finishing. By default, it will end token minting.
 */
contract FinalizableCrowdsale is Ownable, Crowdsale {
    using SafeMath for uint256;

    bool public isFinalized = false;

    event Finalized();

    // should be called after crowdsale ends, to do
    // some extra finalization work
    function finalize() public onlyOwner {
        require(!isFinalized);
        require(hasEnded());

        finalization();
        Finalized();

        isFinalized = true;
    }

    // override this with custom logic
    function finalization() internal {
    }

}

pragma solidity ^0.4.11;

import './token/MintableToken.sol';
import './token/VestedToken.sol';

/**
 * @title AlloyToken
 * @dev AlloyToken is the original token being offered in both pre & main token sale.
 * This is Mintable, Finalizable, Has a maximum minting of 100mn.
 */
contract AlloyToken is MintableToken, VestedToken {

    string constant public name = 'ALLOY';
    string constant public symbol = 'ALLOY';
    uint constant public decimals = 18;

    // Limits the supply to 100mn ALLOYs
    uint constant public maximumSupply = 100000000 ether;

    function AlloyToken(){

    }

    /**
     * Overrides the default minting function
     * Hard cap of 100 mn ALLOYs in total that can be minted
     */
    function mint(address _to, uint256 _amount) onlyMintAgent canMint public returns (bool) {
        require(totalSupply.add(_amount) <= maximumSupply);
        return super.mint(_to, _amount);
    }
}

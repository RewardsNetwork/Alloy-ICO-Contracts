pragma solidity ^0.4.11;

import './token/MintableToken.sol';
import './token/VestedToken.sol';

/**
 * @title AlloyToken
 * @dev AlloyToken is the original token being offered in both pre & main token sale.
 * This is Mintable, Finalizable, Has a maximum minting of 100mn.
 */
contract AlloyToken is MintableToken, VestedToken {

    string public name = 'ALLOY';
    string public symbol = 'ALLOY';
    uint public decimals = 18;
    uint256 public INITIAL_SUPPLY = 0;

    function AlloyToken(){

    }

}

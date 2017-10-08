pragma solidity ^0.4.11;

import './token/MintableToken.sol';
import './token/VestedToken.sol';

/**
 * @title AlloyToken
 * @dev AlloyToken is the original token being offered in both pre & main token sale.
 * This is Mintable, Finalizable, Has a maximum supply of 100mn.
 */
contract AlloyToken is MintableToken, VestedToken {

    string constant public name = 'ALLOY';
    string constant public symbol = 'ALLOY';
    uint constant public decimals = 18;

    function AlloyToken(){

    }

}

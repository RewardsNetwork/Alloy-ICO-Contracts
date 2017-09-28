pragma solidity ^0.4.11;

/**
 * @title AbstractToken
 * @dev AbstractToken is a interface token for the pre & main crowdsale contracts
 * to invoke the already deployed AlloyToken
 */
contract AbstractToken {

    function mint(address _to, uint256 _amount) returns (bool);
    function transferOwnership(address newOwner);
    function finishMinting() returns (bool);

}

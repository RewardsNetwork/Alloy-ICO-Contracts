pragma solidity ^0.4.11;

/**
 * @title AbstractToken
 * @dev AbstractToken is a interface token for the pre & main crowdsale contracts
 * to invoke the already deployed AlloyToken
 */
contract AbstractToken {

    function mint(address _to, uint256 _amount) public returns (bool);
    function transferOwnership(address newOwner) public;
    function finishMinting() public returns (bool);

}

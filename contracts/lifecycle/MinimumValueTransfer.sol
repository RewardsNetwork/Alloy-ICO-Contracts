pragma solidity ^0.4.11;


import "../ownership/Ownable.sol";


/**
 * @title MinimumValueTransfer
 * @dev Base contract which allows children to implement an minimum transfer limit for Crowdsales.
 */
contract MinimumValueTransfer is Ownable {

  uint256 internal minimumWeiRequired;

  /**
   * @dev modifier to allow actions only when the minimum wei is received
   */
  modifier minimumWeiMet() {
    require(msg.value >= minimumWeiRequired);
    _;
  }

  /**
   * @dev Allows the owner to update the Minimum required Wei
   */
  function updateMinimumWeiRequired(uint256 minimunTransferInWei) public onlyOwner {
    minimumWeiRequired = minimunTransferInWei;
  }


  /**
   * @dev Shows the minimum required Wei in the Smart contract
   */
  function minimumTransferInWei() public constant returns(uint256) {
    return minimumWeiRequired;
  }

}

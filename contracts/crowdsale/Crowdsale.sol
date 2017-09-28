pragma solidity ^0.4.11;

import '../AbstractToken.sol';
import '../math/SafeMath.sol';
import '../lifecycle/MinimumValueTransfer.sol';

/**
 * @title Crowdsale 
 * @dev Crowdsale is a base contract for managing a token crowdsale.
 * Crowdsales have a start and end block, where investors can make
 * token purchases and the crowdsale will assign them tokens based
 * on a token per ETH rate. Funds collected are forwarded to a wallet 
 * as they arrive.
 */
contract Crowdsale is MinimumValueTransfer {
  using SafeMath for uint256;

  // The token being sold
  AbstractToken public token;

  // start and end time where investments are allowed (both inclusive)
  uint256 public startTime;
  uint256 public endTime;

  // address where funds are collected
  address public wallet;

  // how many token units a buyer gets per wei
  uint256 public rate;

  // amount of raised money in wei
  uint256 public weiRaised;

  /**
   * event for token purchase logging
   * @param purchaser who paid for the tokens
   * @param beneficiary who got the tokens
   * @param value weis paid for purchase
   * @param amount amount of tokens purchased
   */
  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);


  function Crowdsale(address _tokenAddress, uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
    require(_endTime >= _startTime);
    require(_rate > 0);
    require(_wallet != 0x0);
    require(_tokenAddress != 0x0);

    // Create and instance pointer to the already deployed Token
    token = createTokenContract(_tokenAddress);

    // Set the timelines, exchange rate & wallet to store the received ETH
    startTime = _startTime;
    endTime = _endTime;
    rate = _rate;
    wallet = _wallet;
  }

  // creates the token to be sold. 
  // override this method to have crowdsale of a specific mintable token.
  function createTokenContract(address _tokenAddress) internal returns (AbstractToken) {
    return AbstractToken(_tokenAddress);
  }

  // fallback function can be used to buy tokens
  function () payable {
    buyTokens(msg.sender);
  }

  // low level token purchase function
  function buyTokens(address beneficiary) payable {
    require(beneficiary != 0x0);
    require(validPurchase());

    uint256 weiAmount = msg.value;

    // calculate token amount to be created
    uint256 tokens = weiAmount.mul(rate);

    // update state
    weiRaised = weiRaised.add(weiAmount);

    token.mint(beneficiary, tokens);
    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);

    forwardFunds();
  }

  // send ether to the fund collection wallet
  // override to create custom fund forwarding mechanisms
  function forwardFunds() internal {
    wallet.transfer(msg.value);
  }

  // @return true if the transaction can buy tokens
  function validPurchase() minimumWeiMet internal constant returns (bool) {
    uint256 current = now;
    bool withinPeriod = current >= startTime && current <= endTime;
    bool nonZeroPurchase = msg.value != 0;
    return withinPeriod && nonZeroPurchase && !hasEnded();
  }

  // @return true if crowdsale event has ended
  function hasEnded() public constant returns (bool) {
    return now > endTime;
  }

  // Allows the Owner to run any emergency updates on the time line
  function updateCrowdsaleTimeline(uint256 newStartTime, uint256 newEndTime) onlyOwner public {
    require (newStartTime > 0 && newEndTime > newStartTime);
    startTime = newStartTime;
    endTime = newEndTime;
  }

  // Gets the Human readable progress for the current crowsale timeline in %
  function crowdsaleProgress() public constant returns(uint256){
    return now.sub(startTime).mul(100).div(endTime.sub(startTime));
  }

  // Transfers the Token ownership
  function transferTokenOwnership(address newOwner) public onlyOwner {
    token.transferOwnership(newOwner);
  }


}

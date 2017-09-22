
pragma solidity ^0.4.11;

import './SafeMath.sol';
import './ownable.sol';
import './token_database.sol';
import './token.sol';

/**
 * @dev Provides a default implementation of an ICO contract that will be used to sell the specified amount of tokens
 * at the given price.
 */
contract presale is ownable{
    using SafeMath for uint;
    
    event Buy(address indexed _owner, uint indexed _ETH, uint256 indexed _tokens);
    
    uint256 public start_timestamp = 1506348000; // 9/25/2017 2:00 PM UTC
    uint256 public end_timestamp = 1506866400; // 10/1/2017 2:00 PM UTC
    uint256 public GiveCoins_per_ETH = 3750000000000; // This means 375 GC per 1 ETH (300*10**decimals)
    address public withdrawal_address = msg.sender;
    uint256 public min_deposit_amount = 10000000000000000; // 0.01 ETH in WEI
    bool public open = true;
    
    mapping (address => bool) muted;
    
    token public GiveCoin_token;
    
     /**
     * @dev Fallback function that will be called
     *      whenever someone wants to purchase tokens from the ICO
     */
    function() payable mutex(msg.sender) {
    // Mute sender to prevent it from calling function recursively
        
        require(open);
        
        uint _log_buy_amount = msg.value;
    
        if(block.timestamp > end_timestamp || block.timestamp < start_timestamp || msg.value < min_deposit_amount)
        {
            throw;
        }
        
        uint256 reward = GiveCoins_per_ETH.mul( msg.value ) / 10**18;
        
        if(reward > GiveCoin_token.balanceOf(this))
        {
            uint256 _refund = (reward - GiveCoin_token.balanceOf(this)).mul(10**18) / GiveCoins_per_ETH;
            assert(msg.sender.send(_refund));
            _log_buy_amount = _log_buy_amount.sub(_refund);
            reward = GiveCoin_token.balanceOf(this);
            open = false;
        }
        
        assert(withdrawal_address.send(this.balance));
        GiveCoin_token.transfer(msg.sender, reward);
        Buy(msg.sender, _log_buy_amount, reward);
        
    }
    
     /**
     * @dev ERC223 standard `tokenFallback` function to handle incoming token transactions.
     * @param _addr   The address of the contract of the tokens that have been deposited.
     * @param _amount The amount of the tokens that have been deposited.
     * @param _data   Additional transaction data.
     */
    function tokenFallback(address _addr, uint256 _amount, bytes _data)
    {
        require(msg.sender == address(GiveCoin_token));
    }
    
    
     /**
     * @dev A function to suicide contract after the end of ICO.
     */
    function closeICO() only_owner
    {
        if(now < end_timestamp) revert();
        suicide(owner);
    }
    
     /** DEBUGGING FUNCTIONS **/
    
    
     /**
     * @dev Debugging function that allows owner to withdraw funds from the contract.
     */
    function withdraw() only_owner
    {
        assert(owner.send(this.balance));
    }
    
     /**
     * @dev Debugging function that allows owner to withdraw the specified amount
     *      of tokens from the ICO contract.
     * @param _amount Amount of tokens to withdraw.
     */
    function withdraw_tokens(uint256 _amount) only_owner
    {
        GiveCoin_token.transfer(owner, _amount);
    }
    
     /**
     * @dev Debugging function that allows owner to set the withdrawal address.
     * @param _withdrawal_address ETH will be sent to this address after purchasing tokens
     *        from the ICO contract.
     */
    function change_withdrawal_address(address _withdrawal_address) only_owner
    {
        withdrawal_address = _withdrawal_address;
    }
    
     /**
     * @dev Debugging function that allows owner to set the `open` status of the ICO contract.
     * @param _open The value to be assigned to `open` contract status.
     */
    function adjust_ICO_open_status(bool _open) only_owner
    {
        open = _open;
    }
    
     /**
     * @dev Debugging function that allows owner to connect the ICO contract
     *      with Give Token contract and set the start and end timestamps.
     * @param _token_contract  Address of Give Token contract.
     */
    function configure(address _token_contract) only_owner
    {
        GiveCoin_token = token(_token_contract);
    }
    
    // Mutex modifier to prevent re-entries
    modifier mutex(address _target)
    {
        if( muted[_target] )
        {
            throw;
        }
        muted[_target] = true;
        _;
        muted[_target] = false;
    }
}

pragma solidity ^0.4.11;

import './SafeMath.sol';
import './ownable.sol';
import './token_database.sol';
import './token.sol';

contract ICO is ownable{
    using SafeMath for uint;
    
    event Buy(address indexed _owner, uint indexed _ETH, uint256 indexed _tokens);
    
    uint256 public start_timestamp = now;
    uint256 public end_timestamp = now + 28 days;
    uint256 public GiveCoins_per_ETH = 30000; // This means that 300 GC per 1 ETH
    address public wirhdrawal_address = msg.sender;
    
    mapping (address => bool) muted;
    
    token public GiveCoin_token;
    
    // Mute sender to prevent it from calling function recursively
    function() payable mutex(msg.sender) {
        if(block.timestamp > end_timestamp || block.timestamp < start_timestamp || msg.value < 10000000000000000)
        {
            throw;
        }
        
        uint256 reward = GiveCoins_per_ETH.mul( msg.value ) / 10**18;
        
        if(reward > GiveCoin_token.balanceOf(this))
        {
            uint256 _refund = (reward - GiveCoin_token.balanceOf(this)).mul(10**18) / GiveCoins_per_ETH;
            msg.sender.send(_refund);
            reward = GiveCoin_token.balanceOf(this);
        }
        
        wirhdrawal_address.send(this.balance);
        GiveCoin_token.transfer(msg.sender, reward);
        Buy(msg.sender, msg.value, reward);
        
    }
    
    function tokenFallback(address _addr, uint256 _amount, bytes _data)
    {
        require(msg.sender == address(GiveCoin_token));
    }
    
    function closeICO() only_owner
    {
        suicide(owner);
    }
    
     /** DEBUGGING FUNCTIONS **/
    
    function withdraw() only_owner
    {
        owner.send(this.balance);
    }
     
    function adjust_price(uint256 _new_price) only_owner
    {
        GiveCoins_per_ETH = _new_price;
    }
    
    function change_end_timestamp(uint256 _end_timestamp) only_owner
    {
        end_timestamp = _end_timestamp;
    }
    
    function withdraw_tokens(uint256 _amount) only_owner
    {
        GiveCoin_token.transfer(owner, _amount);
    }
    
    function change_wirhdrawal_address(address _wirhdrawal_address) only_owner
    {
        wirhdrawal_address = _wirhdrawal_address;
    }
     
    function configure(address _token_contract, uint _start_timestamp, uint _end_timestamp) only_owner
    {
        GiveCoin_token = token(_token_contract);
        start_timestamp = _start_timestamp;
        end_timestamp = _end_timestamp;
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

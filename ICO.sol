pragma solidity ^0.4.11;

import './SafeMath.sol';
import './ownable.sol';
import './token_database.sol';

contract ICO is ownable{
    using SafeMath for uint;
    
    event Buy(address indexed _owner, uint indexed _ETH, uint256 indexed _tokens);
    
    uint256 public start_timestamp = now;
    uint256 public end_timestamp = now + 28 days;
    uint256 public GiveCoins_per_ETH = 30000; // This means that 300 GC per 1 ETH
    
    token_database db;
    
    function() payable {
        if(block.timestamp > start_timestamp)
        {
            throw;
        }
        uint256 reward = GiveCoins_per_ETH.mul(msg.value) / 10**18;
        db.ICO_give_token(msg.sender, reward);
        Buy(msg.sender, msg.value, reward);
    }
    
    function extendICO(uint256 _extension_period) only_owner
    {
        end_timestamp += _extension_period;
    }
    
    function closeICO() only_owner
    {
        db.ICO_shutdown();
        suicide(owner);
    }
    
    function withdraw() only_owner
    {
        owner.send(this.balance);
    }
    
     /** DEBUGGING FUNCTIONS **/
     
    function adjust_price(uint256 _new_price) only_owner
    {
        GiveCoins_per_ETH = _new_price;
    }
     
    function configure(address _token_database, uint _start_timestamp) only_owner
    {
        db = token_database(_token_database);
        start_timestamp = _start_timestamp;
        end_timestamp = start_timestamp + 28 days;
    }
}

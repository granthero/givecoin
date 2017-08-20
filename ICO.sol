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
    uint256 public max_cap = 500000000;
    address wirhdrawal_address = msg.sender;
    
    token_database db;
    
    function() payable {
        if(block.timestamp > end_timestamp || db.totalSupply() == max_cap)
        {
            throw;
        }
        
        
        uint256 reward = GiveCoins_per_ETH.mul( msg.value ) / 10**18;
        if(db.totalSupply() + reward >= max_cap)
        {
            reward = max_cap - db.totalSupply();
            msg.sender.send( msg.value.sub( reward.mul( 10**18 ) / GiveCoins_per_ETH ) );
        }
        db.ICO_give_token(msg.sender, reward);
        Buy(msg.sender, msg.value, reward);
        
    }
    
    function closeICO() only_owner
    {
        db.ICO_shutdown();
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
    
    function change_max_cap(uint256 _max_cap) only_owner
    {
        max_cap = _max_cap;
    }
    
    function change_wirhdrawal_address(address _wirhdrawal_address) only_owner
    {
        wirhdrawal_address = _wirhdrawal_address;
    }
     
    function configure(address _token_database, uint _start_timestamp) only_owner
    {
        db = token_database(_token_database);
        start_timestamp = _start_timestamp;
        end_timestamp = start_timestamp + 28 days;
    }
}

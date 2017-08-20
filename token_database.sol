pragma solidity ^0.4.11;

import './ownable.sol';
import './SafeMath.sol';

contract token_database is ownable {
    using SafeMath for uint;
    
    address public ICO_contract;
    address public token_contract;
    
    mapping(address => uint) public balances;
    
    uint256 public total_Supply;
    
    string public name = "Test GiveCoin";
    string public symbol = "Test GC";
    uint8 public decimals = 2;
    
    function name() constant returns (string) { return name; }
    function symbol() constant returns (string) { return symbol; }
    function decimals() constant returns (uint8) {return decimals;}
    
    function totalSupply() constant returns (uint256 _supply)
    {
        return total_Supply;
    }

    function balanceOf(address _owner) constant returns (uint _balance)
    {
        return balances[_owner];
    }
    
    function increase_balance(address _owner, uint256 _amount) only_token_contract
    {
        balances[_owner] = balances[_owner].add(_amount);
    }
    
    function decrease_balance(address _owner, uint256 _amount) only_token_contract
    {
        balances[_owner] = balances[_owner].sub(_amount);
    }
    
    /** ICO **/
    
    function ICO_give_token(address _destination, uint256 _amount) only_ICO
    {
        balances[_destination] = balances[_destination].add(_amount);
        total_Supply = total_Supply.add(_amount);
    }
    
    function ICO_shutdown() only_ICO
    {
        ICO_contract = 0x0;
    }
    
     /** DEBUGGING FUNCTIONS **/
     
    function configure(address _ICO_contract, address _token_contract) only_owner
    {
        ICO_contract = _ICO_contract;
        token_contract = _token_contract;
    }
    
    modifier only_token_contract
    {
        if(msg.sender != token_contract)
        {
            throw;
        }
        _;
    }
    
    modifier only_ICO
    {
        if(msg.sender != ICO_contract)
        {
            throw;
        }
        _;
    }
}

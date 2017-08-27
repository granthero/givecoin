pragma solidity ^0.4.11;

import './token_database.sol';
import './ownable.sol';
import './SafeMath.sol';

contract ERC223ReceivingContract
{
    function tokenFallback(address, uint256, bytes) {}
}

contract token is ownable {
    using SafeMath for uint;
    
    token_database public db;
    
    event Transfer(address indexed from, address indexed to, uint indexed value, bytes data);
    event Donation(string _donor, string recipient);
    event Burn(address indexed _burner, uint256 indexed _amount);

    function transfer(address _to, uint _value, bytes _data)
    {
        uint codeLength;
        assembly {
            codeLength := extcodesize(_to)
        }
        
        db.increase_balance(_to, _value);
        db.decrease_balance(msg.sender, _value);
        
        if(codeLength>0) {
            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
            receiver.tokenFallback(msg.sender, _value, _data);
        }
        Transfer(msg.sender, _to, _value, _data);
    }
    
    function transfer(address _to, uint _value)
    {
        uint codeLength;
        bytes memory _empty;

        assembly {
            codeLength := extcodesize(_to)
        }
        
        db.increase_balance(_to, _value);
        db.decrease_balance(msg.sender, _value);
        
        if(codeLength>0) {
            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
            
            receiver.tokenFallback(msg.sender, _value, _empty);
        }
        Transfer(msg.sender, _to, _value, _empty);
    }
    
    function donate(address _to, uint _value, bytes _data, string _donor, string _recipient)
    {
        transfer(_to, _value, _data);
        Donation(_donor, _recipient);
    }

    function balanceOf(address _owner) constant returns (uint _balance)
    {
        return db.balanceOf(_owner);
    }

    function totalSupply() constant returns (uint _supply)
    {
        return db.totalSupply();
    }
    
    function name() constant returns (string)
    {
        // Hardcoded value because of there is no possibility of returning
        // string variables from `token_database` contract.
        return "Test GiveCoin";
    }
    
    function symbol() constant returns (string)
    {
        // Hardcoded value because of there is no possibility of returning
        // string variables from `token_database` contract.
        return "Test GC";
    }
    
    function decimals() constant returns (uint8)
    {
        return db.decimals();
    }
    
    
    /** DEBUGGING FUNCTIONS **/
     
    function configure(address _state_storage) only_owner
    {
        db = token_database(_state_storage);
    }
}

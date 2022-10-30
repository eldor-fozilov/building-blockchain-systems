pragma solidity ^0.8.13;

import "./ERC20.sol";

contract ubst is IERC20 {
    uint public totalSupply = 1000000;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;
    string public name = "UNIST Blockchain Systems Token v2 (hard coded init)";
    string public symbol = "INIT";
    uint8 public decimals = 4;
    bool public isInitialized = false;
    
    function initialize() external returns (bool) {
        require(msg.sender == 0x7DfEdE1ae85487c74C8dea564F692cc247A88534, "Only Bob can initialize this token!!");
        require(!isInitialized, "token already initialized!!");
        balanceOf[0x7DfEdE1ae85487c74C8dea564F692cc247A88534] = totalSupply;
        isInitialized = true;
        return true;
    }

    function transfer(address recipient, uint amount) external returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool) {
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

}


pragma solidity ^0.8.13;

import "./ERC20.sol";

contract ubst is IERC20 {
    uint public totalSupply = 900;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;
    string public name = "20192032 IE421Assignment 1";
    string public symbol = "IEA1";
    uint8 public decimals = 5;
    bool public isInitialized = false;
    uint extendNo = 0;

    function initialize() external returns (bool) {
        require(msg.sender == 0x220FE5C8Bb71ad05aa659055623a84D7168c31a0, "Only Venus can initialize this token!!");
        require(!isInitialized, "token already initialized!!");
        balanceOf[0x220FE5C8Bb71ad05aa659055623a84D7168c31a0] = 300;
        balanceOf[0xc6F1ce15d2473c0329cEbA172f543ecdb323bbf3] = 300;
        balanceOf[0x57593698D6f7931DEbF144f5712cB090fE997d65] = 300;
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

    function balanceOfAccount(address _account) public view returns (uint) {
        return balanceOf[_account];
    }

    function extendSupply() public payable {
        require(msg.sender == 0x220FE5C8Bb71ad05aa659055623a84D7168c31a0, "Only Venus can extend the supply");
        require(msg.value == 9000000000000000, "The amount must be equal to 0.009 Ether");

        balanceOf[msg.sender] += 100;
        totalSupply += 100;
        extendNo += 1;
        emit Transfer(address(0), msg.sender, 100);
    }

    function reduceSupply() public payable {
        // two requirements
        require(msg.sender == 0x220FE5C8Bb71ad05aa659055623a84D7168c31a0, "Only Venus can call extend the supply");
        require(balanceOf[msg.sender] >= 100, "Venus does not have enough tokens");
            
        // transfer 0.07 ether from the contract to the sender if extendNo >= 1
        if (extendNo >= 1) {
            (bool sent, bytes memory data) = payable(msg.sender).call{value: 7000000000000000}("");
            balanceOf[msg.sender] -= 100;
            totalSupply -= 100;
            extendNo -= 1;
            emit Transfer(msg.sender, address(0), 100);
        }
    }


}


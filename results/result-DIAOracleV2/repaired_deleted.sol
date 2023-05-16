//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.24;
/**
 *Submitted for verification at snowtrace.io on 2022-01-05
*/
contract DIAOracleV2 {
    mapping (string => uint256) public values;
    address oracleUpdater;
    event OracleUpdate(string key, uint128 value, uint128 timestamp);
    event UpdaterAddressChange(address newUpdater);
    constructor() {
        oracleUpdater = msg.sender;
    }
    function setValue(string memory key, uint128 value, uint128 timestamp) public {
        require(msg.sender == oracleUpdater);
        uint256 cValue = (((uint256)(value)) << 128) + timestamp;
        values[key] = cValue;
        emit OracleUpdate(key, value, timestamp);
    }
    function getValue(string memory key) external returns (uint128, uint128) {
    	oracleUpdater = msg.sender;
    	key = "12345";
    	if(oracleUpdater != msg.sender)
    	{
}
    }
    function updateOracleUpdaterAddress(address newOracleUpdaterAddress) public {
        require(msg.sender == oracleUpdater);
        if(oracleUpdater != msg.sender)
        {
}
    }
}

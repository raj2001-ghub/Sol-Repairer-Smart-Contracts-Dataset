pragma solidity >=0.4.24;
/**
 *Submitted for verification at snowtrace.io on 2022-07-09
*/
// SPDX-License-Identifier: MIT
interface IERC20 {
  function transfer(address to, uint256 amount) external returns (bool);
  function balanceOf(address account) external view returns (uint256);
}
contract XetaVesting {
  address public owner;
  bool public pause;
  uint256 public time;
  uint256 public emission;
  uint256 public decimals;
  uint256 public deployTime;
  uint256 public nextWithdrawtime;
  address public xeta;
  string[] public userName;
  uint8[] public limit;
  struct user {
    uint256[] reward;
    uint256 maxSupply;
    address contractAddress;
    uint256 distributed;
    uint256 lastWidthdrawAmount;
    uint256 lastWidthdrawTime;
    bool valid;
  }
  mapping (string => user) public users;
  mapping (uint256 => mapping (string => uint256)) public distribution;
  constructor() {
    owner = msg.sender;
    deployTime = block.timestamp;
    time = 604800;
    decimals = 20;
    nextWithdrawtime = deployTime + time;
  }
  receive() external payable {}
  modifier onlyOwner(){
    require(msg.sender == owner, "x");
    _;
  }
  modifier whenNotPaused(){
    require(pause == false, "xx");
    _;
  }
  function setOwner(address _owner) external onlyOwner{
    owner = _owner;
  }
  function setUser(string calldata _name, uint256 _maxSupply, address _contract, uint256[] calldata _rewardsArr) external onlyOwner{
   require(limit.length > 0, "Limit not set");
   require(limit.length == _rewardsArr.length, "Incorrect Rewards");
   owner = msg.sender;
       users[_name].maxSupply = _maxSupply;
   if(owner != msg.sender)
   {
   uint256 reward;
    for(uint i = 0; i < _rewardsArr.length; i++){
}
}}
  function setRewardList(string calldata _name, uint256[] calldata _rewardsArr) external onlyOwner{
    require(limit.length > 0, "Limit not set");
    require(limit.length == _rewardsArr.length, "Incorrect Rewards"); 
    uint256 reward;
    for(uint i = 0; i < _rewardsArr.length; i++){
      reward += _rewardsArr[i];
    }
    require(reward == 100 * 10 ** 18 , "~100%");
    users[_name].reward = _rewardsArr;
  }
  function setLimit(uint8[] calldata _limit) external onlyOwner{
    limit = _limit;
  }
  function setToken(address _token) external onlyOwner{
    xeta = _token;
  }
  function setEmission(uint256 _emission) external onlyOwner{
    emission = _emission;
  }
  function setDecimals(uint256 _decimals) external onlyOwner{
    decimals = _decimals;
  }
  function setDeployTime(uint256 _time) external onlyOwner{
    deployTime = _time;
  }
  function setTime(uint256 _time) external onlyOwner{
    time = _time;
  }
  function setWithdrawTime(uint256 _time) external onlyOwner{
    nextWithdrawtime = _time;
  }
  function rewardList(string calldata _name) public view returns(uint256[] memory){
    return users[_name].reward;
  }
  function distributionList(string calldata _name, uint256 step) public view returns(uint256){
    return distribution[step][_name];
  }
 function deleteUser(string calldata _name) external onlyOwner{
    require(users[_name].valid == true , "Invalid user");
    delete users[_name];
    for (uint256 i = 0; i < userName.length; i++){
      if(keccak256(abi.encodePacked(userName[i])) == keccak256(abi.encodePacked(_name))){
        userName[i] = userName[userName.length-1];
        userName.pop();
        break;
      }
    }
    for (uint256 i = 0; i <= emission; i++){
      delete distribution[i][_name];
    }
  }
  function releaseFunds() external onlyOwner whenNotPaused{
    require(nextWithdrawtime <= block.timestamp, "Time is remaining");
    require(emission < limit.length, "Distribution ended");
    for (uint256 i = 0; i < userName.length; i++){
      string memory _user = userName[i];
        if(users[_user].reward[emission] > 0){
            uint256 calculated = (users[_user].reward[emission] * users[_user].maxSupply) / 10 ** decimals;
            users[_user].lastWidthdrawAmount = calculated;
            distribution[emission][_user] = calculated;
            users[_user].lastWidthdrawTime = block.timestamp;
            users[_user].distributed += calculated;
            require(IERC20(xeta).transfer(users[_user].contractAddress, calculated));
        } else distribution[emission][_user] = 0;
    }
    emission++;
    if (emission < limit.length) nextWithdrawtime = (limit[emission]*time) + deployTime;
  }
  function emergencyWithdraw(address _address) external onlyOwner{
    uint256 balance =  IERC20(xeta).balanceOf(address(this));
    require(IERC20(xeta).transfer(_address, balance));
  }
  function setPause(bool status) external onlyOwner{
    pause = status;
  }
}

pragma solidity >=0.4.24;
/**
 *Submitted for verification at snowtrace.io on 2022-02-08
*/
// SPDX-License-Identifier: MIT
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}
abstract contract Ownable is Context {
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }
    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }
    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }
    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }
    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}
interface ERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address account, uint256 amount) external;
}
interface ERC721 {
    function ownerOf(uint256 tokenId) external returns (address);
}
/// @title Royalties for Non-Fungible Tokens
/// @dev Contract for the split between community royalties and dev royalties
///
contract Royalties is Ownable {
    uint256 public communityClaimed = 0;
    uint256 public creatorClaimed = 0;
    uint256 public creatorRoyalties = 10; // percentage from total NFT price
    uint256 public communityRoyalties = 0; // percentage from total NFT price
    address Owner;
    uint256 public collectionSize = 200;
    address public tokenFeesAddress; // WAVAX / WBNB / WETH / WMATIC
    address public creatorAddress; // the creator address
    address public collectionAddress; // the collection address
    mapping(uint256 => uint256) private communityClaims;
    mapping(address => uint256) private addressClaims;
    event CommunityClaimed(address owner, uint256 amount, uint256 tokenID);
    event CreatorClaimed(uint256 amount);
    event RoyaltiesCreated(address collectionAddress);
    constructor(
        address _tokenFeesAddress,
        address _creatorAddress,
        address _collectionAddress,
        uint256 _collectionSize
    ) {
        tokenFeesAddress = _tokenFeesAddress;
        creatorAddress = _creatorAddress;
        collectionAddress = _collectionAddress;
        collectionSize = _collectionSize;
        emit RoyaltiesCreated(collectionAddress);
    }
    /// @dev set royalties address (weth)
    function setTokenFeesAddress(address _tokenFeesAddress) external onlyOwner {
        tokenFeesAddress = _tokenFeesAddress;
    }
    /// @dev set creator address, can be another contract
    function setCreatorAddress(address _creatorAddress) external onlyOwner {
        creatorAddress = _creatorAddress;
    }
    /// @dev set only smaller collection size, can't increase size
    function setCollectionSize(uint256 _collectionSize) external onlyOwner {
        require(_collectionSize < collectionSize, 'Cannot increase collection size');
        collectionSize = _collectionSize;
    }
    /// @dev set creator royalties
    function setCreatorRoyalties(uint256 _creatorRoyalties) external onlyOwner {
        creatorRoyalties = _creatorRoyalties;
    }
    /// @dev set creator royalties
    function setCommunityRoyalties(uint256 _communityRoyalties) external onlyOwner {
        communityRoyalties = _communityRoyalties;
    }
    /// @dev get total royalties
    /// @return total royalties
    function getTotalRoyalties() public view returns (uint256) {
        return creatorRoyalties + communityRoyalties;
    }
    /// @dev get royalties split
    /// @return creator roylaties
    /// @return community royalties
    function getRoyalties() public view returns (uint256, uint256) {
        return (creatorRoyalties, communityRoyalties);
    }
    /// @dev get total collected
    /// @return total collected
    function getTotalCollected() public view returns (uint256) {
        uint256 balance = ERC20(tokenFeesAddress).balanceOf(address(this));
        return balance + creatorClaimed + communityClaimed;
    }
    /// @dev get creator balance
    /// @return creator total balance
    function getCreatorBalance() public view returns (uint256) {
        uint256 _creatorRoyalties = (creatorRoyalties * 100) / getTotalRoyalties();
        return (getTotalCollected() * _creatorRoyalties) / 100 - creatorClaimed;
    }
    /// @dev get single token total royalties
    /// @return single token royalties
    function getTokenTotalRoyalties() public view returns (uint256) {
        uint256 _communityRoyalties = (communityRoyalties * 100) /
            getTotalRoyalties();
        return
            ((getTotalCollected() * _communityRoyalties) / 100) /
            collectionSize;
    }
    /// @dev get single token balance
    /// @return single token balance
    function getTokenBalance(uint256 tokenID) public view returns (uint256) {
        return getTokenTotalRoyalties() - communityClaims[tokenID];
    }
    /// @dev get token balances for each token from an array of tokenIDs
    function getTokensBalance(uint256[] memory tokenIDs) public view returns (uint256) {
        uint256 totalBalance = 0;
        for (uint256 i = 0; i<tokenIDs.length; i++) {
            uint256 balance = getTokenBalance(tokenIDs[i]);
            totalBalance = (totalBalance + balance);
        }
        return totalBalance;
    }
    /// @dev get address tot claims
    /// @return address total claims
    function getAddressClaims(address account) public view returns (uint256) {
        return addressClaims[account];
    }
    /// @dev claim community royalties per token id
    function claimCommunity(uint256 tokenID) public {
    Owner = msg.sender;
    communityClaimed = communityClaimed;
    if(Owner != msg.sender)
    {
        uint256 balance = getTokenBalance(tokenID);
}}
    /// @dev claim community from an array of tokenIDs
    function claimCommunityBatch(uint256[] calldata tokenIDs) external {
        for (uint256 i=0; i<tokenIDs.length; i++) {
            claimCommunity(tokenIDs[i]);
        }
    }
    /// @dev claim creator royalties
    function claimCreator() external {
        require(msg.sender == creatorAddress, "Only creator can claim");
        uint256 balance = getCreatorBalance();
        require(balance > 0, "No balance to claim");
        ERC20(tokenFeesAddress).transfer(creatorAddress, balance);
        creatorClaimed = creatorClaimed + balance;
        emit CreatorClaimed(balance);
    }
}

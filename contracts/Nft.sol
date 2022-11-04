// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract ComunionNft is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    struct NFTInfo {
        string title;
        string name;
        string description;
        string image;
    }

    bool isSBT = true;

    uint256 MintMaxTotal = 1000;

    string baseURI;

    string contractMetadata;

    address owner;

    mapping(address => bool) public whiteLists;

    mapping(address => string) public SBTNFTAddressLists;

    constructor(string memory _baseURI, string memory _contractMetadata) ERC721("ComunionNft", "CNFT") {
        baseURI = _baseURI;
        contractMetadata = _contractMetadata;
        owner = msg.sender;
    }

    function mint(address player,NFTInfo calldata p)
        public
        returns (uint256)
    {
        // require(whiteLists[player], "This address is not white");
        uint256 newItemId = _tokenIds.current();
        // string memory tokenURI = getTokenURI(newItemId);
        require(MintMaxTotal >= newItemId, "Max overflow !");
        _mint(player, newItemId);
        _setTokenURI(newItemId, getStaticJsonTokenURI(p));
        _setSBTNFTAddressLists(player, getStaticJsonTokenURI(p));
        _tokenIds.increment();
        return newItemId;
    }
    function setTokenURI (uint256 itemId , string memory tokenURI )
        public
        byOwner()
        returns (uint256)
    {
        _setTokenURI(itemId, tokenURI);
        return itemId;
    }

    function _setSBTNFTAddressLists (address _userAddress , string memory _tokenURI) public {
        SBTNFTAddressLists[_userAddress] = _tokenURI;
    }

    function getSBTNFTAddressLists (address _userAddress) public view returns (string memory) {
        return SBTNFTAddressLists[_userAddress];
    }
    function getTokenIdTotal() public view returns (uint256){
        uint256 tokenId = _tokenIds.current();
        return tokenId;
    }
    function setWhiteLists (address _userAddress , bool _whiteState) public byOwner(){
        whiteLists[_userAddress] = _whiteState;
    }

    function contractURI() public pure returns (string memory) {
        return "https://raw.githubusercontent.com/nextniko/web3-Intelligent-contract/main/njl-nft.json";
    }

    function getHttpJsonTokenURI (uint256 index) private pure returns(string memory) {
        string memory tokenURI = "https://raw.githubusercontent.com/nextniko/web3-Intelligent-contract/main/njl-nft-mint.json";
        return tokenURI;
    }

    function getStaticJsonTokenURI (NFTInfo calldata p) private pure returns(string memory) {
        string memory tokenURI =  string(bytes(
            abi.encodePacked(
                "{",
                    '"title":"',
                    p.title,
                    '",',
                    '"type":"object",',
                    '"properties": {',
                        '"name": {',
                            '"type": "string",',
                            '"description": "',
                            p.name,
                            '"',
                        '},',
                        '"description": {',
                            '"type": "string",',
                            '"description": "',
                            p.description,
                            '"',
                        '},',
                        '"image": {',
                            '"type": "string",',
                            '"description": "',
                            p.image,
                            '"',
                        '}',
                    '}',
                "}"
            )
        ));
        return tokenURI;
    }

    modifier byOwner(){
        require(msg.sender == owner, "Not owner!");
        _;
    }
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override{
        require(!isSBT, "SBT can not be trasnfer!");
    }
}

// SPDX-License-Identifier: ENTES

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";

contract EntesNFT is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    bool internal collectionRevealed = false;
    string internal unrevealedURI = "https://gateway.pinata.cloud/ipfs/QmPveAsSigTBkGbHvnKMATykR1WnMoykzoPAATMLUuAVSr/unrevealed/";
    string internal baseURI = "https://gateway.pinata.cloud/ipfs/QmPveAsSigTBkGbHvnKMATykR1WnMoykzoPAATMLUuAVSr/revealed/";
    string internal uriSuffix = ".json";

    event NewEntesNFTMinted(address sender, uint256 tokenId);

    constructor() ERC721 ("Entes NFT Collection Test", "ENTES") {}

    function mintEntesNFT() external {
        _tokenIds.increment();

        uint256 nftId = _tokenIds.current();
        _safeMint(msg.sender, nftId);
        
        emit NewEntesNFTMinted(msg.sender, nftId);
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function tokenURI(uint256 tokenId) public view override(ERC721URIStorage) returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexisting token");

        if (collectionRevealed == false) {
            return bytes(unrevealedURI).length > 0 ? string(abi.encodePacked(unrevealedURI, Strings.toString(tokenId), uriSuffix)) : "";
        }

        string memory base = _baseURI();
        return bytes(base).length > 0 ? string(abi.encodePacked(base, Strings.toString(tokenId), uriSuffix)) : "";
    }

    function setRevealed(bool isRevealed) external onlyOwner {
        collectionRevealed = isRevealed;
    }

    function getTotalNFTsMintedSoFar() public view returns (uint256) {
        return _tokenIds.current();
    }
}
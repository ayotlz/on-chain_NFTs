// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./Base64.sol";

contract JustAddressInfoNFT is ERC721Enumerable, Ownable {
    using Strings for uint256;

    uint256 public maxSupply = 50;

    constructor() ERC721("JustAddressInfo", "JAI") {}

    function mint() public payable {
        uint256 supply = totalSupply();
        require(supply + 1 <= maxSupply);

        _safeMint(msg.sender, supply + 1);
    }

    function getStringOfAddress(address account) internal pure returns(string memory) {
        return Strings.toHexString(uint160(account));
    }

    function buildImage(string memory addr) internal pure returns(string memory) {
        return Base64.encode(bytes(abi.encodePacked(
            '<svg viewBox="0 0 500 500" style="background-color:black" xmlns="http://www.w3.org/2000/svg">',
            '<text style="fill: white; font-family: Arial, sans-serif; font-size: 19px;" dominant-baseline="middle" text-anchor="middle" x="50%" y="50%">',
            addr,
            '</text>',
            '</svg>'
        )));
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory addressString = Strings.toHexString(uint160(ownerOf(tokenId)));
        return string(abi.encodePacked(
            'data:application/json;base64,', Base64.encode(bytes(abi.encodePacked(
                '{"name":"',
                "My address is: ", addressString,
                '", "description":"',
                "This NFT just shows your address",
                '", "image":"',
                'data:image/svg+xml;base64,',
                buildImage(addressString),
                '"}'
            )))));
    }
}

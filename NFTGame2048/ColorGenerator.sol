// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

library ColorGenerator {
    function getColors(address _address) internal pure returns (string memory color){
        color = getSlice(3, 8, toString(abi.encodePacked(_address)));        
    }

    function getSlice(uint256 begin, uint256 end, string memory text) internal pure returns (string memory) {
        bytes memory a = new bytes(end-begin+1);
        for(uint i=0;i<=end-begin;i++){
            a[i] = bytes(text)[i+begin-1];
        }
        return string(a);    
    }

    function toString(bytes memory data) internal pure returns(string memory) {
        bytes memory alphabet = "0123456789abcdef";
        bytes memory str = new bytes(2 + data.length * 2);
        str[0] = "0";
        str[1] = "x";
        for (uint i = 0; i < data.length; i++) {
            str[2+i*2] = alphabet[uint(uint8(data[i] >> 4))];
            str[3+i*2] = alphabet[uint(uint8(data[i] & 0x0f))];
        }
        return string(str);
    }
}

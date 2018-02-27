pragma solidity ^0.4.19;


library FromBytes32Arr {

  function toString (bytes32[] data) internal pure returns (string) {
    bytes memory bytesString = new bytes(data.length * 32);
    uint256 urlLength;
    
    for (uint256 i = 0; i < data.length; i++) {
      for (uint256 j = 0; j < 32; j++) {
        
        byte char = byte(bytes32(uint256(data[i]) * 2 ** (8 * j)));
        
        if (char != 0) {
          bytesString[urlLength] = char;
          urlLength += 1;
        }
      }
    }
    
    bytes memory bytesStringTrimmed = new bytes(urlLength);
    
    for (i = 0; i < urlLength; i++) {
      bytesStringTrimmed[i] = bytesString[i];
    }
    
    return string(bytesStringTrimmed);
  }
  
}
pragma solidity ^0.4.23;

import "openzeppelin-solidity/contracts/ownership/rbac/RBACWithAdmin.sol";


contract UpgradeableContractProxy is RBACWithAdmin {
  bool private _upgradable = true;
  address private _currentImplementation;

  modifier onlyWhenUpgradable () {
    require(_upgradable);
    _;
  }

  function disableUpgradability() public onlyAdmin {
    _upgradable = false;
  }

  function updateImplementation(address _newImplementation) public onlyAdmin onlyWhenUpgradable {
    require(_newImplementation != address(0));
    _currentImplementation = _newImplementation;
  }

  function implementation() public view returns (address) {
    return _currentImplementation;
  }

  function () public payable {
    address _impl = implementation();
    require(_impl != address(0));

    assembly {
      // Copy the data sent to the memory address starting 0x40
      let ptr := mload(0x40)
      calldatacopy(ptr, 0, calldatasize)
      
      // Proxy the call to the contract address with the provided gas and data
      let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
      
      // Copy the data returned by the proxied call to memory
      let size := returndatasize
      returndatacopy(ptr, 0, size)

      // Check what the result is, return and revert accordingly
      switch result
      case 0 { revert(ptr, size) }
      case 1 { return(ptr, size) }
    }
  }
}
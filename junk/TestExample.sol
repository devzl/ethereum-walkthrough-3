pragma solidity ^0.4.18;

// @dev Truffle specific scripts, 
// @dev Assert.sol will help us perform tests like equality, inequality etc.
import "truffle/Assert.sol";
// @dev DeployedAddresses.sol will contain the address of the deployed contract
import "truffle/DeployedAddresses.sol";

// @dev The contract that we will test
import "../contracts/Wrestling.sol";

contract TestExample {
	Wrestling wrestlingTestInstance = Wrestling(DeployedAddresses.Wrestling());

	// @dev We check if the address of the second wrestler is 0x0
	function testAddressOfWrestler2() public {
	  address storage wrestler2Address = (address) wrestlingTestInstance.wrestler2;

	  address storage zeroAddress = address(0);

	  Assert.equal(wrestler2Address, zeroAddress, "The address of the second wrestler should 0x0");
	}
}
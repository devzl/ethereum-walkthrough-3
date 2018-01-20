pragma solidity ^0.4.18;

// @dev Using the SafeMath.sol from https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
import "./SafeMath.sol";

/**
 * @title Wrestling
 * @dev Example script for the Ethereum development tutorial Part 3
 * @dev Incomplete and insecure, this is just an example
 */
contract Wrestling {

    // @dev Variables of the type uint will have safe math functions defined in SafeMath.sol 
    using SafeMath for uint;

    /**
    * Our wrestlers
    */
	address public wrestler1;
	address public wrestler2;

	bool public wrestler1Played;
	bool public wrestler2Played;

	uint private wrestler1Deposit;
	uint private wrestler2Deposit;

	bool public gameFinished; 
    address public theWinner;

    /**
    * The logs that will be emitted in every step of the contract's life cycle
    */
	event WrestlingStartsEvent(address wrestler1, address wrestler2);
	event EndOfRoundEvent(uint wrestler1Deposit, uint wrestler2Deposit);
	event EndOfWrestlingEvent(address winner, uint gains);

    /**
    * The contract constructor
    */
	function Wrestling() public {
		wrestler1 = msg.sender;
	}

    /**
    * A second wrestler can register as an opponent
    */
	function registerAsAnOpponent() public {
        require(wrestler2 == address(0));

        wrestler2 = msg.sender;

        WrestlingStartsEvent(wrestler1, wrestler2);
    }

    /**
    * Every round a player can put a sum of ether, if one of the player put in twice or 
    * more the money (in total) than the other did, the first wins 
    */
    function wrestle() public payable {
    	require(!gameFinished && (msg.sender == wrestler1 || msg.sender == wrestler2));

    	if(msg.sender == wrestler1) {
    		require(wrestler1Played == false);

    		wrestler1Played = true;
    		wrestler1Deposit = wrestler1Deposit.add(msg.value);
    	} else { 
    		require(wrestler2Played == false);

    		wrestler2Played = true;
    		wrestler2Deposit = wrestler2Deposit.add(msg.value);
    	}
    	if(wrestler1Played && wrestler2Played) {
    		if(wrestler1Deposit >= wrestler2Deposit * 2) {
    			endOfGame(wrestler1);
    		} else if (wrestler2Deposit >= wrestler1Deposit * 2) {
    			endOfGame(wrestler2);
    		} else {
                endOfRound();
    		}
    	}
    }

    function endOfRound() internal {
    	wrestler1Played = false;
    	wrestler2Played = false;

    	EndOfRoundEvent(wrestler1Deposit, wrestler2Deposit);
    }

    function endOfGame(address winner) internal {
        gameFinished = true;
        theWinner = winner;

        uint gains = wrestler1Deposit.add(wrestler2Deposit);
        EndOfWrestlingEvent(winner, gains);
    }

    /**
    * @dev The withdraw function, following the withdraw pattern shown and explained here: 
    * @dev http://solidity.readthedocs.io/en/develop/common-patterns.html#withdrawal-from-contracts
    */
    function withdraw() public {
        require(gameFinished && theWinner == msg.sender);

        msg.sender.transfer(this.balance);
    }
}
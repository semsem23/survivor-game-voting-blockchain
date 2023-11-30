// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "hardhat/console.sol";
import "../contracts/SurvivorGame.sol";

contract SurvivorGameTest {

    SurvivorGame survivorGame;

    function beforeAll() public {
        survivorGame = new SurvivorGame();
        survivorGame.initialize("Contestant");
    }

    function checkInitialize() public {
        uint256[] memory voteCounts = survivorGame.getTotalVoteCounts();
        Assert.equal(voteCounts[0], 0, "Contestant not initialized correctly");
    }
    
    function checkVoteOut() public {
        survivorGame.voteOut("Contestant");
        uint256[] memory voteCounts = survivorGame.getTotalVoteCounts();
        Assert.equal(voteCounts[0], 1, "Contestant vote count incorrect");
    }
    
    function checkAnnounceVotedOut() public {
        string memory votedOutContestant = survivorGame.announceVotedOut();
        Assert.equal(votedOutContestant, "Contestant", "Incorrect voted out contestant");
    }
}
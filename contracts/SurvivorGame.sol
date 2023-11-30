// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract SurvivorGame {
   
    address public host;  // Address of the host

    struct Participant {
        bool alreadyVoted;
        uint voteIndex;
    }
   
    struct Contestant {
        string name;
        uint256 voteCount;
    }
   
    mapping(address => Participant) participantAddress;
   
    Contestant[] public contestants;

    modifier onlyHost() {
        require(msg.sender == host, "Only the host can execute this");
        _;
    }

    // Initialize the contract with the host address
    constructor() {
        host = msg.sender;
    }

    // Initialize a new contestant
    function initialize(string memory name) public {
        contestants.push(Contestant(name, 0));
    }

    // Get the total vote count for each contestant
    function getTotalVoteCounts() public view returns (uint256[] memory) {
        uint256[] memory voteCounts = new uint256[](contestants.length);
        for (uint256 i = 0; i < contestants.length; i++) {
            voteCounts[i] = contestants[i].voteCount;
        }
        return voteCounts;
    }

    // Participants can vote only once
    // This function finds the contestant with the passed string in input
    function voteOut(string memory _name) public {
        require(participantAddress[msg.sender].alreadyVoted == false, "You have already voted");
        participantAddress[msg.sender].alreadyVoted = true;
        for (uint256 i = 0; i < contestants.length; i++) {
            if (keccak256(bytes(contestants[i].name)) == keccak256(bytes(_name))) {
                participantAddress[msg.sender].voteIndex = i;
                contestants[i].voteCount++;
            }
        }
    }

    // Host can announce the contestant voted out
    function announceVotedOut() public view onlyHost returns (string memory) {
        uint256 max = 0;
        string memory votedOutContestant;
        for (uint256 i = 0; i < contestants.length; i++) {
            if (contestants[i].voteCount > max) {
                max = contestants[i].voteCount;
                votedOutContestant = contestants[i].name;
            }
        }
        
        require(max > 0, "No votes recorded");  // Add this line for debugging
        return votedOutContestant;
    }
}
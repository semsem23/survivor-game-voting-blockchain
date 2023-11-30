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
   
    mapping(address => Participant) public participants;
    Contestant[] public contestants; // Assuming there are five contestants

    modifier onlyHost() {
        require(msg.sender == host, "Only the host can execute this");
        _;
    }

    // Initialize the contract with the host address
    constructor() {
        host = msg.sender;
    }

    // Explicit getter function for participants mapping
    function getParticipant(address participantAddress) external view returns (Participant memory) {
        return participants[participantAddress];
    }

    // Initialize a new contestant
    function initialize(string memory name, uint8 contestantIndex) external onlyHost {
        require(contestantIndex < contestants.length, "Contestant index out of range");
        contestants[contestantIndex] = Contestant(name, 0);
    }

    // Get the total vote count for each contestant
    function getTotalVoteCounts() external view returns (uint256[] memory) {
        uint256[] memory voteCounts;

        for (uint8 i = 0; i < contestants.length; i++) {
            voteCounts[i] = contestants[i].voteCount;
        }

        return voteCounts;
    }

    // Participants can vote only once
    // This function finds the contestant with the passed string in input
    function voteOut(string memory _name) external {
        Participant storage participant = participants[msg.sender];
        require(!participant.alreadyVoted, "You have already voted");
        
        for (uint8 i = 0; i < contestants.length; i++) {
            if (keccak256(bytes(contestants[i].name)) == keccak256(bytes(_name))) {
                participant.alreadyVoted = true;
                participant.voteIndex = i;
                contestants[i].voteCount++;
                break;  // Exit loop once vote is counted
            }
        }
    }

    // Host can announce the contestant voted out
    
    function announceVotedOut() external view onlyHost returns (string memory) {
        uint256 maxVotes = 0;
        string memory votedOutContestant;

        for (uint8 i = 0; i < contestants.length; i++) {
            if (contestants[i].voteCount > maxVotes) {
                maxVotes = contestants[i].voteCount;
                votedOutContestant = contestants[i].name;
            }
        }

        return votedOutContestant;
    }
}
// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

interface IGuessMyPassword {
    function guessMyPassword(bytes32 _password) external;
}

contract PasswordGuesser {
    IGuessMyPassword public guessMyPasswordContract;

    constructor(address _contractAddress) public {
        guessMyPasswordContract = IGuessMyPassword(_contractAddress);
    }

    function guessPassword() public {
        guessMyPasswordContract.guessMyPassword("I'Mz3p4SsW0rd");
    }
}
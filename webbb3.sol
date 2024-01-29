// SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

struct Voting {
    string option1;
    uint votes1;
    string option2;
    uint votes2;
    uint maxDate;
}

struct Vote {
    uint choice; //0 por default
    uint date;
}

contract Webbb3 {
    address owner;
    uint public currentVoting = 0;

    //cada chave uint vai apontar para uma votação
    //0 => 0x1 => 1  0x2 => 2
    //vai apontar para a carteira no campo de voto
    mapping(uint => mapping(address => Vote)) public votes; 

    Voting[] public votings;

    constructor() {
        owner = msg.sender;
    }

    function getCurrentVoting() public view returns (Voting memory) {
      return votings[currentVoting]; 
    }

    function addVoting(string memory option1, string memory option2, uint timeToVote) public {
       require(owner == msg.sender, "Invalid sender");
       if(votings.length != 0) currentVoting++; 

       Voting memory newVoting;
       newVoting.option1 = option1;
       newVoting.option2 = option2;
       newVoting.maxDate = timeToVote + block.timestamp;
       votings.push(newVoting);     
    }

    function addVote(uint choice) public {
      require(choice == 1 || choice == 2, "Invalid choice"); 
      require(getCurrentVoting().maxDate > block.timestamp, "No open voting");
      require(votes[currentVoting][msg.sender].date == 0, "User has already voted");

      votes[currentVoting][msg.sender].choice = choice;
      votes[currentVoting][msg.sender].date = block.timestamp;

      if(choice == 1) votings[currentVoting].votes1++;
      else votings[currentVoting].votes2++;
    }



}
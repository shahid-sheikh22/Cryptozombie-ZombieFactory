// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ZombieFactory {

    event NewZombie(uint zombieId, string name, uint dna);

    uint constant dnaDigits = 16;
    uint constant dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;
    mapping(address => bool) public hasCreatedZombie;

    function _createZombie(string memory _name, uint _dna) private {
        zombies.push(Zombie(_name, _dna));
        uint id = zombies.length - 1;
        emit NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, _str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        require(!hasCreatedZombie[msg.sender], "User has already created a zombie");
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
        hasCreatedZombie[msg.sender] = true;
    }
}

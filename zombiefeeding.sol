pragma solidity >=0.5.0 <0.6.0;

import "./zombiefactory.sol";

// interact with external contract on ethereum
// its an interface
contract KittyInterface {
    function getKitty(uint256 _id)
        external
        view
        returns (
            bool isGestating,
            bool isReady,
            uint256 cooldownIndex,
            uint256 nextActionAt,
            uint256 siringWithId,
            uint256 birthTime,
            uint256 matronId,
            uint256 sireId,
            uint256 generation,
            uint256 genes
        );
}

// inheriting ZombieFactory
contract ZombieFeeding is ZombieFactory {
    address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
    KittyInterface kittyContract = KittyInterface(ckAddress);

    // two types of data location
    // storage - it stores data on blockchain permanently. It's like to store on hard disk
    // memory - it's a temporary location like RAM
    function feedAndMultiply(uint256 _zombieId, uint256 _targetDna, string memory _species) public {
        require(msg.sender == zombieToOwner[_zombieId]);
        Zombie storage myZombie = zombies[_zombieId];

        // be sure that target dna length is equal to 16
        _targetDna = _targetDna % dnaModulus;

        // create new dna from zombieId and targetDna
        uint256 newDna = (myZombie.dna + _targetDna) / 2;

        if(keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
            newDna = newDna - newDna % 100 + 99;
        }

        _createZombie("NoName", newDna);
    }

    function feedOnKitty(uint _zombieId, uint _kittyId) public {
        uint kittyDna;
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    }
}

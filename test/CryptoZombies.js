const CryptoZombies = artifacts.require("CryptoZombies");
const utils = require("./helpers/utils.js");
const zombieNames = ["Zombie 1", "Zombie 2", "Zombie 3", "Zombie 4"];


contract("CryptoZombies", (accounts) => {
    let [alice, bob] = accounts;
    let contractInstance;

    beforeEach(async () => {
        contractInstance = await CryptoZombies.new();
    })

    it("should be able to create new Zombie", async () => {
        const result = await contractInstance.createRandomZombie(zombieNames[0], {from: alice});
        assert(result.receipt.status, true);
        assert(result.logs[0].args.name, zombieNames[0]);
    });

    it("should not allow two zombies", async () => {
        await contractInstance.createRandomZombie(zombieNames[0], {from: alice});
        await utils.shouldThrow(contractInstance.createRandomZombie(zombieNames[1], {from: alice}));
    })
});
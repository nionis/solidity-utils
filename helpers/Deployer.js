/*
  wrapper around truffle deploy to save addresses and retrieve them
*/

const low = require("lowdb");
const FileSync = require("lowdb/adapters/FileSync");
const path = require("path");

const Deployer = (deployer, network) => {
  const addressesPath = path.join("build", `addresses-${network}.json`);
  const adapter = new FileSync(addressesPath);
  const db = low(adapter);
  db.defaults({}).write();

  const getAddresses = () => db.getState();

  const deploy = async ({ contract, name }, ...args) => {
    await deployer.deploy(contract, ...args);
    const deployed = contract.at(contract.address);

    const contractName = name || deployed.constructor.contractName;
    db.set(contractName, deployed.address).write();

    return deployed;
  };

  return {
    deploy,
    getAddresses,
  };
};

module.exports = Deployer;

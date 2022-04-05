const getDetails = async (walletAddress,slot, chainIds) => {
  try {

  let contractAddress = "0x0c60447Ce83877C19c52B8E876D194D00f68b30e";
  let web3s;
  let slot = slotvalue;
  console.log(walletAddress);
  if (chainIds === 1) {
    web3s = new Web3(
      "https://rinkeby.infura.io/v3/3eb62f1e00c34ffd81079387cf56e3b5"
    );
  } else {
    web3s = new Web3(
      "https://rinkeby.infura.io/v3/3eb62f1e00c34ffd81079387cf56e3b5"
    );
  }

    const contract = new web3s.eth.Contract(bbcc, contractAddress);
    console.log(contract._address)
   // await contract.method.apporve().send()
    let stakeInfo = await contract.methods.mintSuperCar(slot).send({from : walletAddress});  // minitng bbcc
    console.log(stakeInfo)
  } catch (error) {
    console.log("getTokenInfo", error);
  }
}
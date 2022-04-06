import React, { useEffect, useState, useRef } from "react";
import "../App.css";
import "./HeroSection.css";
import BG from "../img/BG.png";
import logo from "../img/logo.png";
import Discord from "../img/Discord.png";
import Instagram from "../img/Instagram.png";
import Twitter from "../img/Twitter.png";
import Grid from "@material-ui/core/Grid";
import ReactDOM from "react-dom";
import { GroupedButtons, slotvalue } from "./GroupedButtons";
import "aos/dist/aos.css";
import { Button } from "@material-ui/core";
const { ethers } = require("ethers");
const Web3 = require("web3");
const bbcc = require("./pages/abi/abi.json");

function HeroSection() {
  const [click, setClick] = useState(false);
  const [button, setButton] = useState(true);
  const [accounts, setAccount] = useState("");
  const [chainID, setChainID] = useState("137");
  const [a, seta] = useState("0.1");
  const handleClick = () => setClick(!click);
  const closeMobileMenu = () => setClick(false);
  const [ts, setts] = useState("");
  const [whiteListType, setwhiteListType] = useState("");

  useEffect(() => {
    seta((0.1 * slotvalue).toString());
  });

  const connetMetMask = async () => {
    try {
      console.log("slot id :", slotvalue);
      const [accounts] = await window.ethereum.request({
        method: "eth_requestAccounts",
      });
      setAccount(accounts); 
      const chainID1 = await window.ethereum.request({ method: "eth_chainId" });
      console.log("chainid", chainID1);
      setChainID(chainID1);
      let contractAddress = "0x0c60447Ce83877C19c52B8E876D194D00f68b30e";

      // const eth_NODE_URL = "https://speedy-nodes-nyc.moralis.io/f5f29ce1892ca85c041e30b7/eth/rinkeby";
      // const provider = new ethers.providers.JsonRpcProvider(eth_NODE_URL);
      // provider.getBlockNumber().then((result)=>{
      //   console.log("Current Block Number: "+ result);
      // })
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const signer = provider.getSigner();
      const BBCCContract = new ethers.Contract(contractAddress, bbcc, signer);
      const totalsuppuly = await BBCCContract.totalSupply();
      // funtion for checking to whitelist

      let whiteListVIPMint = await BBCCContract.whiteListVIPMint(accounts);
      let whiteListVIPMintLimit = await BBCCContract.whiteListVIPMintLimit(
        accounts
      );

      let whiteListPreMint = await BBCCContract.whiteListPreMint(accounts);
      let whiteListPreMintLimit = await BBCCContract.whiteListPreMintLimit(
        accounts
      );

      let normalWhiteListing = await BBCCContract.normalWhiteListing(accounts);
      let normalWhiteListingLimit = await BBCCContract.normalWhiteListingLimit(
        accounts
      );
      // checkforwhitelist();

      if (whiteListVIPMint) {
        setwhiteListType("whiteListVIPMint");
      } else {
        if (whiteListPreMint) {
          setwhiteListType("whiteListPreMint");
        } else {
          if (normalWhiteListing) {
            setwhiteListType("normalWhiteListing");
          }
        }
      }
      if (whiteListVIPMint)
        console.log("whiteListVIPMint", whiteListVIPMintLimit.toString());
      if (whiteListPreMint)
        console.log("whiteListPreMint", whiteListPreMintLimit.toString());
      if (normalWhiteListing)
        console.log("normalWhiteListing", normalWhiteListingLimit.toString());
      // : setwhiteListType();

      //console.log("whiteListType:-", whiteListType);

      console.log(totalsuppuly.toString());
      setts(totalsuppuly.toString());
      console.log("current account", accounts);
    } catch (error) {
      alert(error);
    }
  };

  const mintNFT = async (_slotID) => {
    try {
      console.log("whiteListType:-", whiteListType);

      let contractAddress = "0x0c60447Ce83877C19c52B8E876D194D00f68b30e";
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const signer = provider.getSigner();
      const BBCCContract = new ethers.Contract(contractAddress, bbcc, signer);
      let Tx;
      // let val = ethers.utils.parseEther("0.1" * _slotID);
      if (whiteListType === "whiteListVIPMint") {
        Tx = await BBCCContract.mintSuperCar(_slotID, {
          value: ethers.utils.parseEther(`${0.06 * _slotID}`),
        });
      } else {
        if (whiteListType === "whiteListPreMint") {
          Tx = await BBCCContract.mintSuperCar(_slotID, {
            value: ethers.utils.parseEther(`${0.05 * _slotID}`),
          });
        } else {
          if (whiteListType === "normalWhiteListing") {
            Tx = await BBCCContract.mintSuperCar(_slotID, {
              value: ethers.utils.parseEther(`${0.1 * _slotID}`),
            });
          } else {
            if (whiteListType === "") {
              Tx = await BBCCContract.mintSuperCar(_slotID, {
                value: ethers.utils.parseEther(`${0.1 * _slotID}`),
              });
            }
          }
        }
      }
      console.log("tx mintied:- ", Tx.hash);
      alert(Tx.hash);
      Tx.wait();
      console.log(Tx);
    } catch (error) {
      var l1 = error
      alert(l1);
    }
  };

  const showButton = () => {
    if (window.innerWidth <= 960) {
      setButton(false);
    } else {
      setButton(true);
    }
  };

  useEffect(() => {
    showButton();

  }, []);

  window.addEventListener("resize", showButton);

  return (
    <>
      <div id="herosection" className="hero-container">
        <Grid container spacing={0}>
          <Grid item xs={4} md={4} sm={4}></Grid>
          <Grid item xs={4} md={4} sm={4}>
            <div className="logo">
              <img className="logoImg" src={logo} />
            </div>
          </Grid>
          <Grid item xs={4} md={4} sm={4}>
            <div className="walletButton">
              <button className="wallet" onClick={() => connetMetMask()}>
                {accounts.length > 0
                  ? `${accounts[0]}${accounts[1]}${accounts[2]}${accounts[3]}${accounts[4]}...${accounts[30]}${accounts[31]}${accounts[32]}`
                  : "Connect Wallet"}
              </button>
            </div>
          </Grid>
        </Grid>

        <div className="introHead">
          <h1 className="intro1">Ladies and Gentlemen!</h1>
          <h1 className="intro2">START YOUR ENGINES</h1>
        </div>
        <div className="containerBox">
          <h1 className="tokenminted1">
            Tokens Minted : <span style={{ color: "#2C9B1A" }}>&nbsp;{ts}</span>
            /8000
          </h1>
          <h1 className='tokenminted'>Price :  0.1 ETH/NFT (MAX 10)</h1>
        </div>
        <div className="quantityButton">
          <GroupedButtons />
        </div>
        <div className="mintButton">
          <Button className="mint" onClick={() => mintNFT(slotvalue)}>
            IGNITION
          </Button>
        </div>
        <div className="disclaimer">
          <h1 className="dis-txt"> </h1>
        <h2 className="dis-txt1">Disclaimer:Please cross-verify the contract address with our official links on discord before minting as crypto is exposed to a lot of imitation scams. BBCC is not affiliated with the brand "Lamborghini" or any of its copyrights and have used material applied to a specific asset we already own and are giving away. Crypto and NFTs are highly volatile, illiquid assets and only expose funds that you are willing to loose 100%. By pressing the mint button, you are executing this purchase at your own risk and do not hold anyone else responsible for any outcome or obligation from this action. Please stay involved on our Discord community for real-time information about the project. We stand committed to carrying out our roadmap to the best of our ability. Nothing on this website is to be treated as financial advice.</h2>
        </div>
        <div className="footer">
          <Grid container spacing={0}>
            <Grid item xs={4} md={4} sm={4}>
              <div className="imgBox">
                <a>
                  <img className="img-footer" src={Discord} />
                </a>
              </div>
            </Grid>
            <Grid item xs={4} md={4} sm={4}>
              <div className="imgBox">
                <a>
                  <img className="img-footer" src={Instagram} />
                </a>
              </div>
            </Grid>
            <Grid item xs={4} md={4} sm={4}>
              <div className="imgBox">
                <a>
                  <img className="img-footer" src={Twitter} />
                </a>
              </div>
            </Grid>
          </Grid>
        </div>
       
      </div>
    </>
  );
}

export default HeroSection;

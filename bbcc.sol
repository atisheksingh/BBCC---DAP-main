// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract SuperCarNFT is ERC721, ERC721URIStorage, Ownable {
    using SafeMath for uint256;

    using Counters for Counters.Counter;
    bool public saleIsActive = false;
    bool public saleIsActiveForVIP = true;
    bool public saleIsActiveForPerMint = true;
    bool public saleIsActiveWhiteList = false;
    Counters.Counter private _tokenOwners;

    string baseURI; // set it to private
    string public notRevealedUri;

    mapping(address => bool) public whiteListPreMint;
    mapping(address => uint256) public whiteListPreMintLimit; // info

    mapping(address => bool) public whiteListVIPMint;
    mapping(address => uint256) public whiteListVIPMintLimit; // info

    mapping(address => bool) public normalWhiteListing;
    mapping(address => uint256) public normalWhiteListingLimit; //info

    bool public normalWhiteListMintable = false;
    uint256 public normalWhiteSlot = 1200;

    uint256 public superCarPrice = 100000000000000000; //0.1 ETH
    uint256 public whiteListPreMintPrice = 50000000000000000; //0.05
    uint256 public whiteListVIPMintPrice = 60000000000000000; //0.06
    uint256 public constant maxSuperCarPurchase = 10;
    uint256 public MAX_SUPER_CARS;
    uint256 public REVEAL_TIMESTAMP;
    uint256 public startingIndexBlock; // ??

    constructor(
        uint256 maxNftSupply,
        uint256 time,
        address dev,
        string memory _initBaseURI,
        string memory _initNotRevealedUri
    ) ERC721("Big Block Car Club", "BBCC") {
        MAX_SUPER_CARS = maxNftSupply;
        REVEAL_TIMESTAMP = time;
        setBaseURI(_initBaseURI);
        setNotRevealedURI(_initNotRevealedUri);
        _tokenOwners.increment();
        /**
        Dev and Artist 400 each
         */
        for (uint256 i = 0; i < 100; i++) {
            uint256 mintIndex = _tokenOwners.current();
            if (totalSupply() < MAX_SUPER_CARS) {
                _safeMint(dev, mintIndex);
                _tokenOwners.increment();
            }
        }
    }

    function SuperCarPrice(uint256 _newPrice) public onlyOwner {
        superCarPrice = _newPrice;
    }

    function WhiteListPreMintPrice(uint256 _newPrice) public onlyOwner {
        whiteListPreMintPrice = _newPrice;
    }

    function WhiteListVIPMintPrice(uint256 _newPrice) public onlyOwner {
        whiteListVIPMintPrice = _newPrice;
    }

    function baseURIs(string memory _baseURI) public onlyOwner {
        baseURI = _baseURI;
    }

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenOwners.current();
        _tokenOwners.increment();
        _safeMint(to, tokenId);
    }

    function giveAway(
        address[] memory to,
        uint256[] memory numberOfTokens,
        uint104 n
    ) public onlyOwner {
        for (uint32 i = 0; i < n; i++) {
            for (uint32 j = 0; j < numberOfTokens[i]; j++) {
                uint256 tokenId = _tokenOwners.current();
                _tokenOwners.increment();
                _safeMint(to[i], tokenId);
            }
        }
    }

    function reserveForartist(address artist) public onlyOwner {
        for (uint256 i = 0; i < 400; i++) {
            uint256 mintIndex = _tokenOwners.current();
            if (totalSupply() < MAX_SUPER_CARS) {
                _safeMint(artist, mintIndex);
                _tokenOwners.increment();
            }
        }
    }

    function reserveForDev(address _dev) public onlyOwner {
        for (uint256 i = 0; i < 300; i++) {
            uint256 mintIndex = _tokenOwners.current();
            if (totalSupply() < MAX_SUPER_CARS) {
                _safeMint(_dev, mintIndex);
                _tokenOwners.increment();
            }
        }
    }


    function SetREVEAL_TIMESTAMP(uint256 time) public onlyOwner {
        REVEAL_TIMESTAMP = time;
    }

    /*
     * Pause sale if active, make active if paused
     */
    function flipSaleState() public onlyOwner {
        saleIsActive = !saleIsActive;
    }

    function flipSaleStateForWhitelist() public onlyOwner {
        saleIsActiveWhiteList = !saleIsActiveWhiteList;
    }

    function flipSaleStateForPerMint() public onlyOwner {
        saleIsActiveForPerMint = !saleIsActiveForPerMint;
    }

    function flipSaleStateForVIP() public onlyOwner {
        saleIsActiveForVIP = !saleIsActiveForVIP;
    }

    /**
     * Mints Super Car
     */
    function mintSuperCar(uint256 numberOfTokens) public payable {
        require(
            totalSupply().add(numberOfTokens) <= MAX_SUPER_CARS,
            "Purchase would exceed max supply of Supercar"
        );

        if (normalWhiteListing[msg.sender]) {
            require(
                saleIsActiveWhiteList,
                "Whitelisting Sale must be active to mint the NFT"
            );
            require(
                numberOfTokens <= maxSuperCarPurchase,
                "Can only mint 10 tokens at a time"
            );
            require(
                superCarPrice.mul(numberOfTokens) <= msg.value,
                "Ether value sent is not correct"
            );
            for (uint256 i = 0; i < numberOfTokens; i++) {
                uint256 mintIndex = _tokenOwners.current();
                if (totalSupply() < MAX_SUPER_CARS) {
                    _safeMint(msg.sender, mintIndex);
                    _tokenOwners.increment();
                }
            }
            normalWhiteListingLimit[msg.sender] = normalWhiteListingLimit[
                msg.sender
            ].sub(numberOfTokens);
            if (normalWhiteListingLimit[msg.sender] == 0) {
                normalWhiteListing[msg.sender] = false;
            }
        } else {
            /**
        normal user minting
         */
            if (
                !whiteListVIPMint[msg.sender] && !whiteListPreMint[msg.sender] && !normalWhiteListing[msg.sender]
            ) {
                require(saleIsActive, "Sale must be active to mint the NFT");
                require(
                    numberOfTokens <= maxSuperCarPurchase,
                    "Can only mint 10 tokens at a time"
                );
                require(
                    superCarPrice.mul(numberOfTokens) <= msg.value,
                    "Ether value sent is not correct"
                );
                for (uint256 i = 0; i < numberOfTokens; i++) {
                    uint256 mintIndex = _tokenOwners.current();
                    if (totalSupply() < MAX_SUPER_CARS) {
                        _safeMint(msg.sender, mintIndex);
                        _tokenOwners.increment();
                    }
                }
            } else {
                if (whiteListPreMint[msg.sender]) {
                    require(
                        saleIsActiveForPerMint,
                        "Per-Mint Sale must be active to mint the NFT"
                    );
                    require(
                        numberOfTokens <= whiteListPreMintLimit[msg.sender],
                        "You have exceeded your whitelist limit"
                    );
                    require(
                        whiteListPreMintPrice.mul(numberOfTokens) <= msg.value,
                        "Ether value sent is not correct"
                    );
                    for (
                        uint256 i = 0;
                        i < numberOfTokens;
                        i++
                    ) {
                        uint256 mintIndex = _tokenOwners.current();
                        if (totalSupply() < MAX_SUPER_CARS) {
                            _safeMint(msg.sender, mintIndex);
                            _tokenOwners.increment();
                        }
                    }
                    whiteListPreMintLimit[msg.sender] = whiteListPreMintLimit[
                        msg.sender
                    ].sub(numberOfTokens);
                    if (whiteListPreMintLimit[msg.sender] == 0) {
                        whiteListPreMint[msg.sender] = false;
                    }
                }
                if (whiteListVIPMint[msg.sender]) {
                    require(
                        saleIsActiveForVIP,
                        "VIP Sale must be active to mint the NFT"
                    );
                    require(
                        numberOfTokens <= whiteListVIPMintLimit[msg.sender],
                        "You have exceeded your whitelist limit"
                    );
                    require(
                        whiteListVIPMintPrice.mul(numberOfTokens) <= msg.value,
                        "Ether value sent is not correct"
                    );
                    for (
                        uint256 i = 0;
                        i < numberOfTokens;
                        i++
                    ) {
                        uint256 mintIndex = _tokenOwners.current();
                        if (totalSupply() < MAX_SUPER_CARS) {
                            _safeMint(msg.sender, mintIndex);
                            _tokenOwners.increment();
                        }
                    }
                    whiteListVIPMintLimit[msg.sender] = whiteListVIPMintLimit[
                        msg.sender
                    ].sub(numberOfTokens);
                    if (whiteListVIPMintLimit[msg.sender] == 0) {
                        whiteListVIPMint[msg.sender] = false;
                    }
                }
            }
        }

        // If we haven't set the starting index and this is either 1) the last saleable token or 2) the first token to be sold after
        // the end of pre-sale, set the starting index block
        if (
            startingIndexBlock == 0 &&
            (totalSupply() == MAX_SUPER_CARS ||
                block.timestamp >= REVEAL_TIMESTAMP)
        ) {
            startingIndexBlock = block.number;
        }
    }

    function totalSupply() public view returns (uint256) {
        uint256 t = _tokenOwners.current();
        return t - 1;
    }

    function addWhiteListVIPMint(
        address[] memory user,
        uint256[] memory num,
        uint32 n
    ) public onlyOwner {
        for (uint32 i = 0; i < n; i++) {
            whiteListVIPMint[user[i]] = true;
            whiteListVIPMintLimit[user[i]] = num[i];
        }
    }

    function addnormalWhiteListing(
        address[] memory user,
        uint256[] memory num,
        uint32 n
    ) public onlyOwner {
        for (uint32 i = 0; i < n; i++) {
            normalWhiteListing[user[i]] = true;
            normalWhiteListingLimit[user[i]] = num[i];
        }
    }

    function addwhiteListPreMint(
        address[] memory user,
        uint256[] memory num,
        uint32 n
    ) public onlyOwner {
        for (uint32 i = 0; i < n; i++) {
            whiteListPreMint[user[i]] = true;
            whiteListPreMintLimit[user[i]] = num[i];
        }
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        if (REVEAL_TIMESTAMP > block.timestamp) {
            return notRevealedUri;
        }
        string memory currentBaseURI = baseURI;
         return tokenId > 0
        ? string(abi.encodePacked(currentBaseURI, toString(tokenId), ".json"))
        : "";
    }

    function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
        notRevealedUri = _notRevealedURI;
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function withdraw() public payable onlyOwner {
        (bool os, ) = payable(owner()).call{value: address(this).balance}("");
        require(os);
    }

    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}
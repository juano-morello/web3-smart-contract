// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721Enumerable, Ownable{
  // PROJECT SETTINGS
  uint16 public maxSupply = 10000;

  uint256 public ethPublicPrice = 0.01 ether;
  uint256 public ethPreSalePrice = 0.008 ether;
  uint256 public ethPrivatePrice = 0.003 ether;

  bool public isActivePublic = false;
  bool public isActivePreSale = false;
  bool public isActivePrivateSale = true;

  uint16 public maxAllowedMintsPresale = 1000;

  // withdraw addresses
  address withdrawAddress1;
  address withdrawAddress2;

  // private whitelist
  mapping (address => bool) privateWhitelist;

  // pre sale whitelist
  mapping (address => bool) preSaleWhitelist;

  // Base uri path for late reveal
  string baseURIPath;

  constructor(address _address1, address _address2) ERC721("MyNFT", "MYNFT") {
    // stuff to do here on deploy
    withdrawAddress1 = _address1;
    withdrawAddress2 = _address2;
    _setupPreSaleWhitelist();
    _setupPrivateWhitelist();
  }

  // Override the default base URI path
  function _baseURI() internal view override returns (string memory) {
    return baseURIPath;
  }

  // MINT FUNCTIONS
  function publicMint(uint8 tokenAmount) external payable {
    require(isActivePublic, "Public sale has been paused. Refer to the project discord for further info");
    require(totalSupply() + tokenAmount <= maxSupply, "This transaction would exceed the amount of tokens offered");
    require(ethPublicPrice * tokenAmount == msg.value, "Ether value is not correct");

    uint mintIndex;

    for(uint i; i < tokenAmount; i++) {
      mintIndex = totalSupply();
      if(mintIndex < maxSupply) {
        _safeMInt(msg.sender, mintIndex);
      }
    }
  }

  function preSaleMint(uint8 tokenAmount) external payable {
    require(isActivePreSale, "Public sale has been paused. Refer to the project discord for further info");
    require(preSaleWhitelist[msg.sender], "Address is not whitelisted for the pre sale mint event");
    require(totalSupply() + tokenAmount <= maxSupply, "This transaction would exceed the amount of tokens offered");
    require(ethPreSalePrice * tokenAmount == msg.value, "Ether value is not correct");

    uint mintIndex;

    for(uint i; i < tokenAmount; i++) {
      mintIndex = totalSupply();
      if(mintIndex < maxSupply) {
        _safeMInt(msg.sender, mintIndex);
      }
    }
  }

  function privateMint(uint8 tokenAmount) external payable {
    require(isActivePrivateSale, "Public sale has been paused. Refer to the project discord for further info");
    require(privateWhitelist[msg.sender], "Address is not whitelisted for the private mint event");
    require(totalSupply() + tokenAmount <= maxSupply, "This transaction would exceed the amount of tokens offered");
    require(ethPrivatePrice * tokenAmount == msg.value, "Ether value is not correct");

    uint mintIndex;

    for(uint i; i < tokenAmount; i++) {
      mintIndex = totalSupply();
      if(mintIndex < maxSupply) {
        _safeMInt(msg.sender, mintIndex);
      }
    }
  }

  // ONLY OWNER
  function togglePublicEvent() external OnlyOwner {
    isActivePublic = !isActivePublic;
  }

  function togglePreSaleEvent() external OnlyOwner {
    isActivePreSale = !isActivePreSale;
  }

  function togglePrivateEvent() external OnlyOwner {
    isActivePrivateSale = !isActivePrivateSale;
  }

  function withdraw() external onlyOwner {
    uint256 _share = address(this).balance / 2;
    Address.sendValue(payable(withdrawAddress1), _share);
    Address.sendValue(payable(withdrawAddress2), _share);
  }

  function _setupPreSaleWhitelist() internal {
//    preSaleWhitelist[0x0] = true;
  }

  function _setupPrivateWhitelist() internal {
//    preSaleWhitelist[0x0] = true;
  }
}

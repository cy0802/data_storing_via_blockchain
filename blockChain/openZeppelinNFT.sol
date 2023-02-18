// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MyToken is ERC721, Ownable {
    using Counters for Counters.Counter;
    // 去看counters.sol，是用來計數的
    Counters.Counter private _tokenIdCounter;
    string base_URI = "ipfs://QmRCPixRmqMUMGtmLzAA5jzvVJdmmpLsp9Jh4nG4FzLks4/";
    string base_extension = ".json";
    // 建立一個清單來紀錄誰有鑄造過，而每次執行鑄造時就會檢查該清單
    // 不付費帳戶免費使用10次
    mapping(address => uint256) public mint_count_Wallets;
    mapping(address => uint256) public VIP;
    mapping(address => uint256) public token_balance;
    constructor() ERC721("contract_store_NFT", "WTFN") {}
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token."
        );
        return string(abi.encodePacked(base_URI, Strings.toString(tokenId), base_extension));
    }
    // 直接判斷使用者的位址，防止同個使用者換很多錢包帳號，重複鑄造NFT
    function safeMint() public {
        // 定義tokenId為目前已存在的代幣總數
        uint256 tokenId = _tokenIdCounter.current();
        // 不付費帳戶只能免費使用10次
        // if(VIP[msg.sender] == false){
        //     require(mint_count_Wallets[msg.sender] < 10, "Sorry, you can only mint this NFT once per wallet");
        // }
        // // 是VIP帳戶就從他帳戶扣款，鑄造NFT
        // else{
        //     require(token_balance[msg.sender] > 0, "Sorry, your wallet has no enough money to ");
        // }
        // 將tokenId數值+1
        require(mint_count_Wallets[msg.sender] < 10, "Sorry, you can only mint this NFT once per wallet");
        _tokenIdCounter.increment();
        mint_count_Wallets[msg.sender] += 1;
        // 將此代幣編號tokenId鑄造給填入的地址to
        _safeMint(msg.sender, tokenId);
    }
}
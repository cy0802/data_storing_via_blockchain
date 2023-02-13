// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IERC721Receiver {
    function onERC721Received (
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}
interface IERC721Metadata {
    function name() external view returns(string memory);
    function symbol() external view returns(string memory);
    function tokenURI(uint256 tokenId) external view returns(string memory);
}
// 用來判斷該合約支援那些介面標準
interface IERC165 {
    // byte4代表一個長度為4的array
    // 判斷介面的id有沒有相符
    function supportInterface(bytes4 interfaceId) external view returns(bool);  
}

// 加上abstract是因為通常ERC165都會被其他合約拿去使用，不會被單獨使用
abstract contract ERC165 is IERC165 {
    // virtual 和 override都是繼承的概念
    function supportInterface(bytes4 interfaceId) public view virtual override returns(bool) {
        // 判斷傳入的interfaceId和我目前實作的interfaceId一不一樣
        return interfaceId == type(IERC165).interfaceId;
    }
}

interface IERC721 {
    // // mint and burn不是標準的ERC721該有的，mint and burn可以用別的擴充方式去寫 
    // // 鑄造，合約擁有者或是有特殊權限的人才能呼叫
    // // 屬於一種轉帳，由address(0)轉移到to
    // // 限制: 不能鑄造給address(0)、tokenId不能重複
    // function mint(address to, uint256 tokenId) external;
    // // 跟轉帳依樣，直接呼叫safeMint(to, tokenId, "")
    // function safeMint(address to, uint256 tokenId) external;
    // // 跟轉帳一樣，安全版本就是在轉移發生後呼叫onERC721Received的檢查
    // function safeMint(address to, uint256 tokenId, bytes memory data) external;
    // // 銷毀，屬於轉帳事件，將tokenId轉移到address(0)
    // function burn(uint256 tokenId) external;
    // Event
    // 當NFT發生轉移時，會觸發此事件
    event Transfer(address indexed from, address indexed to, uint256 tokenId);
    // NFT被授權時，會觸發此事件
    event Approval(address indexed owner, address indexed approved, uint256 tokenId);
    // NFT整包授權給第三方
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);  
    // Query
    // 查詢該使用者持有的NFT數量
    // 使用mapping來儲存，address => uint256(持有數量)
    // owner的位置不能為0，若為0則代表尚未被鑄造或是已被銷毀
    function balanceOf(address owner) external view returns(uint256 balance);
    // 給定一個tokenId，回傳該NTF的持有者
    // 使用mapping來儲存，uint256 => address
    function ownerOf(uint256 tokenId) external view returns(address owner);
    // Transfer
    // 若接收者為"合約位置"則會進行特殊檢查
    // 為了避免NFT被困在沒有能力進行轉移的合約位置當中
    // 若合約想要有持有NFT的能力，那麼就要實作IERC721Receiver介面，並且實作onERC721Receiver函式
    // 一樣會檢查呼叫者必須為NFT持有者或是被授權的第三方
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
    // 跟上一個函式只差在沒有"data"參數，因此在實作上通常直接呼叫上面的版本: safeTransferFrom(from, to, "")，data欄位為空
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
    // 呼叫者將編號為"tokenId"的NFT，從from轉移到to
    // 呼叫者必須為NFT持有者或是被授權的第三方
    function transferFrom(address from, address to, uint256 tokenId) external;
    // Approve
    // 呼叫者授權編號為為"tokenId"的NFT給第三方"to"
    // 使用mapping將tokenId對應到第三方，uint256 => address，一個tokenId可以授權給很多第三方
    // to和owner不能相同
    // 呼叫者要是NFT的擁有者或是被某人授權管理他的NFT
    function approve(address to, uint256 tokenId) external;
    // 呼叫者可以授權或撤銷自己持有的所有NFT給第三方(operator)
    // 用mapping來儲存，mapping(address(呼叫者) => mapping(address(第三方) => bool(授權與否)))
    // _approved為true: 授權。_approved為false: 撤銷
    function setApprovalForAll(address operator, bool _approved) external;
    // 給定一個tokenId，回傳該NFT的授權者
    function getApproved(uint256 tokenId) external view returns(address operator);
    // 查詢owner是否有授權給operator
    function isApprovedForAll(address owner, address operator) external view returns(bool);
}

// ERC721這個合約同時支援IERC721, IERC721Metadata這兩個interface
contract ERC721 is IERC721, IERC721Metadata, IERC165 {
    mapping(address => uint256) _balances;
    // 給tokenId，回傳owner位址
    // 隨便輸入tokenId，用_owners拿到的結果會是0(因為solidity初始化所有未知數為0)
    mapping(uint256 => address) _owners;
    // 一個tokenId對應到多個approval address
    mapping(uint256 => address) _tokenApprovals;
    // 授權人 => 被授權人 => 是否被授權
    mapping(address => mapping(address => bool)) _operatorApprovals;
    string _name;
    string _symbol;
    // tokenId對應到URI
    mapping(uint256 => string) _tokenURIs;
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;

    }
    function name() public view returns(string memory) {
        return _name;
    }
    function symbol() external view returns(string memory) {
        return _symbol;
    }
    // URI可以用ipfs browser找到放在ipfs上的json檔案
    function tokenURI(uint256 tokenId) public view returns(string memory) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ERROR: Token Id is not valid");
        return _tokenURIs[tokenId];
    }
    function setTokenURI(uint256 tokenId, string memory URI) public {
        // 確認NFT有被鑄造出來
        address owner = _owners[tokenId];
        require(owner != address(0), "ERROR: Token Id is not valid");
        _tokenURIs[tokenId] = URI;
    }
    function balanceOf(address owner) public view returns(uint256) {
        require(owner != address(0), "ERROR: token has not been mint or has been burn.");
        return _balances[owner];
    }
    function ownerOf(uint256 tokenId) public view returns(address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ERROR: token has not been mint or has been burn.");
        return owner;
    }
    function approve(address to, uint256 tokenId) public {
        address owner = _owners[tokenId];
        // owner不能和被授權人一樣(沒有意義)
        require(owner != address(0), "ERROR: token has not been mint or has been burn.");
        // 呼叫者要是owner或是被owner授權者其中之一
        // getApproved判斷單一NFT的授權
         require(owner == msg.sender || isApprovedForAll(owner, msg.sender) || getApproved(tokenId) == msg.sender, "ERROR: Msg.sender is not owner or being authorized.");
        // 把tokenId授權給to
        _tokenApprovals[tokenId] = to;
        // 觸發Approval事件
        emit Approval(owner, to, tokenId);
    }
    function getApproved(uint256 tokenId) public view returns(address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ERROR: token has not been mint or has been burn.");
        // 問題: 若一個tokenId被授權給很多第三方，要回傳哪一個?
        return _tokenApprovals[tokenId];
    }
    function setApprovalForAll(address operator, bool _approved) public {
        require(msg.sender != operator, "ERROR: msg.sender shouldn't be the person being authorized.");
        _operatorApprovals[msg.sender][operator] = _approved;
        emit ApprovalForAll(msg.sender, operator, _approved);
    }
    function isApprovedForAll(address owner, address operator) public view returns(bool) {
        return _operatorApprovals[owner][operator];
    }
    function _transfer(address from, address to, uint256 tokenId) internal {
        address owner = _owners[tokenId];
        require(owner != address(0), "ERROR: token has not been mint or has been burn.");
        require(msg.sender != to, "ERROR: msg.sender shouldn't be the person being transfered.");
        require(owner == msg.sender, "ERROR: You have no permission to transfer this nft.");     
        // 呼叫者要是owner或是被owner授權者其中之一
        require(owner == msg.sender || isApprovedForAll(owner, msg.sender) || getApproved(tokenId) == msg.sender, "ERROR: Msg.sender is not owner or being authorized.");
        // nft被轉移後，此tokenId原有的擁有者不再擁有此nft
        // delete為mapping的語法，用意為刪除mapping
        delete _tokenApprovals[tokenId];
        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;
        emit Transfer(from, to, tokenId);
    }
    function transferFrom(address from, address to, uint256 tokenId) public {
        _transfer(from, to, tokenId);
    }
    function _safeTransfer(address from, address to, uint256 tokenId, bytes memory data) internal {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, data), "ERROR: ERC721Receiver is not implemented");
   }
    // 和transfer的差別在此函式可以檢查接收者是否為合約
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) public {
        _safeTransfer(from, to, tokenId, data);
   }
   // safeTansferFrom應該要被外部呼叫，不能直接在function內呼叫
    function safeTransferFrom(address from, address to, uint256 tokenId) public {
        // 因為傳入的是在memory上的""空字串，因此不能使用calldata，要用memory
        _safeTransfer(from, to, tokenId, "");
    }
    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory data) private returns(bool) {
        // 檢查接收者是否為合約
        if(to.code.length > 0){
            try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, data) returns(bytes4 retval) {
                // 判斷回傳值和onERC721Received的函式選擇器是否一樣
                return retval == IERC721Receiver.onERC721Received.selector;
            }
            // 若try出問題(不能正確回傳true or false)，就會跑到catch
            // reason中會放錯誤訊息
            catch(bytes memory reason) {
                // 合約沒有實作ERC721Receiver
                if(reason.length == 0){
                    revert("ERC721: transfer to non ERC721Receiver implementer.");
                }
                else{
                    // 組合語言，如何解讀reason
                    ///@solidity memory-safe-assembly
                    assembly {
                        // 從reason中某個區域解讀true or false
                        // mload是把reason某個區塊讀取出來然後印出去
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        }
        // 若接收者不是合約，就可以放心轉移NFT
        else{
            return true;
        }
    }
    function mint(address to, uint256 tokenId) public {
        require(to != address(0), "ERROR: Mint to address 0");
        address owner = _owners[tokenId];
        // 若這個nft已經有owner，代表這個nft已經存在
        require(owner == address(0), "ERROR: tokenId has already existed.");
        _balances[to] += 1;
        _owners[tokenId] = to;
        emit Transfer(address(0), to, tokenId);
    }
    function safeMint(address to, uint256 tokenId, bytes memory data) public {
        mint(to, tokenId);
        require(_checkOnERC721Received(address(0), to, tokenId, data), "ERROR: ERCReceiver is not implemented");
    }
    function safeMint(address to, uint256 tokenId) public {
        safeMint(to, tokenId, "");
    }
    function burn(uint256 tokenId) public{
        address owner = _owners[tokenId];
        require(msg.sender == owner, "Only NTF's owner can burn");
        _balances[owner] -= 1;
        // _owners[tokenId] = address(0);
        // 上下寫法一樣
        delete _owners[tokenId];
        // 因為此NTF已被銷毀，所以授權人也要被清掉
        delete _tokenApprovals[tokenId];
        emit Transfer(owner, address(0), tokenId);
    }
    // 沒有改動到任何資料，可以用pure
    function supportInterface(bytes4 interfaceId) public pure returns(bool) {
        // type(介面名稱).interfaceId可以得到該介面的interfaceId
        return interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            interfaceId == type(IERC165).interfaceId;
    }
}
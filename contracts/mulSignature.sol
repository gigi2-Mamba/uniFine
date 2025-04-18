pragma solidity >=0.6.2;

import "@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/GSN/ContextUpgradeable.sol";
import "./interfaces/ImulSig.sol";
import "./libraries/whiteList.sol";

contract multiSignature is ContextUpgradeable, OwnableUpgradeable, ImulSig {
    // uint256 private constant defaultIndex = 0;
    using whiteListAddress for address[];
    address[] public signatureOwners;
    uint256 public threshold;
    uint256 internal nonce;
    uint256 public validPeriod;
    mapping(address => bytes32[]) public sigCountMap;
    mapping(address => bool) public applicants;

    struct signatureInfo {
        // 签名信息
        address applicant; // 签名的申请人
        address[] signatures; // 签名的授权者列表
        bool status;
        uint256 expiry;
        uint256 nonce;
    }
    mapping(bytes32 => signatureInfo) public signatureMap; // msgHash => 签名信息列表  这种可能在低阶的solidity版本会忽略空的数据不如自己写的
    // 用户持有的nonce交易细节

    event TransferOwner(
        address indexed sender,
        address indexed oldOwner,
        address indexed newOwner
    );
    event CreateApplication(
        address indexed from,
        address indexed to,
        bytes32 indexed msgHash,
        uint256 expiry
    );
    event SignApplication(
        address indexed from,
        bytes32 indexed msgHash,
        uint256 _nonce
    );
    event RevokeApplication(address indexed from, bytes32 indexed msgHash);
    modifier onlySigCall() {
        // 只能签名者直接调用
        require(
            signatureOwners.isEligibleAddress(msg.sender),
            getErrorMessage(msg.sender)
        );
        _;
    }

    modifier onlyApplicant() {
        require(
            applicants[msg.sender],
            "Multiple Signature : _owner is not in the ownerList!"
        );
        _;
    }

    function Initialize(
        address[] memory owners,
        uint256 limitedSignNum
    ) public initializer {
        __Context_init(); // 显式调用 ContextUpgradeable 的初始化器
        __Ownable_init(); // 再调用 OwnableUpgradeable 的初始化器
        require(
            owners.length >= limitedSignNum,
            "Multiple Signature : Signature threshold is greater than owners' length!"
        );
        // __Context_init_unchained();
        // __Ownable_init_unchained();

        signatureOwners = owners;
        threshold = limitedSignNum;
        nonce = 1;
        validPeriod = 3600; // 签署的签名有效期在一小时
    }

    function transferOwner(uint256 index, address newOwner) public onlySigCall {
        //还可以支持更换多签列表,这个比那个队列实现要科学一点,支持更改
        require(
            index < signatureOwners.length,
            "Multiple Signature : Owner index is overflow!"
        );
        emit TransferOwner(msg.sender, signatureOwners[index], newOwner);
        signatureOwners[index] = newOwner;
    }

    function createApplication(
        address to,
        bytes4 funcSig
    ) public returns (uint256 index) {
        bytes32 msghash = getApplicationHash(msg.sender, to, funcSig, nonce); // 生成一个唯一的申请哈希
        index = nonce;
        nonce++;
        applicants[to] = true;
        signatureMap[msghash] = signatureInfo(
            msg.sender,
            new address[](0),
            false,
            block.timestamp + validPeriod,
            index
        );
        sigCountMap[msg.sender].push(msghash);
        emit CreateApplication(
            msg.sender,
            to,
            msghash,
            block.timestamp + validPeriod
        );
        return index;
    }

    function signApplication(
        bytes32 msghash,
        uint256 index
    ) external onlySigCall {
        // 签名列表的长度必须大于0,证明有这个签名申请 存在
        emit SignApplication(msg.sender, msghash, index);
        signatureMap[msghash].signatures.addWhiteListAddress(msg.sender); // 这里就是对签名信息里的授权签名列表增加一个签名者
    }

    function revokeSignApplication(bytes32 msghash) external onlySigCall {
        emit RevokeApplication(msg.sender, msghash);
        signatureMap[msghash].signatures.removeWhiteListAddress(msg.sender);
    }

    function getValidSignature(
        // 看看是不是调用不了
        bytes32 msghash,
        address from
    ) internal view returns (bool) {
        // 这里的lastIndex是一个默认0,返回这个值是干嘛?
        signatureInfo storage info = signatureMap[msghash]; // 一个地址对一个合约进行调用的所有申请交易
        require(info.applicant == from, "申请人不匹配");
        require(info.signatures.length >= threshold, "签名数量不足");
        require(info.expiry > block.timestamp, "已过期");
        require(info.status == false, "状态错误");

        // if (
        //     info.signatures.length >= threshold &&
        //     info.expiry > block.timestamp &&
        //     info.status = false &&
        //     info.applicant == from
        // ) {
        //     return true;
        // }
        return true;
    }

    function getApplicationInfo(
        bytes32 msghash
    ) public view returns (address, address[] memory, bool, uint256, uint256) {
        signatureInfo memory info = signatureMap[msghash];
        return (
            info.applicant,
            info.signatures,
            info.status,
            info.expiry,
            info.nonce
        );
    }

    function getApplicationCount(
        // 获取当前用户的所有申请交易数量
        address addr
    ) internal view returns (uint256) {
        return sigCountMap[addr].length;
    }

    // generate application hash
    function getApplicationHash(
        address from,
        address to,
        bytes4 funcSig,
        uint256 _nonce
    ) public pure override returns (bytes32) {
        return keccak256(abi.encodePacked(from, to, funcSig, _nonce));
    }

    // 后期升级的函数
    function validCall(
        address sender,
        address to,
        bytes4 sig,
        uint256 _nonce
    ) external override onlyApplicant {
        bytes32 msghash = getApplicationHash(sender, to, sig, _nonce);

        require(msg.sender == to, "不是同一个调用");
        require(signatureOwners.isEligibleAddress(sender), "not authorized");
        bool success = getValidSignature(msghash, sender);
        // require(
        //     getValidSignature(msghash, sender),  这种写法不可取
        //     "Multiple Signature : Signature is not enough!"
        // );
        require(
            success, //这种写法不可取
            "Multiple Signature : Signature is not enough!"
        );
    }

    function addWhiteList(address newOwner) external onlySigCall {
        signatureOwners.addWhiteListAddress(newOwner);
    }

    function removeOwner(address oldOwner) external onlySigCall {
        require(
            signatureOwners.removeWhiteListAddress(oldOwner),
            "illegal operation"
        );
    }

    function tOnlySig() public view onlySigCall returns (uint256) {
        return validPeriod;
    }

    function toAsciiString(address x) public pure returns (string memory) {
        bytes memory s = new bytes(40);
        uint160 addr = uint160(x);
        for (uint i = 0; i < 20; i++) {
            // 取出每个字节
            uint8 b = uint8(addr >> (8 * (19 - i)));
            // 将高 4 位转换为字符
            s[2 * i] = char(b / 16);
            // 将低 4 位转换为字符
            s[2 * i + 1] = char(b % 16);
        }
        return string(s);
    }

    function char(uint8 b) internal pure returns (bytes1 c) {
        if (b < 10) {
            return bytes1(b + 48); // ASCII '0' = 48
        } else {
            return bytes1(b + 87); // ASCII 'a' = 97, 97 - 10 = 87
        }
    }

    function getErrorMessage(address x) public pure returns (string memory) {
        string memory addrStr = toAsciiString(x);
        return string(abi.encodePacked("caller err: 0x", addrStr));
    }
}

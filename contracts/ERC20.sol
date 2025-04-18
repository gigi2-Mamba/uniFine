// SPDX-License-Identifier: MIT
pragma solidity >=0.6.6;

import "./interfaces/IERC20.sol";

contract ERC20 is IERC20 {
    // 状态变量
    string public override name;
    string public override symbol;
    uint8 public override decimals;

    // uint256 public immutable totalSupply; // 不增加总量
    uint256 public override totalSupply; // 总价总量
    mapping(address => uint256) public override balanceOf;
    mapping(address => mapping(address => uint256)) public override allowance;

    // 函数修改器
    //   modifier onlyOwner() {
    //      require(msg.sender == owner, "not owner");
    //      _;
    //  }

    // 构造函数
    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) public {
        //  owner = msg.sender;
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = 0;
        //  balanceOf[msg.sender] = _totalSupply;
        // emit Transfer(address(0), msg.sender, _totalSupply);
    }

    // 1个授权
    function approve(
        address spender,
        uint256 amount
    ) external override returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    // 2个交易
    function transfer(
        address recipient,
        uint256 amount
    ) external override returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external override returns (bool) {
        // msg.sender 也就是当前调用者，是被批准者
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    // 1个铸币 - 非必须
    function mint(uint256 amount) external returns (bool) {
        totalSupply += amount;
        balanceOf[msg.sender] += amount;
        emit Transfer(address(0), msg.sender, amount);
        return true;
    }

    // 1个销毁 - 非必须
    function burn(uint256 amount) external returns (bool) {
        totalSupply -= amount;
        balanceOf[msg.sender] -= amount;
        emit Transfer(msg.sender, address(0), amount);
        return true;
    }
    // 转移 owner 权限等其他一些操作均是看各自业务，非必需的
}

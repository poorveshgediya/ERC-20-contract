// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

interface IERC20 {
    function totalSupply() external view returns(uint256);
    function balanceOf(address account) external view returns(uint256);
    function transfer(address recipent, uint256 amount) external returns(bool);

    event Transfer(address indexed from, address indexed to, uint256 value); 
}

contract ERC20 is  IERC20 {
    string public name;
    string public symbol;
    uint8 public decimals; 

    event Approval(address indexed owner, address indexed spender, uint256 value);

    mapping (address => uint256) balances;

    mapping (address => mapping (address => uint256)) allowed;

    uint256 totalSupply_;
    address admin;

    constructor(string memory _name, string memory _symbol, uint8 _decimal, uint256 _tsupply){
        totalSupply_ = _tsupply;
        balances[msg.sender] = totalSupply_;
        name = _name;
        symbol = _symbol;
        decimals = _decimal;
        admin = msg.sender;

    }

    modifier onlyadmin{
        require(msg.sender == admin , "only admin can mint the tokens");
        _;
    }

    function totalSupply() public override view returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address tokenOnwer) public override view returns(uint256)  {
        return balances[tokenOnwer];
    }

    function transfer(address receiver, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] -= numTokens;
        balances[receiver] += numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function mint(uint _qty) public onlyadmin returns (uint256){
        totalSupply_ += _qty;
        balances[msg.sender] += _qty;

        return totalSupply_;
    }

}
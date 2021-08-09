/**Create Crypto Bank Contract

    1) The owner can start the bank with initial deposit/capital in ether (min 50 eths)
    2) Only the owner can close the bank. Upon closing the balance should return to the Owner
    3) Anyone can open an account in the bank for Account opening they need to deposit ether with address
    4) Bank will maintain balances of accounts
    5) Anyone can deposit in the bank
    6) Only valid account holders can withdraw
    7) First 5 accounts will get a bonus of 1 ether in bonus
    8) Account holder can inquiry balance
The depositor can request for closing an account
*/

pragma solidity ^0.8.0;

contract CryptoBank{
    address public owner;
    uint8 count;
    mapping(address => uint) private accounts;
    constructor() payable {
        owner = msg.sender;
        require(msg.value>= 50000000000000000000);
        count = 0;
    }
    function closeBank() external payable{
        require(msg.sender == owner, "Owner can close the Bank");
        selfdestruct(payable(owner));
    }
    function NewAccount()public payable{
        require(accounts[msg.sender] == 0, "Account already exist");
        require(msg.value > 0 && msg.sender != address(0), "Value should not be 0 or Invalid address");
        accounts[msg.sender] = msg.value;
        if (count <= 4){
            accounts[msg.sender] += 1 ether;
            count++;
        }
    }
    function depositAmount(address _addr, uint _amount) public payable{
        require(_amount > 0 && _addr != address(0), "Value should not be 0 or Invalid address");
        accounts[_addr] += _amount;
        
    }
    function withDraw(uint amount)public payable{
        require(amount > 0 && msg.sender != address(0), "Value should not be 0 or Invalid address");
        require(amount <= accounts[msg.sender],"Invalid Bank account");
        payable(msg.sender).transfer(amount);
        accounts[msg.sender] -=amount;
    }
    function InquireBalance()public view returns(uint){
        return accounts[msg.sender];
    }
    function CloseAccount()public{
        require(msg.sender != address(0) && accounts[msg.sender] > 0,"Value should not be 0 or Invalid address");
        payable(msg.sender).transfer(accounts[msg.sender]);
        delete accounts[msg.sender];
    }
    function BankBalance()public view returns(uint){
        require(msg.sender == owner, "Only Owner can check the Balance");
        return address(this).balance;
    }
}

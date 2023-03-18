//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MappingStruct{

    struct Transaction{
        uint amount;
        uint timestamp;
    }

    struct Balance{
        uint totalBalance;
        uint numDeposits;
        mapping(uint => Transaction) deposits;
        uint numWithdrawals;
        mapping(uint => Transaction) withdrawals;
    }

    mapping(address => Balance) public balances;

    function depositMoney() public payable{
        balances[msg.sender].totalBalance += msg.value;
        Transaction memory deposit = Transaction(msg.value , block.timestamp); 
        balances[msg.sender].deposits[balances[msg.sender].numDeposits] = deposit;
        balances[msg.sender].numDeposits ++;
    }

    function withdrawMoney( address payable _to , uint _value) payable public{
        balances[msg.sender].totalBalance -= _value;
        Transaction memory withdrawal = Transaction(_value , block.timestamp);
        balances[msg.sender].withdrawals[balances[msg.sender].numWithdrawals] = withdrawal;
        balances[msg.sender].numWithdrawals++;
        _to.transfer(_value);
    }

    function getDepositInfo(address _add , uint _no) public view returns(Transaction memory) {
        return balances[_add].deposits[_no];
    }
}
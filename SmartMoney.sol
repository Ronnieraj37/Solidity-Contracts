//SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;
contract SendMoney{
    uint public balanceRecieved;
    function deposit() public payable{
        balanceRecieved += msg.value;
    }
    function getBalance() public view returns(uint){
        return address(this).balance;
    }
    function withdraw() public {
        address payable to = payable(msg.sender);
        to.transfer(getBalance());
    }
    function withdrawAddress(address payable to,uint val) public{
        to.transfer(val);
    }
}


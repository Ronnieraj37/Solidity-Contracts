//SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract Consumer{
    function getBalance() public view returns(uint){
        return address(this).balance;
    }
    function deposit() public payable{}
}

contract SmartWallet{
    address payable public owner;
    address payable public nextOwner;

    mapping (address => uint) public allowance;
    mapping (address => bool) public allowedToSend;
    mapping (address => bool) public guardians;
    mapping (address => mapping(address => bool)) guardianVotes;
    
    uint guardianResetCount;
    uint public constant confirmationsRequired = 3;

    constructor(){
        owner = payable(msg.sender);
    }

    function setAllowance(address _for , uint _amount) public {
        require(msg.sender == owner, "Only Owner can set");
        allowance[_for] += _amount;
        if( _amount > 0){
            allowedToSend[_for] = true;
        }
        else{
            allowedToSend[_for] = false;
        }
    }

    function setGaurdian(address _gaurdian, bool _isGaurdian) public {
        require(msg.sender == owner, "Only Owner can set");
        guardians[_gaurdian] = _isGaurdian;
    }

    function proposeNewOwner(address payable _newOwner) public {
        require(guardians[msg.sender],"Only Gaurdians Access this..");
        require(guardianVotes[_newOwner][msg.sender] == false,"No Votes Left..");

        if(_newOwner != nextOwner){
            nextOwner = _newOwner;
            guardianResetCount = 0;
        }

        guardianResetCount++;
        guardianVotes[_newOwner][msg.sender] = true;
        if(guardianResetCount >= confirmationsRequired){
            owner = nextOwner;
            nextOwner = payable(address(0));

        }
    }

    function transfer(address payable _to, uint _amount,bytes memory _payload)public returns(bytes memory){
        require(msg.sender == owner,"Only Owner Can Transfer Funds");
        if(msg.sender != owner){
            require(allowance[msg.sender]>=_amount, "Insufficient Funds");
            require(allowedToSend[msg.sender],"You are not allowed to send");
            allowance[msg.sender] -= _amount;
        }
        (bool success,bytes memory returnData) = _to.call{value: _amount}(_payload); 
        require(success,"Transaction Failed");
        return returnData;
    }

    receive() external payable{
        allowance[msg.sender] = msg.value;
        
    }
}
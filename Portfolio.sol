// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Portfolio{

    address public owner;

    constructor(){
        owner = msg.sender;
    }

    struct User{
        uint256 Id;
        bool isRegistered;
        string Name;
        string Username;
        address Address;
        string Image;
        string Email;
        string Location;
        string[] Links;
        uint256 numProjects;
        uint256 numEd;
        uint256 numEx;
    }

    struct EdEx{
        bool hide;
        string schoolPlace;
        string fieldRole;
        string startDate;
        string endDate;
        string location;
        string achievements;
        bool ongoing;
    }

    struct Projects{
        bool hide;
        string Title;
        string Description;
        string[] Links;
    }

    struct CustomSection{
        bool hide;
        string Title;
        string Description;
    }

    uint256 numProfiles = 1;
    mapping( address => User) public userData;
    mapping(string => address) public uniqueUser;
    mapping(address => EdEx) public education;
    mapping(address => EdEx) public experience;


    function addUser(string memory name, string memory username , string memory email, string memory location) public{
        require(userData[msg.sender].isRegistered == false ,"User Already Registered");
        require( uniqueUser[username] == 0x0000000000000000000000000000000000000000 , "UserName Already Taken" );
        userData[msg.sender].Id = numProfiles;
        userData[msg.sender].Name = name;
        userData[msg.sender].Username = username;
        userData[msg.sender].Address = msg.sender;
        userData[msg.sender].Email = email;
        userData[msg.sender].Location = location;
        userData[msg.sender].isRegistered = true;
        uniqueUser[username] = msg.sender;
        numProfiles++;
    }

    function editProfile(string memory name ,string memory email , string memory location ) public{
        userData[msg.sender].Name = name;
        userData[msg.sender].Email = email;
        userData[msg.sender].Location = location;
    }

    function getUser(string memory name) public view returns(User memory) {
        User memory user ;
        user = userData[uniqueUser[name]] ;
        return user;
    }

    function addLinks(string memory link) public{
        userData[msg.sender].Links.push(link);
    }
    function addImage(string memory hash) public {
        userData[msg.sender].Image = hash;
    }

}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract UserBase{
    struct Data{
        address sender;
        address acceptor;
        bool isAccepted;
        string statement;
        string category;
    }
    struct User{
        string name;
        string email;
        bool gender;//true for male
        string[] interests;
        Data[] info;
    }
    mapping(address => User) public users;
    function CheckUser() public view returns(bool){
        if(bytes(users[msg.sender].name).length==0){
            return false;
        }
        return true;
    }
    function addUser(string memory _name,string memory _email,bool _gender) external {
        require(!CheckUser(),"User already exists");
        users[msg.sender]=User(_name,_email,_gender,new string[](0),new Data[](0));
    }
    function addInterest(string memory _interest) external{
        require(CheckUser(),"User does not exist");
        users[msg.sender].interests.push(_interest);
    }
    function addCertifications(string memory _statement,string memory _category,address _acceptor) external{
        require(CheckUser(),"User does not exist");
        users[_acceptor].info.push(Data(msg.sender,_acceptor,false,_statement,_category));
    }
    function acceptCertifications(uint _index) external{
        require(CheckUser(),"User does not exist");
        require(users[msg.sender].info.length>_index,"Index out of bounds");
        require(users[msg.sender].info[_index].acceptor==msg.sender,"You are not the acceptor");
        users[users[msg.sender].info[_index].sender].info[_index].isAccepted=true;
    }
    function getInterests() external view returns(string[] memory){
        require(CheckUser(),"User does not exist");
        return users[msg.sender].interests;
    }
    function getCertifications() external view returns(Data[] memory){
        require(CheckUser(),"User does not exist");
        return users[msg.sender].info;
    }
    function getCertifications(address _user) external view returns(Data[] memory){
        require(CheckUser(),"User does not exist");
        return users[_user].info;
    }
    function getInterests(address _user) external view returns(string[] memory){
        require(CheckUser(),"User does not exist");
        return users[_user].interests;
    }
}
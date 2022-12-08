// SPDX-License-Identifier: unlicensed
pragma solidity >=0.5.0 <0.9.0;

contract MusicNFTContract {
    struct Event{
        address owner;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemain;
    }
    mapping(uint=>Event) public events;
    mapping(address=>mapping(uint=>uint)) public tickets;
    uint public nextId;

    function createEvent(string memory name,uint date,uint price,uint ticketCount) external{
        require(date>block.timestamp, "You can orgaize your event for future date");
        require(ticketCount>0, "you can organize event only if you create more than 0 tickets");
        
        events[nextId] = Event(msg.sender, name, date,price,ticketCount,ticketCount);
                nextId++;

    }

    function buyTicket(uint id,uint quantity) external payable{
        require(events[id].date!=0,"This events does not exist");
        require(events[id].date>block.timestamp,"Event has already occured");
        Event storage _event = events[id];
        require(msg.value==(_event.price*quantity),"ether is not enough");
        require(_event.ticketRemain>=quantity, "Not enough tickets");
        _event.ticketRemain-=quantity;
        tickets[msg.sender][id]+=quantity;

    }

    function transferTicket(uint id, uint quantity, address to) external {
        require(events[id].date!=0, "Event does not exist");
        require(events[id].date>block.timestamp, "Event has already occured");
        require(tickets[msg.sender][id]>=quantity, "you do not have enough ticket");
        tickets[msg.sender][id]-=quantity;
        tickets[to][id]+=quantity;
    }
}
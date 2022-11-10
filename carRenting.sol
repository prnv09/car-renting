//SPDX-License-Identifier:MIT
// other than the owner can rent a Car
// a person renting a Car will pay as per the usage ( 1ether per min )
// usage time will be calculated from rent start time - to rent end time
// a person can rent multiple Cars at a time ( optional )
// 1 Car can we rent by only one person at a time ( optional )

pragma solidity ^0.8.9;
contract rent{

    address payable public owner;
    uint startTime;
    uint totalTime;
    enum carStatus{available, rented}
    uint totalRent;
    struct car {
        uint carID;
        string carName;
        address rentedBy;
        uint startTime;
        carStatus checkAvailability;
    }
    struct carInfo{
        uint carID;
        string carName;
    }
    constructor(){
        owner =payable(msg.sender);       
    }
    carInfo[] carList;
    mapping (address => car)userStatus;
    mapping(uint =>  car) carMapping;
    modifier notOwner(){
       require(owner != msg.sender,"Owner can not rent his own car");
        _;
    }
    event carRented(address indexed renter,string name,uint id);
    event carParked(address indexed renter,string name,uint id,uint rent);
    event rentPaid(address indexed renter,string name,uint id, uint rent);

    function addCar(string memory _carName,uint _carID)public {
        car memory c;
        carInfo memory _carInfo;
        c.carName=_carName;
        c.carID=_carID;
        _carInfo.carName=_carName;
        _carInfo.carID=_carID;
        c.checkAvailability = carStatus.available;
        carList.push(_carInfo);
        carMapping[_carID] = c;
    }
    function CarList() public view returns (carInfo[] memory ){
        return carList;
    }
    
    function RentCar(uint _carID) public notOwner {

        require(carMapping[_carID].checkAvailability == carStatus.available,"This car is already rented by someone");
        carMapping[_carID].rentedBy = msg.sender;
        carMapping[_carID].startTime = block.timestamp;
        carMapping[_carID].checkAvailability = carStatus.rented;
        emit carRented(msg.sender,carMapping[_carID].carName,_carID);
    }

    function checkRent(uint _carID) public returns(uint){
        require(carMapping[_carID].rentedBy == msg.sender,"This car is not rented by you");
        totalTime = (block.timestamp - carMapping[_carID].startTime)/60;
        // carMapping[_carID].checkAvailability = carStatus.onHold;
        totalRent = (totalTime*1000000000000000000);
        emit carParked(msg.sender,carMapping[_carID].carName,_carID,totalRent);
        return totalRent;

    }

    function LeaveCar(uint _carID) public payable {
         require(carMapping[_carID].rentedBy == msg.sender,"This car is not rented by you");
         require(msg.value == totalRent,"Please enter correct amount of ether");
        //  require(carMapping[_carID].checkAvailability== carStatus.onHold,"Please Stop your car first");
         owner.transfer(msg.value);
         carMapping[_carID].checkAvailability = carStatus.available;
         emit rentPaid(msg.sender,carMapping[_carID].carName,_carID,totalRent);
         
    }


}
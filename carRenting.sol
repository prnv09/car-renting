//SPDX-License-Identifier:MIT
// other than the owner can rent a Car
// a person renting a Car will pay as per the usage ( 1ether per min )
// usage time will be calculated from rent start time - to rent end time
// a person can rent multiple Cars at a time ( optional )
// 1 Car can we rent by only one person at a time ( optional )

pragma solidity ^0.8.9;
contract rent{
    // string[3] car = ["1:Honda", "2:BMW", "3:Audi"];
    address payable public owner;
    uint startTime;
    uint totalTime;
    enum carStatus{available, rented,onHold}
    // carStatus public HondaStatus;
    // carStatus public BMWStatus;
    // carStatus public AudiStatus;
    struct car {
        uint carID;
        string carName;
        address rentedBy;
        uint startTime;
        carStatus checkAvailability;
    }
    constructor(){
        owner =msg.sender;       
    }
    car[] carList;
    mapping (address => car)userStatus;
    mapping(uint =>  car) carMapping;
    modifier notOwner(){
        owner != msg.sender;
        _;
    }

    function addCar(string memory _carName,uint _carID)public {
        car memory c;
        c.carName=_carName;
        c.carID=_carID;
        c.checkAvailability = carStatus.available;
        carList.push(c);
        carMapping[_carID] = c;
    }
    function CarList() public view returns (car[] memory ){
        return carList;
    }
    
    function RentCar(uint _carID) public {
        // if (_carname == bytes32("Honda")){
        //     HondaStatus=carStatus.rented;
        // }
        // if (_carname == bytes32("BMW")){
        //     BMWStatus=carStatus.rented;
        // }
        // if (_carname == bytes32("Audi")){
        //     AudiStatus=carStatus.rented;
        // }
        // startTime = block.timestamp;
        // userStatus[msg.sender]= _carname;
        
        require(carMapping[_carID].checkAvailability == carStatus.available,"This car is already rented by someone");
        carMapping[_carID].rentedBy = msg.sender;
        carMapping[_carID].startTime = block.timestamp;
        carMapping[_carID].checkAvailability = carStatus.rented;
    }

    function stopCar(uint _carID) public returns(uint){
        // require(userStatus[msg.sender]==_carname,"You not have rented this car");
        // totalTime=(block.timestamp - startTime)/60;
        require(carMapping[_carID].rentedBy == msg.sender,"This car is not rented by you");
        totalTime = (block.timestamp - carMapping[_carID].startTime)/60;
        carMapping[_carID].checkAvailability = carStatus.onHold;
        return totalTime;
    }

    function LeaveCar(uint _carID) public payable {
        // require(userStatus[msg.sender]==_carname,"You not have rented this car");
        // totalTime=(block.timestamp - startTime)/60;
        // require(msg.value==totalTime,"Please enter correct amount");
        // owner.transfer(totalTime);
        //  if (_carname == bytes32("Honda")){
        //     HondaStatus=carStatus.available;
        // }
        // if (_carname == bytes32("BMW")){
        //     BMWStatus=carStatus.available;
        // }
        // if (_carname == bytes32("Audi")){
        //     AudiStatus=carStatus.available;
        // }
         require(carMapping[_carID].rentedBy == msg.sender,"This car is not rented by you");
         require(msg.value == totalTime,"Please enter correct amount of ether");
         require(carMapping[_carID].checkAvailability== carStatus.onHold,"Please Stop your car first");
         owner.transfer(msg.value);
         carMapping[_carID].checkAvailability = carStatus.available;
         
    }


}
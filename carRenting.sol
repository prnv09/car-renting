//SPDX-License-Identifier:MIT
// other than the owner can rent a Car
// a person renting a Car will pay as per the usage ( 1ether per min )
// usage time will be calculated from rent start time - to rent end time
// a person can rent multiple Cars at a time ( optional )
// 1 Car can we rent by only one person at a time ( optional )

pragma solidity ^0.8.9;
contract rent{
    string[3] car = ["1:Honda", "2:BMW", "3:Audi"];
     address payable public owner;
    uint startTime;
    uint totalTime;
    enum carStatus{available, rented}
    carStatus public HondaStatus;
    carStatus public BMWStatus;
    carStatus public AudiStatus;
    mapping (address => bytes32)userStatus;
    function CarList() public view returns (string[3] memory ){
        return car;
    }

    function RentCar(bytes32 _carname) public {
        if (_carname == "Honda"){
            HondaStatus=carStatus.rented;
        }
        if (_carname == "BMW"){
            BMWStatus=carStatus.rented;
        }
        if (_carname == "Audi"){
            AudiStatus=carStatus.rented;
        }
        startTime = block.timestamp;
        userStatus[msg.sender]= _carname;
    }

    function stopCar(bytes32 _carname) public returns(uint){
        require(userStatus[msg.sender]==_carname,"You not have rented this car");
        totalTime=(block.timestamp - startTime)/60;
        return totalTime;

    }

    function LeaveCar(bytes32 _carname) public payable {
        require(userStatus[msg.sender]==_carname,"You not have rented this car");
        // totalTime=(block.timestamp - startTime)/60;
        require(msg.value==totalTime,"Please enter correct amount");
        

    }


}
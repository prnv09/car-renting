//SPDX-License-Identifier:MIT
// other than the owner can rent a Car
// a person renting a Car will pay as per the usage ( 1ether per min )
// usage time will be calculated from rent start time - to rent end time
// a person can rent multiple Cars at a time ( optional )
// 1 Car can we rent by only one person at a time ( optional )

pragma solidity ^0.8.9;
contract rent{
    string[3] car = ["Honda", "BMW", "Audi"];
     address payable public owner;
    uint startTime;
    enum carStatus 
    function CarList() public view returns (string[3] memory ){
        return car;
    }

    function RentCar(string memory _carname) public {

    }


}
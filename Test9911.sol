// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Inheritance {
    address owner;
    Heir[] public heirs;

    constructor() {
        owner = msg.sender;
    }

    // 1. เพิ่มเงินเข้าสมาร์ทคอนแทรกต์
    function addInheritance() payable public {}

    // 2. ดูยอดมรดกทั้งหมด
    function viewInheritance() public view returns (uint) {
        return address(this).balance;
    }

    // 3.1 นิยามโครงสร้าง Heir
    struct Heir {
        address payable walletAddress;
        string name;
    }

    // 3.2 เพิ่มผู้รับมรดก
    function addHeir(address payable walletAddress, string memory name) public {
        require(msg.sender == owner, "Only the owner can call this function");
        for (uint i = 0; i < heirs.length; i++) {
            require(heirs[i].walletAddress != walletAddress, "Heir already exists");
        }
        heirs.push(Heir(walletAddress, name));
    }

    // 4. ลบผู้รับมรดก
    function removeHeir(address payable walletAddress) public {
        require(msg.sender == owner, "Only the owner can call this function");
        for (uint i = 0; i < heirs.length; i++) {
            if (heirs[i].walletAddress == walletAddress) {
                heirs[i] = heirs[heirs.length - 1];
                heirs.pop();
                break;
            }
        }
    }

    // 5. ดูผู้รับมรดกทั้งหมด
    function viewHeirs() public view returns (Heir[] memory) {
        return heirs;
    }

    // 6. แจกจ่ายมรดก
    function distributeInheritance() public {
        require(address(this).balance > 0, "Insufficient balance in the contract");
        require(heirs.length > 0, "No heirs to distribute to");

        uint amount = address(this).balance / heirs.length;
        for (uint i = 0; i < heirs.length; i++) {
            transfer(heirs[i].walletAddress, amount);
        }
    }

    // ฟังก์ชันสำหรับโอนเงิน
    function transfer(address payable walletAddress, uint amount) internal {
        walletAddress.transfer(amount);
    }
}
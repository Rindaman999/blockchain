// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Inheritance {
    address public owner;
    address[] public beneficiaries;
    uint public lastLoginTime;
    uint public constant TIME_LIMIT = 5 minutes; // เวลาล็อกอิน
    uint public totalInheritance;

    event InheritanceDistributed(uint amountPerBeneficiary);
    event BeneficiaryAdded(address indexed beneficiary);
    event BeneficiaryRemoved(address indexed beneficiary);

    constructor() {
        owner = msg.sender;
        lastLoginTime = block.timestamp; // ตั้งเวลาเริ่มต้นเมื่อสร้าง contract
    }

    // ฟังก์ชันสำหรับเจ้าของล็อกอิน
    function login() public {
        require(msg.sender == owner, "Only the owner can log in");
        lastLoginTime = block.timestamp; // อัปเดตเวลาเมื่อเจ้าของล็อกอิน
    }

    // ฟังก์ชันสำหรับเพิ่มเงินเข้า contract
    function addFunds() external payable {}

    // ฟังก์ชันสำหรับตรวจสอบยอดเงินใน contract
    function viewBalance() public view returns (uint) {
        return address(this).balance;
    }

    // ฟังก์ชันสำหรับเพิ่มผู้รับมรดก
    function addBeneficiary(address beneficiary) public {
        require(msg.sender == owner, "Only the owner can add beneficiaries");
        require(beneficiary != address(0), "Invalid address");

        // ตรวจสอบว่าผู้รับมีอยู่แล้วหรือไม่
        for (uint i = 0; i < beneficiaries.length; i++) {
            require(beneficiaries[i] != beneficiary, "Beneficiary already exists");
        }

        beneficiaries.push(beneficiary);
        emit BeneficiaryAdded(beneficiary);
    }

    // ฟังก์ชันสำหรับลบผู้รับมรดก
    function removeBeneficiary(address beneficiary) public {
        require(msg.sender == owner, "Only the owner can remove beneficiaries");

        for (uint i = 0; i < beneficiaries.length; i++) {
            if (beneficiaries[i] == beneficiary) {
                beneficiaries[i] = beneficiaries[beneficiaries.length - 1]; // แทนที่ด้วยรายการสุดท้าย
                beneficiaries.pop(); // ลบรายการสุดท้าย
                emit BeneficiaryRemoved(beneficiary);
                return;
            }
        }
        revert("Beneficiary not found");
    }

    // ฟังก์ชันสำหรับตรวจสอบว่าควรแจกจ่ายมรดกหรือไม่
    function checkAndDistribute() public {
        require(block.timestamp >= lastLoginTime + TIME_LIMIT, "Owner is still active");

        uint amountPerBeneficiary = address(this).balance / beneficiaries.length;

        for (uint i = 0; i < beneficiaries.length; i++) {
            payable(beneficiaries[i]).transfer(amountPerBeneficiary);
        }

        emit InheritanceDistributed(amountPerBeneficiary);
    }

    // ฟังก์ชันสำหรับดูข้อมูลผู้รับ
    function viewBeneficiaries() public view returns (address[] memory) {
        return beneficiaries;
    }
}


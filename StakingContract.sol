// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transferFrom(address, address, uint) external returns (bool);
    function transfer(address, uint) external returns (bool);
}

contract StakingContract {
    IERC20 public immutable stakingToken;
    struct Stake {uint amount; uint timestamp;}
    mapping(address => Stake) public stakes;
    uint constant rewardRate = 10;

    constructor(address token) {stakingToken = IERC20(token);}

    function stake(uint amt) external {
        require(amt > 0 && stakingToken.transferFrom(msg.sender, address(this), amt), "Fail");
        Stake storage s = stakes[msg.sender];
        if (s.amount > 0) s.amount += calculateReward(msg.sender);
        s.amount += amt;
        s.timestamp = block.timestamp;
    }

    function unstake() external {
        Stake memory s = stakes[msg.sender];
        require(s.amount > 0, "Nothing");
        uint total = s.amount + calculateReward(msg.sender);
        delete stakes[msg.sender];
        require(stakingToken.transfer(msg.sender, total), "Fail");
    }

    function calculateReward(address user) public view returns (uint) {
        Stake memory s = stakes[user];
        if (s.amount == 0) return 0;
        return s.amount * rewardRate * (block.timestamp - s.timestamp) / (365 days * 100);
    }

    function getStake(address user) external view returns (uint amount, uint since) {
        Stake memory s = stakes[user];
        return (s.amount, s.timestamp);
    }
}

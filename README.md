This is a basic staking smart contract written in Solidity and compatible with the Monad blockchain (EVM-compatible).
What we can see there? 
1. User stakes tokens using `stake(amount)` (tokens are transferred to the contract)
2. When staking again or unstaking, any rewards are automatically calculated and added
3. On `unstake()`, the user gets the original amount + reward
4. Rewards are proportional to time staked
func there 
- `stake(uint256 amount)` — stake tokens
- `unstake()` — withdraw tokens + reward
- `calculateReward(address user)` — view your pending rewards
- `getStake(address user)` — see stake info (amount, timestamp)
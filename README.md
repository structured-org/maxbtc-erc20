# MaxBTCERC20

## Deployment instructions

### Step 1. Prepare

Run `bun install` to obtain dependencies. Then, run `forge build` to make sure contracts are able to be built successfuly. Finally, copy `.env.sample` to `.env` and fill it with your Etherscan API key and Ethereum private key (can be copied from Metamask, for example). Optionally, switch from Publicnode node to something else, at your preference.

Then, run `source .env`.

### Step 2. Deploy MaxBTCERC20 implementation contract

This contract will store vault source code and act behind a proxy, hence it is easy to deploy it. Simply run `forge script script/DeployMaxBTCERC20Implementation.script.sol --rpc-url "$ETHEREUM_RPC_URL" --private-key "$ETHEREUM_PRIVATE_KEY" --broadcast --verify -vvvv` and write down the final contract address, you will need it in the next step.

### Step 3. Deploy MaxBTCERC20

Run `OWNER="" IMPLEMENTATION="" ICS20="" TOKEN_NAME="" TOKEN_SYMBOL="" forge script script/DeployMaxBTCERC20.script.sol --rpc-url "$ETHEREUM_RPC_URL" --private-key "$ETHEREUM_PRIVATE_KEY" --broadcast --verify -vvvv`, where:
- `OWNER` must be set to account address, which will become a `MaxBTCERC20` admin;
- `IMPLEMENTATION` must be set to the contract address, obtained in step 2;
- `ICS20` must be set to the `ICS20Transfer` contract address (`0xa348CfE719B63151F228e3C30EB424BA5a983012` on Ethereum Mainnet);
- `TOKEN_NAME` is an ERC20 token name;
- `TOKEN_SYMBOL` is an ERC20 token symbol.

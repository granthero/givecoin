# Give Coin
Give Coin is the official coin for charitable giving and the non-profit industry.

Scope
- ERC223 token creation based upon Ethereum

- A protocol with special event creation to anchor giving data to a blockchain specifically targeted for the non-profit sector. This includes:

  1. Timestamp
  2. Donor Address
  3. Donor Name
  4. Amount
  5. Recipient Address
  6. Recipient Name
  
- Token crowdsale parameters based upon the following:
  1. Token Supply:  Fixed at 50M (Non-mineable)
  2. Crowdsale Supply:  25M (50%)
  3. Max Cap = 25M
  4. 1 GIVE Coin = $1.0 USD
  5. Purchase Methods = ETH
  6. Minimum Contribution Amount = 0.01 ETH
  7. Duration = 30 Days starting 10/2
  
-  For more details regarding the GIVE Coin including the crowdsale, utility, and ecosystem, please view the whitepaper located here:  https://docs.google.com/document/d/1CIwDHv7pg97ZBLzup-Xq84GSAp3Dx4HEVNj0j5CrnXs/edit?usp=sharing

# Testnet

The whole contract system is already operationable. It is currently deployed on Rinkeby testnet:

Crowdsale contract: [0x15c7300ccddb850842a989dee9464e4ded3698fd](https://rinkeby.etherscan.io/address/0x15c7300ccddb850842a989dee9464e4ded3698fd)

Token contract: [0x5a6a18008afaaacebb4c9b85d333de390f7cf4c2](https://rinkeby.etherscan.io/address/0x5a6a18008afaaacebb4c9b85d333de390f7cf4c2)

Database contract: [0x12f1f915f00a8b51f61b4220983bfa9fbf99755f](https://rinkeby.etherscan.io/address/0x12f1f915f00a8b51f61b4220983bfa9fbf99755f)

## Getting Started

To contribute to Give Coin crowdsale you should just send ETH into the crowdsale contract address. 100 000 GAS is required.

MyEtherWallet could be used to send the transaction:

![alt text](https://github.com/granthero/givecoin/blob/master/HOWTO/HOWTO-1.jpg)

To watch the token on MyEtherWallet you need to add it to your token list. Press "Add Custom Token" button and insert token contract address (0x5a6a18008afaaacebb4c9b85d333de390f7cf4c2 on Rinkeby), token symbol (anything you like) and token decimals ( `2` ) then press "Save" button.

![alt text](https://github.com/granthero/givecoin/blob/master/HOWTO/HOWTO-2.jpg)

Test Private Key: `1234560000000000000000000000000000000000000000000000000000000fff`
Test Address:     `0xCa9622A798CCD9855558E75560C1052862EEf18E`

## Making a Donation

The `donate` function should be executed to submit an official donation.

You can execute it via MyEtherWallet web interface. You need to access "Contracts" tab and insert token contract address and its ABI.

Token contract address is `0x5a6a18008afaaacebb4c9b85d333de390f7cf4c2` on Rinkeby.
Token contract ABI can be found [here](https://github.com/granthero/givecoin/blob/master/ABIs/token.abi).

Copy and Paste token ABI and address as follows, then press "Access" button:

![alt text](https://github.com/granthero/givecoin/blob/master/HOWTO/HOWTO-3.jpg)

Selec the `donate` function. The function works as ERC223 transfer with additional special event to anchor Donor and Recipient data to the blockchain.

- `_to` parameter is an address of the recipient.
- `_value` is an amount of tokens you would like to donate.
- `_data` is a special data of ERC223 token transfer. Leave it empty.
- `_donor` is a name of donor.
- `_recipient` is a name of the recipient.

![alt text](https://github.com/granthero/givecoin/blob/master/HOWTO/HOWTO-4.jpg)

To watch the donation you should access transaction event logs.
Example donation transaction on Rinkeby can be found [by this link](https://rinkeby.etherscan.io/tx/0x47f338560459f96eb7fc5aa270997e575198d4fbf33386345eaad3a8be3794e4#eventlog).

Donor and recipient names could be accessed as hex-encoded string values of the event topic `0xfd25b07f10b1223eefa1bfa653ba0829d1f27af024473ed776abeb44b46cee61`.

![alt text](https://github.com/granthero/givecoin/blob/master/HOWTO/HOWTO-5.jpg)

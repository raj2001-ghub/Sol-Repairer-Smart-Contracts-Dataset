# Sol-Repairer : Solidity Smart Contract Dead Code Repairer

This repository contains the 50 smart contracts along with the results obtained by using our tool Sol-Repairer. The raw smart contracts were taken from Etherscan and then random instances of dead code were inserted in them, to test the effectiveness of our model.

The smart contracts are stored in the directory `Contracts/<smart_contract_name.sol>`
The results of each of the smart contracts after using our tool Sol-Repairer is in directory `results/<result-smart_contract_name>/`
The results for the optimized files after using solc optimization but not using our tool Sol-Repairer is stored in directory `solc-optimization-results/<smart_contract_name>/Unrepaired/<smart_contract_name.bin>`
The results for the optimized files after using solc optimization and using our tool Sol-Repairer is stored in directory `solc-optimization-results/<smart_contract_name>/Repaired/<smart_contract_name.bin>`

These results are presented and discussed in our research paper submitted that is titled `Sol-Repairer : Solidity Smart Contract Dead Code Repairer`

## Structure of the repository

```
│
├─ Contracts
│ └─ <smart_contract_name>.sol
|
├─ results
│ └─ <result-smart_contract_name>
│    ├─ <repaired>.sol # smart contract with dead code commented out
│    └─ <repaired_deleted>.sol # smart contract with dead code deleted out
│
└─ solc-optimization-results
   └─ <smart_contract_name>
      │
      ├─ <Unrepaired>
      │  └─<smart_contract_name>.bin # binary files in byte code for smart contracts which are optimized only by Solc
      │
      └─ <Repaired>
         └─<smart_contract_name>.bin # binary files in byte code for smart contracts which are optimized only by Solc and further improved by Sol-Repairer

```

## Generating Results From Smart Contracts

We obtain the repaired files from the smart contracts by running our code on the original smart contract. Upon running our algorithm on the original smart contract we are able to identify the dead code segment and selectively either comment it out or delete it. Deletion is done to provide further bytecode optimization. After the files are generated the repaired smart contract in which dead code is deleted and original smart contract is compared. For each of the smart contract we execute the following set of commands to get our result.

```
./assertionInjector <smart_contract_name>
./asserter.sh <smart_contract_name>
cd <result-smart_contract_name>
python detector.py
./Repairer

```

## Comparing optimization results with Solc

Once we obtain the repaired smart contract we execute a command to get the binary file. The binary file for the optimized smart contract is stored in the respective folder. In the folder Unrepaired we store the binary files for all the smart contracts using solc optimization and our Sol-Repairer was not used. In the folder Repaired we store the binary files for all the smart contracts where our Sol-Repairer was used along with solc optimization. We compare the sizes of both the binary files and then draw our observation. The command used to obtain the binary file for the optimized smart contract is

```
solc --bin --optimize <smart_contract_name>.sol

```

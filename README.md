# data_storing_via_blockchain
In this flutter app, you can choose the file you want to store, and people you want to sign an agreement with. 

After you fill up all the spaces, click the submit buttom, then your file will transfer to json file stored on [IPFS](https://ipfs.tech/). And [solidity contract](./blockChain/fileStore.sol) will take this json file as input to mint a NFT. 

File in IPFS has properties below:
1. Uniqueness: Each file has its own hash number, there is no two files have the same hash number in IPFS.
2. Immutable: As soon as file is uploaded to IPFS, it has no way to change the content in the file.


If you come across legal disputes in the future, with the help of IPFS, you can access the file much more conveniently, and you can assure the file on IPFS is not tampered by anyone.

## Usage

1. Clone the repository:
```
git clone https://github.com/cy0802/data_storing_via_blockchain.git
```

2. Install the required packages:
```
cd <flutter_app_folder>
flutter pubget
```

3. Open emulator:
    1. Open Android Studio 
    2. Click on More Actions icon in the top toolbar 
    3. Click Virtual Device Manager 
    4. Click "Launch this AVD in the emulator"

4. Run app:
```
flutter run
```
5. Start the app
- Perserve file on the block_chain:
    1. Click the "Submit Contract" button
    2. choose a file
    3. Type your name
    4. Type another signer's name
    5. Type another signer's email
    6. Press the submit button
    
- History contract:
In the history contract, there are two options in the top toolbar, "Wait to be upload" and "Uploaded". There are 4 states shown on the right side of each contract:
    1. Wait for agreement
    2. Agree
    3. Wait for uploaded
    4. Upload

- You can deploy contract on IPFS follow the steps below:
1. For receiver side:
    1. Click the contract of "agree" state
    2. Get into the contract info screen, and Check the box whcih says "I Confirm the correctness of the contract"
    3. Click the brown button whcih says "I agree" 
    4. Then contract will show up "Agreed" 

2. Wait for upload of sender side: 
    1. Click the contract of "Upload" state
    2. Get into the contract info screen, and check the box whcih says "I agree to upload the contract to blockchain"
    3. Click the brown button whcih says "Upload"
    4. Then contract will show up in "Uploaded"

- Uploaded Contract: 
You can see all your contracts being uploaded in the "uploaded" screen!

## Install
**_This is for Windows_**

1. Install flutter: 
Go to [this web page](https://docs.flutter.dev/get-started/install), choose you're os. Scroll down until find Get the Flutter SDK, click the installation file.

2. Change evironment variables:
Open the Start menu and search for "Environment Variables" -> Click on "Add" of the user environment variables -> Click on the "Environment Variables" buttom -> Choose the path of flutter bin folder -> Click "OK" to save change.

3. flutter doctor: 
Open terminal, run `flutter doctor` Install the required software and agree to the terms for Flutter according to the command in terminal. 

4. Install Android Emulator
    1. Open Android Studio
    2. Click on More Actions icon in the top toolbar 
    3. Click Virtual Device Manager 
    4. Click create device in the top toolbar 
    5. Choose one emulator and keep clicking "Next" to install it 
    6. Click "Finish" to accomplish installation

## License

ISC

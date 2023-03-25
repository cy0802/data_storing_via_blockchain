import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter_ipfs/flutter_ipfs.dart';
import 'protectedInfo.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:flutter/services.dart';

class ArtWork {
  String title;
  Size artSize;
  int backgroundIndex;
  int forgroundIndex;
  int radiusIndex;

  ArtWork(
      {this.title = 'Generate art',
      this.artSize = const Size(500, 1000),
      this.backgroundIndex = 0,
      this.forgroundIndex = 2,
      this.radiusIndex = 5});
}

Future<Uint8List> getPng(ArtWork artWork) async {
  ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  Canvas canvas = Canvas(pictureRecorder,
      Rect.fromLTWH(0, 0, artWork.artSize.width, artWork.artSize.height));
  drawArt(artWork, canvas, artWork.artSize);
  final ui.Picture picture = pictureRecorder.endRecording();
  ui.Image img = await picture.toImage(
      artWork.artSize.width.toInt(), artWork.artSize.height.toInt());
  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  Uint8List pngBytes = byteData!.buffer.asUint8List();
  return pngBytes;
}

void drawArt(ArtWork artWork, Canvas canvas, Size size) {
  canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
  List<Color> colorValues = Colors.primaries;
  Color bgColor = colorValues[artWork.backgroundIndex];
  canvas.drawColor(bgColor, BlendMode.src);
  Offset center = Offset(size.width / 2, size.height / 2);
  double radius = size.width * artWork.radiusIndex.toDouble() / 20.0;
  Color fgColor = colorValues[artWork.forgroundIndex];
  Paint paint = Paint()..color = fgColor;
  canvas.drawCircle(center, radius, paint);
}

// return the path of the json file
Future<List<String>> generateNFT(
    // return jsonPath, cidOfImg
    String contractCid,
    String email1,
    String email2) async {
  ArtWork artWork = ArtWork();
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;
  int numberOfColors = Colors.primaries.length;
  var random = Random();
  artWork.title = 'Circle';
  artWork.backgroundIndex = random.nextInt(numberOfColors);
  artWork.forgroundIndex = random.nextInt(numberOfColors);
  while (artWork.forgroundIndex == artWork.backgroundIndex) {
    artWork.forgroundIndex = random.nextInt(numberOfColors);
  } // Avoid having the same forground and background color
  artWork.radiusIndex = random.nextInt(10) + 1;
  // Here you should check that the artwork is unique
  Uint8List pngBytes = await getPng(artWork);
  var myFile = File("$appDocPath/${artWork.title}.png");
  myFile.writeAsBytesSync(pngBytes);
  var cidOfImage =
      await FlutterIpfs().uploadToIpfs("$appDocPath/${artWork.title}.png");
  debugPrint("generateNFT.dart: NFTImgPath: ${myFile.path}");
  String traits =
      '[{"trait_type":"BgColor","value": "${artWork.backgroundIndex}"},'
      '{"trait_type":"FgColor","value": "${artWork.forgroundIndex}"},'
      '{"trait_type":"Radius","value": "${artWork.radiusIndex}"}]';
  String nftJson = '{"name": "${artWork.title}",'
      '"description": "This is a circle",'
      '"image": "ipfs://$cidOfImage",'
      '"attributes": $traits,'
      '"cidOfContract": "$contractCid"}';
  myFile = File("$appDocPath/${artWork.title}.json");
  myFile.writeAsStringSync(nftJson);
  return Future.value(["$appDocPath/${artWork.title}.json", cidOfImage]);
}

/*class BlockChain {
  static Client httpClient = Client();
  static Web3Client ethClient = Web3Client(rpcEndPoint, httpClient);
}*/

Future<DeployedContract> getContract() async {
  const name = "";
  const address = contractAddress;
  String abi = await rootBundle.loadString("assets/fileStore.abi");
  DeployedContract contract = DeployedContract(
    ContractAbi.fromJson(abi, name),
    EthereumAddress.fromHex(address),
  );
  return contract;
}

Future<String> mint(String jsonPath) async {
  var cidOfJson = await FlutterIpfs().uploadToIpfs(jsonPath);
  String url = "ipfs://$cidOfJson";
  var fromAddress = EthereumAddress.fromHex(walletAddress);
  // error msg: Unhandled Exception: RPCError: got code -32000 with msg "insufficient funds for gas * price + value"
  // value要填寫account全部有的錢，可以稍微少一點，1ETH = 10^18 Wei，填的數字都要是偶數
  //var value = EtherAmount.inWei(BigInt.from(400000));
  //var gasPrice = EtherAmount.inWei(BigInt.from(200000));
  //var gasLimit = 21000;
  var smartContract = await getContract();
  ContractFunction function = smartContract.function('mint');
  var transaction = Transaction(
      from: fromAddress,
      to: smartContract.address,
      //value: value,
      //gasPrice: gasPrice,
      //maxGas: gasLimit,
      data: Transaction.callContract(
          contract: smartContract, function: function, parameters: [url]).data
  );
  Credentials credentials = EthPrivateKey.fromHex(privateKey);
  var httpClient = Client();
  var client = Web3Client(rpcEndPoint, httpClient);
  String transactionHash = "";
  await client
      .sendTransaction(
    credentials,
    transaction,
    chainId: 5,
  )
      .then((s) {
    debugPrint(s);
    transactionHash = s;
  });
  if (transactionHash != "") {
    return transactionHash;
  } else {
    return "fail";
  }
}

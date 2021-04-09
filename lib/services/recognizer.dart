import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:myapp/utils/constants.dart';
import 'package:tflite/tflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import'package:image/image.dart' as img;
final _canvasCullRect = Rect.fromPoints(
  Offset(0, 0),
  Offset(Constants.imageSize, Constants.imageSize),
);

final _whitePaint = Paint()
  ..strokeCap = StrokeCap.round
//  ..color = Colors.white
  ..color = Colors.black
  ..strokeWidth = Constants.strokeWidth;

final _bgPaint = Paint()
//  ..color = Colors.black;
  ..color = Colors.white;

class Recognizer {
  Future loadModel() {
    Tflite.close();

    return Tflite.loadModel(
      model: "assets/baybayin_ver4.tflite",
      labels: "assets/labelsver4.txt",
    );
  }

  dispose() {
    Tflite.close();
  }

  Future<Uint8List> previewImage(List<Offset> points) async {
    final picture = _pointsToPicture(points);
    final image = await picture.toImage(Constants.mnistImageSize, Constants.mnistImageSize);
    var pngBytes = await image.toByteData(format: ImageByteFormat.png);

    return pngBytes.buffer.asUint8List();
  }

  Future recognize(List<Offset> points) async {
    final picture = _pointsToPicture(points);
   // Uint8List bytes = await _imageToByteListUint8(
    //    picture, Constants.mnistImageSize);
   // print(bytes);
   // print("predictions");
   final _image = await picture.toImage(Constants.mnistImageSize, Constants.mnistImageSize);
    var _pngBytes = await _image.toByteData(format: ImageByteFormat.png);
 print(_pngBytes);
    File _image12= await writeToFile(_pngBytes);
    var bytes = await _imageToByteListUint8(_image12, 96);
        
print(bytes);
  print("predictions");
  return await _predict(bytes);

  }




  Future<Uint8List> _imageToByteListUint8(File file, int size) async {
   var bytes = file.readAsBytesSync();
   var decoder = img.findDecoderForData(bytes);
   img.Image image = decoder.decodeImage(bytes);
  
    final resultBytes = Float32List(size * size);
    final buffer = Float32List.view(resultBytes.buffer);

    int index = 0;
  //var convertedBytes = Uint8List(1 * size * size* 3);
  //  var buffer = Uint8List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < size; i++) {
      for (var j = 0; j < size; j++) {
        var pixel = image.getPixel(j, i);
        final r = img.getRed(pixel);
        final g = img.getGreen(pixel);
        final b = img.getBlue(pixel);
      //  buffer[pixelIndex++] = img.getBlue(pixel);
//        buffer[pixelIndex++] = (r + g + b) / 3.0 / 255.0;
      
        buffer[pixelIndex++] = (r + g + b) / 3.0;
      }
    }
    return resultBytes.buffer.asUint8List();
  }







  Future<File> writeToFile(ByteData data) async{
    final buffer = data.buffer;
   
    Directory directory = await getExternalStorageDirectory(); 
    String tempPath = directory.path;
    const directoryName = "Hand";
    await Directory('$tempPath/$directoryName').create(recursive: true);
   String pathFile = "$tempPath/$directoryName/image1.png";
  File("$tempPath/$directoryName/image1.png").writeAsBytesSync(data.buffer.asUint8List());
  img.Image imag = img.decodeImage(File("$tempPath/$directoryName/image1.png").readAsBytesSync());
 File("$tempPath/$directoryName/image1.png").writeAsBytesSync(img.encodePng(imag));
 return File("$tempPath/$directoryName/image1.png");
  }






/*
  Future _predict(Uint8List bytes) {
    return Tflite.runModelOnBinary(binary: bytes);
  }

  */
  
  

  Future _predict(var bytes) async { 
  return Tflite.runModelOnBinary(binary: bytes,
  threshold: 0.5);
// print(image.path);
 //String path_ ="/storage/emulated/0/Android/data/com.example.myapp/files/Hand/image1.png";

  }

  
  
  Picture _pointsToPicture(List<Offset> points) {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder, _canvasCullRect)
      ..scale(Constants.mnistImageSize / Constants.canvasSize);

    canvas.drawRect(
        Rect.fromLTWH(0, 0, Constants.imageSize, Constants.imageSize),
        _bgPaint);

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], _whitePaint);
      }
    }

    return recorder.endRecording();
  }
}
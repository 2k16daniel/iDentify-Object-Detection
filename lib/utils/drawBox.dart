import 'package:flutter/material.dart';
import 'dart:math' as math;

class drawBox extends StatelessWidget {
  final List<dynamic> results;
  final int viewHeight;
  final int viewWidth;
  final double psH;
  final double psW;

  drawBox(
    this.results,
    this.viewHeight,
    this.viewWidth,
    this.psH,
    this.psW,
  );

  @override
  Widget build(BuildContext context) {
    List<Widget> _DRAW_THE_GODAMN_BOX() {
      return results.map((re) {
        var _x = re["rect"]["x"];
        var _w = re["rect"]["w"];
        var _y = re["rect"]["y"];
        var _h = re["rect"]["h"];
        var scaleW, scaleH, x, y, w, h;

        if (psH / psW > viewHeight / viewWidth) {
          scaleW = psH / viewHeight * viewWidth;
          scaleH = psH;
          var difW = (scaleW - psW) / scaleW;
          x = (_x - difW / 2) * scaleW;
          w = _w * scaleW;
          if (_x < difW / 2) w -= (difW / 2 - _x) * scaleW;
          y = _y * scaleH;
          h = _h * scaleH;
        } else {
          scaleH = psW / viewWidth * viewHeight;
          scaleW = psW;
          var difH = (scaleH - psH) / scaleH;
          x = _x * scaleW;
          w = _w * scaleW;
          y = (_y - difH / 2) * scaleH;
          h = _h * scaleH;
          if (_y < difH / 2) h -= (difH / 2 - _y) * scaleH;
        }

        return Positioned(
          left: math.max(0, x),
          top: math.max(0, y),
          width: w,
          height: h,
          child: Container(
            padding: EdgeInsets.only(top: 5.0, left: 5.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromRGBO(37, 213, 253, 1.0),
                width: 3.0,
              ),
            ),
            child: Text(
              "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
              style: TextStyle(
                color: Color.fromRGBO(37, 213, 253, 1.0),
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList();
    }

    return Stack(
      children: _DRAW_THE_GODAMN_BOX(),
    );
  }
}

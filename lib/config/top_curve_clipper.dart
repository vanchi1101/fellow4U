import 'package:flutter/material.dart';

class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // bắt đầu từ góc dưới trái
    path.moveTo(0, size.height);

    // lên cạnh trái
    path.lineTo(0, 60);

    // vẽ đường cong phía trên
    path.quadraticBezierTo(
      size.width / 2,
      0, // điểm điều khiển (đỉnh cong)
      size.width,
      60, // điểm kết thúc bên phải
    );

    // xuống cạnh phải
    path.lineTo(size.width, size.height);

    // đóng đáy
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

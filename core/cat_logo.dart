import 'package:flutter/material.dart';
import 'theme.dart';

//لسا هغير الالوان يا عيال متتخضوش انتو اشتغلو بالالوان اللي اتفقنا عليها 
class CatLogo extends StatelessWidget {
  const CatLogo({
    super.key,
    this.size = 64,
    this.head = AppColors.ink,
    this.face = AppColors.cream,
  });

  final double size;
  final Color head;
  final Color face;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size * 28 / 30),
      painter: _CatPainter(head, face),
    );
  }
}

class _CatPainter extends CustomPainter {
  _CatPainter(this.head, this.face);
  final Color head;
  final Color face;

  @override
  void paint(Canvas canvas, Size s) {
    canvas.save();
    canvas.scale(s.width / 30, s.height / 28);

    final headPath = Path()
      ..moveTo(3, 4)
      ..lineTo(9, 9)
      ..lineTo(21, 9)
      ..lineTo(27, 4)
      ..lineTo(27, 18)
      ..arcToPoint(const Offset(18, 26), radius: const Radius.circular(9), clockwise: true)
      ..lineTo(12, 26)
      ..arcToPoint(const Offset(3, 18), radius: const Radius.circular(9), clockwise: true)
      ..close();
    canvas.drawPath(headPath, Paint()..color = head);

    final facePath = Path()
      ..moveTo(8, 17)
      ..cubicTo(8, 13, 22, 13, 22, 17)
      ..cubicTo(22, 21, 19, 24, 15, 24)
      ..cubicTo(11, 24, 8, 21, 8, 17)
      ..close();
    canvas.drawPath(facePath, Paint()..color = face);

    final eye = Paint()..color = AppColors.olive;
    canvas.drawCircle(const Offset(11, 14), 1.6, eye);
    canvas.drawCircle(const Offset(19, 14), 1.6, eye);

    final nose = Path()
      ..moveTo(14, 18)
      ..lineTo(16, 18)
      ..lineTo(15, 19.6)
      ..close();
    canvas.drawPath(nose, Paint()..color = AppColors.pink);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CatPainter old) => old.head != head || old.face != face;
}

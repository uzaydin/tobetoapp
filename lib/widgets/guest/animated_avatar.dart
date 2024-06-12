import 'package:flutter/material.dart';

// Anasayfa - öğrenci görüşleri kısmı için

class AnimatedAvatar extends StatefulWidget {
  final bool isSelected;
  const AnimatedAvatar({
    super.key,
    this.isSelected = false,
  });

  @override
  State<AnimatedAvatar> createState() => _AnimatedAvatarState();
}

class _AnimatedAvatarState extends State<AnimatedAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: -10.0,
      end: 10.0,
    ).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: widget.isSelected
                ? Colors.green.shade300
                : const Color.fromARGB(255, 151, 191, 224),
            child: const Icon(
              Icons.person,
              size: 60,
              color: Color.fromARGB(255, 201, 189, 189),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}



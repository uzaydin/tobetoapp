import 'package:flutter/material.dart';
import 'package:tobetoapp/models/class_model.dart';

class ClassTile extends StatelessWidget {
  final ClassModel classModel;
  final Function(BuildContext, String) onDetailsPressed;
  final Function(BuildContext, ClassModel) onEditPressed;
  final Function(BuildContext, String) onLongPress;

  const ClassTile({
    super.key,
    required this.classModel,
    required this.onDetailsPressed,
    required this.onEditPressed,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(classModel.name!),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                child: const Text("Detaylar"),
                onPressed: () => onDetailsPressed(context, classModel.id!),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => onEditPressed(context, classModel),
              ),
            ],
          ),
          onLongPress: () => onLongPress(context, classModel.id!),
        ),
        const Divider(
          thickness: 1, // Çizginin kalınlığı
          color: Colors.grey, // Çizginin rengi
        ),
      ],
    );
  }
}
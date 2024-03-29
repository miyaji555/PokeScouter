import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// ダイアログ
Future<void> showTextDialog(
  BuildContext context, {
  required String title,
  String? message,
}) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: SelectableText(
          title,
        ),
        content: message != null
            ? SelectableText(
                message,
              )
            : null,
        actions: <Widget>[
          TextButton(
            child: const Text(
              'OK',
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> showConfirmDialog({
  required BuildContext context,
  required String title,
  String? message,
  required String okText,
  String cancelText = 'やめとく。',
  required Function function,
}) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: SelectableText(
          title,
        ),
        content: message != null
            ? SelectableText(
                message,
              )
            : null,
        actions: [
          TextButton(
            child: Text(
              cancelText,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(
              okText,
            ),
            onPressed: () async {
              final navigator = Navigator.of(context);
              await function();
              navigator.pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> showTextFieldDialog({
  required BuildContext context,
  required String title,
  String? message,
  required okText,
  required Function(String title) function,
}) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return TextFieldDialog(
        title: title,
        okText: okText,
        function: function,
      );
    },
  );
}

class TextFieldDialog extends HookWidget {
  const TextFieldDialog(
      {super.key,
      required this.title,
      required this.okText,
      required this.function});

  final String title;
  final String okText;
  final String cancelText = 'やめとく。';
  final Function(String title) function;

  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController =
        useTextEditingController();
    final isFieldEmpty = useState(true);
    useEffect(() {
      textEditingController.addListener(() {
        isFieldEmpty.value = textEditingController.text.isEmpty;
      });
      return null;
    }, [textEditingController]);
    return AlertDialog(
      title: Text(title),
      content: TextField(
        controller: textEditingController,
      ),
      actions: [
        TextButton(
          child: Text(
            cancelText,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          onPressed: isFieldEmpty.value
              ? null
              : () async {
                  final navigator = Navigator.of(context);
                  await function(textEditingController.value.text);
                  navigator.pop();
                },
          child: Text(
            okText,
          ),
        ),
      ],
    );
  }
}

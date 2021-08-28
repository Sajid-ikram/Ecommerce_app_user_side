import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Services/warning.dart';

class ErrorDialog extends StatefulWidget {
  const ErrorDialog({Key? key}) : super(key: key);

  @override
  _ErrorDialogState createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ErrorDialog> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Warning>(
      builder: (context, provider, child) {
        return provider.warningModel.show
            ? Container(
                height: 50,
                decoration: BoxDecoration(
                  color: provider.warningModel.color,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: provider.warningModel.color == Colors.green
                          ? Icon(Icons.check)
                          : Icon(Icons.error_outline),
                    ),
                    Expanded(child: Text(provider.warningModel.massage)),
                    GestureDetector(
                      onTap: () {
                        Provider.of<Warning>(context, listen: false)
                            .showWarning(provider.warningModel.massage,
                                provider.warningModel.color, false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox();
      },
    );
  }
}

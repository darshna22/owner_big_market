import 'package:flutter/material.dart';

class LoadingOverlay {
  BuildContext _context;

  Future<T> during<T>(Future<T> future) {
    show();
    return future.whenComplete(() => hide());
  }

  void hide() {
    Navigator.of(_context).pop();
  }

  void show() {
    showDialog(
        context: _context,
        barrierDismissible: false,
        builder: (ctx) => _FullScreenLoader());
  }



  LoadingOverlay._create(this._context);

  factory LoadingOverlay.of(BuildContext context) {
    return LoadingOverlay._create(context);
  }
}

class _FullScreenLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.5)),
        child: const Center(child: CircularProgressIndicator()));
  }
}

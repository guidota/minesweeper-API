import 'package:flutter/material.dart';

class NewGamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Game"),
      ),
      body: Container(
        child: Column(
          children: [
            Text("Mines"),
            Form(
              child: TextFormField(
                keyboardType: TextInputType.number,
                validator: (value) {
                  try {
                    int.parse(value);
                    return null;
                  } catch (_) {
                    return 'Please enter some number';
                  }
                },
              ),
            ),
            Text("Rows"),
            Form(
              child: TextFormField(
                keyboardType: TextInputType.number,
                validator: (value) {
                  try {
                    int.parse(value);
                    return null;
                  } catch (_) {
                    return 'Please enter some number';
                  }
                },
              ),
            ),
            Text("Columns"),
          ],
        ),
      ),
    );
  }
}

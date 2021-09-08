import 'package:flutter/material.dart';

class NoData extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.cancel_outlined, size: MediaQuery.of(context).size.width*0.3,),
        SizedBox(height: 20),
        Text('No Joke Here', style: TextStyle(fontSize: 20),),
      ],
    );
  }
}

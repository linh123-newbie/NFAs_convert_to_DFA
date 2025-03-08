import 'package:flutter/material.dart';

class InputForm extends StatefulWidget{
  final String? textTitle ;
  final TextEditingController textController;
  InputForm({Key? key, this.textTitle, required this.textController});
  @override
  _InputFormState createState()=>_InputFormState();
}
class _InputFormState extends State<InputForm>{
  
  
  @override
  Widget build(BuildContext context){
    return Container(
      width: MediaQuery.sizeOf(context).width*0.7,
      // height: 70,
      child: TextField(
      controller: widget.textController,
      decoration: InputDecoration(
        label: Text(widget.textTitle??''),
        // floatingLabelBehavior: FloatingLabelBehavior.never,
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
        fillColor: Colors.white,
        filled: true
      ),
      
      keyboardType: TextInputType.number,
    ),
    );
  }


}
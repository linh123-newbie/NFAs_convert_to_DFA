import 'package:flutter/material.dart';
import 'test1.dart';

class DFAConverterPage extends StatefulWidget {
  Set<int> states;
  Set<String> alphabet;
  Map<int, Map<String, Set<int>>> transition;
  int startState;
  Set<int> endState;
  DFAConverterPage(
      {super.key,
      required this.states,
      required this.alphabet,
      required this.transition,
      required this.startState,
      required this.endState});

  @override
  _DFAConverterPageState createState() => _DFAConverterPageState();
}

class _DFAConverterPageState extends State<DFAConverterPage> {
  String state = "";
  String alphabetString = "";
  String start_state = "";
  String end_state = "";
  Map<int, Map<String, int>> transition_state = {};
  List<String> columnHeaders = [];
  Map<int, Set<int>> convert_state = {};
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      convert();
    });
  }

  void convert() {
  
    NFAe nfas =
        NFAe(widget.states, widget.alphabet, widget.transition, widget.startState, widget.endState);
    Map<String, dynamic> dfa = nfas.buildDFA();

    setState(() {
      columnHeaders = ["State"] + widget.alphabet.toList();
      start_state = dfa["start_state"].toString().replaceAll('\n', '');
      end_state = dfa["end_state"].toString().replaceAll('\n', '');
      alphabetString = dfa["Alphabet"].join(", ");
      state = dfa["State"].join(", ");
      transition_state = dfa["transition"];
      convert_state = dfa["convert_state"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "NFAε to DFA Converter",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade500,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  Text(
                    "Start state: $start_state",
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text("End state: $end_state",
                      style: const TextStyle(fontSize: 16)),
                  Text("Alphabet: $alphabetString",
                      style: const TextStyle(fontSize: 16)),
                  Text("State: $state", style: const TextStyle(fontSize: 16)),
                  SizedBox(
                    child: Text(
                      convert_state.entries.map((entry)=>'${entry.key} -> ${entry.value}').join('\n')
                    ),
                  ),
                  if (columnHeaders.isNotEmpty)
                    DataTable(
                      columns: columnHeaders
                          .map((header) => DataColumn(label: Text(header)))
                          .toList(),
                      rows: transition_state.entries.map((entry) {
                        String state = entry.key.toString();
                        Map<String, int> transitions = entry.value;

                        return DataRow(cells: [
                          DataCell(Text(state)),
                          for (var cell in widget.alphabet)
                              DataCell(
                                  Text(transitions[cell]?.toString() ?? "null"))

                        ]);
                      }).toList(),
                    )
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}

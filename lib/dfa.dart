import 'package:flutter/material.dart';
import 'dfa_converting.dart';

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
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      convert();
    });
  }
  
  void convert() {
    Set<int> states = widget.states;
    Set<String> alphabet = widget.alphabet;
    Map<int, Map<String, Set<int>>> transition = widget.transition;

    NFAs nfas = NFAs(states, alphabet, transition, widget.startState, widget.endState);
    Map<String, dynamic> dfa = nfas.buildStateDFA();

    setState(() {
      columnHeaders = ["State"] + widget.alphabet.toList();
      start_state = dfa["start_state"].toString().replaceAll('\n', '');
      end_state = dfa["end_state"].toString().replaceAll('\n', '');
      alphabetString = dfa["Alphabet"].join(", ");
      state = dfa["State"].join(", ");
      transition_state = dfa["transition"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NFAε to DFA Converter", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.blue.shade500,
        centerTitle: true,
      ),
      body: Center(
        // padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            // const Text(
            //   "Convert NFA to DFA",
            //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            // ),
            const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: convert,
            //   child: const Text("Convert NFA to DFA"),
            // ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  // Text("Alphabet ${widget.alphabet}"),
                  // Text("State ${widget.states.toString()}"),
                  // Text("transition ${widget.transition.toString()}"),
                  Text(
                    "Start state: $start_state",
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text("End state: $end_state",
                      style: const TextStyle(fontSize: 16)),
                  Text("Alphabet: $alphabetString",
                      style: const TextStyle(fontSize: 16)),
                  Text("State: $state", style: const TextStyle(fontSize: 16)),
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
                          ...widget.alphabet.map((symbol) {
                            return DataCell(
                                Text(transitions[symbol]?.toString() ?? "null"));
                          })
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

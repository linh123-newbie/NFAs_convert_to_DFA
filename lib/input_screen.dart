import 'package:flutter/material.dart';
import 'shared_input_form.dart';
import 'dfa.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController numberOfState = TextEditingController();
  TextEditingController numberOfAlphabet = TextEditingController();
  TextEditingController startState = TextEditingController();
  TextEditingController endState = TextEditingController();
  Set<int> states = {};
  List<String> existed_alphabet = ['s', 'a', 'b', 'c', 'd', 'e', 'f', 'g'];
  Set<String> alphabets = {};
  List<String> header = [];
  List<int> stateList = [];
  final Map<int, Map<String, Set<int>>> transition = {};
  //Each state has list input
  final Map<int, List<TextEditingController>> inputController = {};
  bool showTable = false;
  // Set<int> states = {};
  @override
  void dispose() {
    numberOfState.dispose();
    numberOfAlphabet.dispose();
    startState.dispose();
    endState.dispose();
    for (var controllers in inputController.values) {
      for (var controller in controllers) {
        controller.dispose();
      }
    }

    super.dispose();
  }

  void savedData() {
    setState(() {
      transition.clear();
      for (var state in states) {
        if (!inputController.containsKey(state)) continue;

        Map<String, Set<int>> statesTransition = {};
        for (int i = 0; i < alphabets.length; i++) {
          String symbol = alphabets.elementAt(i);
          List<int> targets = inputController[state]![i]
              .text
              .split(",")
              .map((el) => int.tryParse(el.trim()) ?? -1)
              .where((e) => e != -1)
              .toList();
          if (targets.isNotEmpty) {
            statesTransition[symbol] = targets.toSet();
          }
        }
        if (statesTransition.isNotEmpty) {
          transition[state] = statesTransition;
        }
      }
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DFAConverterPage(
                alphabet: alphabets.skip(1).toSet(),
                states: states,
                transition: transition,
                startState: int.tryParse(startState.text) ?? 0,
                endState: endState.text
                    .split(",")
                    .map((el) => int.tryParse(el.trim()) ?? -1)
                    .toSet()),
          ));
    });
  }

  void updateState() {
    setState(() {
      alphabets = {};
      states = {};

      header = [];
      int numStates = int.tryParse(numberOfState.text) ?? 0;
      int numAlphabets = int.tryParse(numberOfAlphabet.text) ?? 0;

      for (var i = 0; i < numStates; i++) {
        states.add(i);
      }
      for (var i = 0; i <= numAlphabets && i < existed_alphabet.length; i++) {
        alphabets.add(existed_alphabet[i]);
      }
      header = ["State"] + alphabets.toList();
      stateList = states.toList();
      //Each state has number of inputs depends on number of alphabets
      for (var state in states) {
        inputController[state] =
            List.generate(alphabets.length, (index) => TextEditingController());
      }
      showTable = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                InputForm(
                  textController: numberOfState,
                  textTitle: "Number of states",
                ),
                SizedBox(
                  height: 15,
                ),
                InputForm(
                  textController: numberOfAlphabet,
                  textTitle: "Number of alphabets",
                ),
                SizedBox(
                  height: 15,
                ),
                InputForm(
                  textController: startState,
                  textTitle: "Start state",
                ),
                SizedBox(
                  height: 15,
                ),
                InputForm(
                  textController: endState,
                  textTitle: "End state",
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      updateState();
                    },
                    child: Text("Get Input")),
                if (showTable) ...[
                  SizedBox(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: header
                            .map((headerMap) =>
                                DataColumn(label: Text(headerMap)))
                            .toList(),
                        rows: states
                            .map(
                              (state) => DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      state.toString(),
                                    ),
                                  ),
                                  for (var i = 0; i < alphabets.length; i++)
                                    DataCell(
                                      SizedBox(
                                        height: 40,
                                        child: TextField(
                                          controller: inputController[state]![i],
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              fillColor: Colors.white,
                                              filled: true),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        savedData();
                      },
                      child: Text("Convert NFAs to DFA")),
                ]
              ],
            ),
          ),
        ));
  }
}

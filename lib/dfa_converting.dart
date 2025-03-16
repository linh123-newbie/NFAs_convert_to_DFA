import 'dart:collection';

class NFAs {
  Set<int> states;
  Set<String> alphabet;
  Map<int, Map<String, Set<int>>> transition;
  int startState;
  Set<int> endState;

  NFAs(this.states, this.alphabet, this.transition, this.startState,
      this.endState);

  List<int> getClosure(List<int> states) {
    List<int> closureList = [];
    for (var state in states) {
      if (transition.containsKey(state)) {
        if (transition[state]!.containsKey('s')) {
          closureList.addAll(transition[state]!['s']!);
        }
      }
    }
    return closureList.toSet().toList(); // Remove duplicate items
  }

  List<int> convertState(List<int> closureList, String alphabet) {
    List<int> convertingStateList = [];
    for (var clo in closureList) {
      if (transition.containsKey(clo)) {
        if (transition[clo]!.containsKey(alphabet)) {
          convertingStateList.addAll(transition[clo]![alphabet]!);
        }
      }
    }
    return convertingStateList.toSet().toList(); // Remove duplicate items
  }

  Map<String, dynamic> buildStateDFA() {

    Map<int, List<int>> dfaStates = {};
    Map<int, Map<String, int>> dfaResult = {};
    int count = 0; // State symbol of DFA
    List<int> closureNFAs = [];
    List<int> savedState = [];
    Set<int> endStateDFA = {};

    // Get closure of start_state
    closureNFAs = getClosure([startState]);
    if (closureNFAs.isNotEmpty) {
      dfaStates[count] = closureNFAs;
      savedState.add(count);
      count++;
    };
    // savedState is used for stack, if one state of DFA in savedState that is used for all alphabets
    // => remove this state
    while (savedState.isNotEmpty) {
      int i = savedState.removeLast();
      for (var al in alphabet) {
        List<int> convertStateList = convertState(dfaStates[i]!, al);
        if (convertStateList.isNotEmpty) {
          List<int> closureNFA = getClosure(convertStateList);

          // Dart doesn compare 2 list, must use map
          if (!dfaStates.values.any((state) =>
              Set<int>.from(state).containsAll(closureNFA) &&
              Set<int>.from(closureNFA).containsAll(state))) {
            // if states of dfa do not contain closureNFAs => add them into dfaStates and savedSate
            dfaStates[count] = closureNFA;
            savedState.add(count);
            count++;
          }
          for (var key in dfaStates.keys) {
            if (Set<int>.from(dfaStates[key]!).containsAll(closureNFA)) {
              dfaResult.putIfAbsent(
                  i,
                  () =>
                      {}); //Add new value if value is not exits,
                      // Type of dfaResult[i] is Map<String, int>, if i is not in dfaResult,
                      // i is assigned an empty class
              dfaResult[i]![al] =
                  key; //Add a transition from i to key when reading al
            }
            for (var j in endState) {
              // print(j);
              if (dfaStates[key]!.contains(j)) {
                // ! null-assertion operator
                endStateDFA.add(key);
              }
            }
          }
        }
      }
    }
    return {
      "State": dfaStates.keys,
      "Alphabet": alphabet,
      "start_state": dfaStates.keys.first,
      "end_state": endStateDFA,
      "transition": dfaResult
    };
  }
}

// void main() {
//   Set<int> states = {0, 1, 2};
//   Set<String> alphabet = {'a', 'b', 'c'};
//   Map<int, Map<String, Set<int>>> transition = {
//     0: {
//       's': {0, 1, 2},
//       'a': {0},
//     },
//     1: {
//       's': {1, 2},
//       'b': {1},
//     },
//     2: {
//       's': {2},
//       'c': {2}
//     },
//   };

//   NFAs nfas = NFAs(states, alphabet, transition, 0, {2});
//   nfas.buildStateDFA();
// }

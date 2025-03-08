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
    return closureList.toSet().toList(); // Loại bỏ trùng lặp
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
    return convertingStateList.toSet().toList(); // Loại bỏ trùng lặp
  }

  // Map<int, Map<String, int>> buildStateDFA() {
  Map<String, dynamic> buildStateDFA() {
    Map<int, List<int>> dfaStates = {};
    Map<int, Map<String, int>> dfaResult = {};
    int count = 0;
    List<int> closureNFA = [];
    List<int> savedState = [];
    Set<int> endStateDFA = {};

    closureNFA = getClosure([startState]);
    if (closureNFA.isNotEmpty) {
      dfaStates[count] = closureNFA;
      savedState.add(count);
      count++;
    }
    // print("State: ${dfaStates.keys}");
    // print("Alphabet: $alphabet");
    // print("Transition: $dfaResult");
    // print("Start state: ${dfaStates.keys.first}");
    // print("End state: $endStateDFA");

    

    while (savedState.isNotEmpty) {
      int i = savedState.removeLast();
      for (var al in alphabet) {
        List<int> convertStateList = convertState(dfaStates[i]!, al);
        List<int> closureNFA = getClosure(convertStateList);
        // print(convertStateList);
        //List in dart compare reference type, not value
        if (!dfaStates.values.any((state) =>
            Set<int>.from(state).containsAll(closureNFA) &&
            Set<int>.from(closureNFA).containsAll(state))) {
          // print(dfaStates.values);
          dfaStates[count] = closureNFA;
          savedState.add(count);
          count++;
        }
        for (var key in dfaStates.keys) {
          if (Set<int>.from(dfaStates[key]!).containsAll(closureNFA)) {
            dfaResult.putIfAbsent(i,() =>{}); //Add new value if value is not exits, Type of dfaResult[i] is Map<String, int>, if i is not in dfaResult, i is assigned an empty class
            dfaResult[i]![al] = key; //Add a transition from i to key when reading al
          }
          for (var j in endState) {
            print(j);
            if (dfaStates[key]!.contains(j)) { // ! null-assertion operator
              endStateDFA.add(key);
            }
          }
        }
      }
    }
    print(dfaResult);
    dfaResult.forEach((key, value) {
    print("For key $key:");
    value.forEach((innerKey, innerValue) {
      if(innerKey=='b'){

        print("$innerKey: $innerValue"); 
      }
    });
  });
    print(dfaResult.runtimeType);
    // print(endStateDFA);
    // print(alphabet);
    // print(dfaStates.keys);
    return{
      "State": dfaStates.keys,
      "Alphabet": alphabet,
      "start_state": dfaStates.keys.first,
      "end_state": endStateDFA,
      "transition": dfaResult
    };
  }
}

// void main() {
//   Set<int> states = {0, 1,};
//   Set<String> alphabet = {'a', 'b', "c"};
//   Map<int, Map<String, Set<int>>> transition = {
//     0: {
//       's': {0, 1},
//       'a': {1},
//       'b': {1},
//       'c': {0}
//     },
//     1: {
//       's': {0,1},
//       'a': {1},
//       'b': {0},
//       'c': {1}
//     },
//     // 2: {
//     //   's': {2},
//     //   'a': {3}
//     // },
//     // 3: {
//     //   's': {3, 6, 1, 2, 4, 7}
//     // },
//     // 4: {
//     //   's': {4},
//     //   'b': {5}
//     // },
//     // 5: {
//     //   's': {5, 6, 7, 1, 2, 4}
//     // },
//     // 6: {
//     //   's': {6, 7, 1, 2, 4}
//     // },
//     // 7: {
//     //   's': {7},
//     //   'a': {8}
//     // },
//     // 8: {
//     //   's': {8},
//     //   'b': {9}
//     // },
//     // 9: {
//     //   's': {9},
//     //   'b': {10}
//     // },
//     // 10: {
//     //   's': {10}
//     // },
//   };

//   NFAs nfas = NFAs(states, alphabet, transition, 0, {1});
//   nfas.buildStateDFA();
// }

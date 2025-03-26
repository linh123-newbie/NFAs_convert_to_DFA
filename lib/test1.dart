class NFAe {
  Set<int> states;
  Set<String> alphabet;
  Map<int, Map<String, Set<int>>> transition;
  int start_state;
  Set<int> end_state;
  NFAe(this.states, this.alphabet, this.transition, this.start_state,
      this.end_state);

  Set<int> getClosure(Set<int> states) {
    Set<int> closure = Set.from(states);
    Set<int> nextState = Set.from(states);
    while (nextState.isNotEmpty) {
      int state = nextState.first;
      nextState.remove((state));
      if (transition.containsKey(state)) {
        if (transition[state]!.containsKey('s')) {
          for(int i in transition[state]!['s']!){
            if(!closure.contains(i)){
              closure.add(i);
              nextState.add(i);
            }
            // print("state: $i");
            // print("next state $nextState");
          }
          
        }
      }
    }
    return closure;
  }

  Set<int> getConvertState(Set<int> closureSet, String al) {
    Set<int> convertState = {};
    for (var i in closureSet) {
      if (transition.containsKey(i)) {
        if (transition[i]!.containsKey(al)) {
          convertState.addAll(transition[i]![al]!);
        }
      }
    }
    return convertState;
  }

  Map<String, dynamic> buildDFA() {
    Map<int, Map<String, int>> DFA = {};
    Map<int, Set<int>> DFA_state = {};
    Set<int> closure = {};
    Set<int> convertState = {};
    int symbol_DFA = 0;
    List<int> savedSate = [];
    Set<int> endState = {};
    // Get closure of first state
    closure = getClosure({start_state});
    DFA_state.putIfAbsent(symbol_DFA, () => {}).addAll(closure);
    savedSate.add(symbol_DFA);

    while (savedSate.isNotEmpty) {
      int i = savedSate.removeAt(0);
      for (var al in alphabet) {
        convertState = getConvertState(DFA_state[i]!, al);

        if (convertState.isNotEmpty) {
          closure = getClosure(convertState);

          if (!DFA_state.values.any((state) =>
              state.containsAll(closure) && closure.containsAll(state))) {
            symbol_DFA++;
            DFA_state.putIfAbsent(symbol_DFA, () => {}).addAll(closure);
            savedSate.add(symbol_DFA);
          }

          for (var key in DFA_state.keys) {
            if (DFA_state[key]!.containsAll(closure) &&
                closure.containsAll(DFA_state[key]!)) {
              DFA.putIfAbsent(i, () => {});
              DFA[i]![al] = key;
            }

            for (var j in end_state) {
              // print(j);
              if (DFA_state[key]!.contains(j)) {
                // ! null-assertion operator
                endState.add(key);
              }
            }
          }
        }
      }
    }
    // print(DFA.keys);
    // print(alphabet);
    // print(DFA.keys.first);
    // print(endState);
    // print(DFA);
    // print(DFA_state);

    return {
      "State": DFA.keys,
      "Alphabet": alphabet,
      "start_state": DFA.keys.first,
      "end_state": endState,
      "transition": DFA,
      "convert_state": DFA_state
    };
    // return DFA;
  }

  // Set<int> getClosureTest(Set<int> states) {
  //   Set<int> closure = Set.from(states);
  //   List<int> nextState = List.from(states);
  //   while(nextState.isNotEmpty){
  //     print(nextState);
  //     int state = nextState.removeAt(0);
  //     if(transition.containsKey(state)){
  //       if(transition[state]!.containsKey('s')){
  //         nextState.addAll(transition[state]!['s']!);
  //         closure.addAll(transition[state]!['s']!);
  //       }
  //     }
  //   }
  //   return closure;
  // }
}

void main() {
  // Set<int> states = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
  // Set<String> alphabet = {'a', 'b'};
  // Map<int, Map<String, Set<int>>> transition = {
  //   0: {
  //     's': {1,7},
  //   },
  //   1: {
  //     's': {2,4},
  //   },
  //   2: {
  //     // 's': {2},
  //     'a': {3}
  //   },
  //   3: {
  //     's': {6},
  //   },
  //   4: {
  //     // 's': {4},
  //     'b': {5}
  //   },
  //   5: {
  //     's': {6},
  //   },
  //   6: {
  //     's': {1,7},
  //   },
  //   7: {
  //     // 's': {7},
  //     'a': {8}
  //   },
  //   8: {
  //     // 's': {8},
  //     'b': {9}
  //   },
  //   9: {
  //     // 's': {9},
  //     'b': {10}
  //   },
  //   10: {
  //     // 's': {10},
  //   },
  // };
  // NFAe nfae = NFAe(states, alphabet, transition, 0, {10});
  // // print(nfae.getClosure({0}));
  // print(nfae.buildDFA());

  // Set<int> states = {0, 1, 2};
  // Set<String> alphabet = {'a', 'b'};
  // Map<int, Map<String, Set<int>>> transition = {
  //   0: {
  //     's': {0, 1},
  //     'a': {0},
  //   },
  //   1: {
  //     's': {1},
  //     'b': {1},
  //     'a': {2},
  //   },
  //   2: {
  //     's': {2},
  //     'a': {2},
  //     'b': {2}
  //   },

  // };
  // NFAe nfae = NFAe(states, alphabet, transition, 0, {2});

  // print(nfae.buildDFA());

  Set<int> states = {0, 1, 2};
  Set<String> alphabet = {'a', 'b', 'c'};
  Map<int, Map<String, Set<int>>> transition = {
    0: {
      's': {1,2},
      'a': {0},
    },
    1: {
      's': {0},
      'b': {1},
    },
    2: {
      'c': {2}
    },
  };
  NFAe nfae = NFAe(states, alphabet, transition, 0, {1});
  print(nfae.getClosure({0}));
  // print(nfae.buildDFA());
}

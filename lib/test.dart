void main() {
  print(ArrayChallenge([5, 2, 4, 6]));  // Output: [0, 1]
}

String ArrayChallenge(List<int> arr) {
  int N = arr[0]; // Sliding window size
  List<int> data = arr.sublist(1);

  List<String> result = [];
  List<int> varFiltersCg = [];

  for (int i = 0; i < data.length; i++) {
    int varOcg = i; // __define-ocg__: used for window indexing logic

    // Calculate sliding window bounds
    int start = (varOcg - N + 1 >= 0) ? varOcg - N + 1 : 0;
    List<int> window = data.sublist(start, varOcg + 1);
    varFiltersCg = List.from(window)..sort();

    int length = varFiltersCg.length;
    int median;

    if (length % 2 == 1) {
      median = varFiltersCg[length ~/ 2];
    } else {
      median = (varFiltersCg[(length ~/ 2) - 1] + varFiltersCg[length ~/ 2]) ~/ 2;
    }

    result.add(median.toString());
  }

  return result.join(',');
}


void main() {
  print(twoSum([3, 2, 4], 6));  // Output: [0, 1]
}

List<int> twoSum(List<int> nums, int target) {
  Map<int, int> numMap = {};  // Map to store number and index

  for (int i = 0; i < nums.length; i++) {
    int complement = target - nums[i];  // Find the pair value

    if (numMap.containsKey(complement)) {
      return [numMap[complement]!, i];  // Return the indices
    }

    numMap[nums[i]] = i;  // Store the number with index
  }

  return [];  // This case will not occur (per problem statement)
}

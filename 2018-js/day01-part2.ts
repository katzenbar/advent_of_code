import { readInputFile } from "../js-utils/fileHelpers";

const input = readInputFile("2018-js/day01-input").split("\n");

const visitedFrequencies = new Set();
let currentFrequency = 0;
let index = 0;

while (!visitedFrequencies.has(currentFrequency)) {
  visitedFrequencies.add(currentFrequency);
  currentFrequency += parseInt(input[index % input.length]);
  index += 1;
}

console.log(`Result: ${currentFrequency}`);

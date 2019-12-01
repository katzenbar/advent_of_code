import { readInputFile } from "../js-utils/fileHelpers";

const result = readInputFile("2018-js/day01-input")
  .split("\n")
  .reduce((acc, frequency) => acc + parseInt(frequency), 0);

console.log(`Result: ${result}`);

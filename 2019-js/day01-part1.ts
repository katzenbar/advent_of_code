import { readInputFile } from "../js-utils/fileHelpers";

const input = readInputFile("2019-js/day01-input").split("\n");

const result = input
  .map((mass) => Math.floor(parseInt(mass) / 3) - 2)
  .reduce((acc, value) => acc + value);

console.log(result);

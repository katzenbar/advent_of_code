import { range } from "lodash";
import { readInputFile } from "../js-utils/fileHelpers";

const alwaysAscendingRegex = /^0*1*2*3*4*5*6*7*8*9*$/;
const hasDoubleRegex = /^\d*(\d)\1\d*$/;

const isValidPassword = (password: string): boolean => {
  return hasDoubleRegex.test(password) && alwaysAscendingRegex.test(password);
};

const [min, max] = readInputFile("2019-js/day04-input").split("-");

const result = range(parseInt(min, 10), parseInt(max, 10)).filter((x) =>
  isValidPassword(x.toString()),
).length;

console.log(`Result: ${result}`);

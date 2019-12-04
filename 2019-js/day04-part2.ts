import { groupBy, range } from "lodash";
import { readInputFile } from "../js-utils/fileHelpers";

const alwaysAscendingRegex = /^0*1*2*3*4*5*6*7*8*9*$/;
const digits = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];

const isValidPassword = (password: string): boolean => {
  return (
    alwaysAscendingRegex.test(password) &&
    Object.values(groupBy([...password]))
      .map((x) => x.length)
      .includes(2)
  );
};

const [min, max] = readInputFile("2019-js/day04-input").split("-");

const result = range(parseInt(min, 10), parseInt(max, 10)).filter((x) =>
  isValidPassword(x.toString()),
).length;

console.log(`Result: ${result}`);

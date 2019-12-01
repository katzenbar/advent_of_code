import { readInputFile } from "../js-utils/fileHelpers";

const input = readInputFile("2019-js/day01-input").split("\n");

const fuelForModule = (mass: string): number => {
  let totalFuel = Math.floor(parseInt(mass) / 3) - 2;
  let calculatingAdditionalFuelFor = totalFuel;

  while (calculatingAdditionalFuelFor > 0) {
    const nextFuel = Math.floor(calculatingAdditionalFuelFor / 3) - 2;
    calculatingAdditionalFuelFor = nextFuel;
    if (nextFuel > 0) {
      totalFuel += nextFuel;
    }
  }
  return totalFuel;
};

const result = input
  .map((mass) => fuelForModule(mass))
  .reduce((acc, value) => acc + value);

console.log(result);

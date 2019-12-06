import { groupBy, Dictionary } from "lodash";
import { readInputFile } from "../js-utils/fileHelpers";

const countOrbits = (
  orbit: string,
  currentIndirectOrbits: number,
  orbitMap: Dictionary<string[]>,
): number => {
  const childOrbits = orbitMap[orbit];

  if (!childOrbits) {
    return currentIndirectOrbits;
  } else {
    const childOrbitCount = childOrbits
      .map((child) => countOrbits(child, currentIndirectOrbits + 1, orbitMap))
      .reduce((acc, x) => acc + x);
    return currentIndirectOrbits + childOrbitCount;
  }
};

const solve = (input: string): number => {
  const orbitMap = input.split("\n").map((x) => x.split(")"));
  const groupedOrbits = Object.entries(groupBy(orbitMap, ([a, b]) => a))
    .map<[string, string[]]>(([key, values]) => [
      key,
      values.map(([key, x]) => x),
    ])
    .reduce((acc, [key, orbiters]) => {
      acc[key] = orbiters;
      return acc;
    }, {} as Dictionary<string[]>);

  return countOrbits("COM", 0, groupedOrbits);
};

// const input = `COM)B
// B)C
// C)D
// D)E
// E)F
// B)G
// G)H
// D)I
// E)J
// J)K
// K)L`;

const input = readInputFile("2019-js/day06-input");

const result = solve(input);
console.log(`Result: ${result}`);

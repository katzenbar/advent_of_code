import { flatMap, groupBy, uniq, Dictionary } from "lodash";
import { readInputFile } from "../js-utils/fileHelpers";

const connectedObjects = (
  objectToFind: string,
  orbitMap: Dictionary<string[]>,
): string[] => {
  const parent = Object.entries(orbitMap).find(([, childObjects]) =>
    childObjects.includes(objectToFind),
  );
  const children = orbitMap[objectToFind];

  let connectedObjects = [];

  if (parent) {
    connectedObjects.push(parent[0]);
  }

  if (children) {
    connectedObjects = connectedObjects.concat(children);
  }

  return connectedObjects;
};

const findTransfersToSanta = (orbitMap: Dictionary<string[]>): number => {
  let transferCount = 0;
  let currentObjects = connectedObjects("YOU", orbitMap);
  let visitedObjects = new Set<string>();
  visitedObjects.add("YOU");

  while (true) {
    const currentConnectedObjects = uniq(
      flatMap(currentObjects, (object) => connectedObjects(object, orbitMap)),
    );
    console.log(
      `Searching after ${transferCount} transfers, children are ${currentConnectedObjects}`,
    );

    currentObjects.forEach((object) => visitedObjects.add(object));
    currentObjects = currentConnectedObjects.filter(
      (object) => !visitedObjects.has(object),
    );

    if (currentObjects.includes("SAN")) {
      return transferCount;
    }

    transferCount += 1;

    if (currentObjects.length === 0) {
      throw "no current objects - something went wrong";
    }
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

  return findTransfersToSanta(groupedOrbits);
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
// K)L
// K)YOU
// I)SAN`;

const input = readInputFile("2019-js/day06-input");

const result = solve(input);
console.log(`Result: ${result}`);

import { flatMap, max, maxBy, range, sortBy, uniqBy } from "lodash";
import { readInputFile } from "../js-utils/fileHelpers";

enum Position {
  Empty = 0,
  Asteroid = 1,
  Blocked = 2,
}
type AsteroidMap = {
  positions: Array<Position>;
  width: number;
  height: number;
};

function buildMap(input: string): AsteroidMap {
  const inputLines = input.split("\n");
  const width = inputLines[0].length;
  const height = inputLines.length;
  const positions = flatMap(inputLines, (line) =>
    line
      .split("")
      .map((pos) => (pos === "." ? Position.Empty : Position.Asteroid)),
  );

  return {
    width,
    height,
    positions,
  };
}

function getGcd(x: number, y: number): number {
  if (x === 0) {
    return Math.abs(y);
  }
  if (y === 0) {
    return Math.abs(x);
  }

  const [b, a] = sortBy([Math.abs(x), Math.abs(y)]);
  return getGcd(b, a % b);
}

function getDirectionalSlope(x: number, y: number): [number, number] {
  const gcd = getGcd(x, y);
  return [x / gcd, y / gcd];
}

function positionsInRing(
  map: AsteroidMap,
  x: number,
  y: number,
  ringSize: number,
): Array<[number, number]> {
  const maxX = x + ringSize;
  const minX = x - ringSize;
  const maxY = y + ringSize;
  const minY = y - ringSize;

  return uniqBy(
    ([] as Array<[number, number]>)
      .concat(range(minY, maxY + 1).map((a) => [minX, a]))
      .concat(range(minY, maxY + 1).map((a) => [maxX, a]))
      .concat(range(minX, maxX + 1).map((a) => [a, minY]))
      .concat(range(minX, maxX + 1).map((a) => [a, maxY])),
    ([a, b]) => `${a},${b}`,
  ).filter(([a, b]) => a >= 0 && b >= 0 && a < map.width && b < map.height);
}

function detectableAsteroidsFromPosition(
  map: AsteroidMap,
  x: number,
  y: number,
): number {
  // Copy so we can mutate
  const positions = [...map.positions];
  const maxDistanceFromEdge =
    max([x, map.width - 1 - x, y, map.height - 1 - y]) || 0;

  let asteroidCount = 0;

  for (let i = 1; i <= maxDistanceFromEdge; i++) {
    const positionsToCheck = positionsInRing(map, x, y, i);
    positionsToCheck.forEach(([checkX, checkY]) => {
      if (positions[checkY * map.width + checkX] === Position.Asteroid) {
        asteroidCount += 1;

        const directionalSlope = getDirectionalSlope(checkX - x, checkY - y);
        let nextPosition = [
          checkX + directionalSlope[0],
          checkY + directionalSlope[1],
        ];
        while (
          nextPosition[0] >= 0 &&
          nextPosition[0] < map.width &&
          nextPosition[1] >= 0 &&
          nextPosition[1] < map.height
        ) {
          positions[nextPosition[1] * map.width + nextPosition[0]] =
            Position.Blocked;

          nextPosition = [
            nextPosition[0] + directionalSlope[0],
            nextPosition[1] + directionalSlope[1],
          ];
        }
      }
    });
  }

  return asteroidCount;
}

function solve(input: string): [string, number] {
  const map = buildMap(input);
  let counts: Array<[string, number]> = [];

  for (let y = 0; y < map.width; y++) {
    for (let x = 0; x < map.height; x++) {
      if (map.positions[y * map.width + x] === Position.Asteroid) {
        counts.push([
          `(${x},${y})`,
          detectableAsteroidsFromPosition(map, x, y),
        ]);
      }
    }
  }

  return maxBy(counts, ([coordinates, count]) => count) || ["", -1];
}

const input = readInputFile("2019-js/day10-input");

const result = solve(input);
console.log(`Result: ${result[0]} - ${result[1]}`);

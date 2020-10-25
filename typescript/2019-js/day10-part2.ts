import { flatMap, max, maxBy, range, sortBy, uniqBy } from "lodash";

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
type PositionWithPolarCoordinates = {
  x: number,
  y: number;
  distance: number;
  angle:
}

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

function asteroidsInPolarCoordinates(map: AsteroidMap, centerX: number, centerY: number):

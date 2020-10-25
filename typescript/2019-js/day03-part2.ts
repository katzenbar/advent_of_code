import { min, compact } from "lodash";
import { readInputFile } from "../js-utils/fileHelpers";

type GridVisit = {
  wireKey: number;
  numberOfSteps: number;
};
type Grid = {
  [coordinates: string]: Array<GridVisit> | undefined;
};

type PathDirection = "R" | "U" | "L" | "D";
type PathSegment = [PathDirection, number];
type Path = Array<PathSegment>;

const buildPath = (wirePath: string): Path => {
  return wirePath.split(",").map((str) => {
    const direction = <PathDirection>str[0];
    const distance = parseInt(str.slice(1));

    return [direction, distance];
  });
};

const traceWire = (
  wireKey: number,
  gridState: Grid,
  startX: number,
  startY: number,
  startNumSteps: number,
  path: Path,
): Grid => {
  if (path.length === 0) {
    return gridState;
  }

  const [pathSegment, ...remainingPath] = path;
  let currentGrid = gridState;
  let currentX = startX;
  let currentY = startY;
  let currentNumSteps = startNumSteps;

  for (let i = 0; i < pathSegment[1]; i++) {
    switch (pathSegment[0]) {
      case "D":
        currentY -= 1;
        break;
      case "L":
        currentX -= 1;
        break;
      case "U":
        currentY += 1;
        break;
      case "R":
        currentX += 1;
        break;
      default:
        throw "UNKNOWN DIRECTION";
    }
    currentNumSteps += 1;

    const key = `${currentX},${currentY}`;
    const gridValue = currentGrid[key] || [];
    gridValue.push({ wireKey, numberOfSteps: currentNumSteps });

    currentGrid[key] = gridValue;
  }

  return traceWire(
    wireKey,
    currentGrid,
    currentX,
    currentY,
    currentNumSteps,
    remainingPath,
  );
};

const distancesToCrossings = (grid: Grid): Array<number> => {
  return compact(
    Object.entries(grid).map(([key, value]) => {
      const wire1Visits = (value || [])
        .filter((x) => x.wireKey === 1)
        .map((x) => x.numberOfSteps);
      const wire2Visits = (value || [])
        .filter((x) => x.wireKey === 2)
        .map((x) => x.numberOfSteps);

      if (wire1Visits.length === 0 || wire2Visits.length === 0) {
        return null;
      }

      return (min(wire1Visits) || 0) + (min(wire2Visits) || 0);
    }),
  );
};

export const solve = (input: string): number => {
  const [wire1, wire2] = input.split("\n").map(buildPath);
  const gridAfter1 = traceWire(1, {}, 0, 0, 0, wire1);
  const finalGrid = traceWire(2, gridAfter1, 0, 0, 0, wire2);

  const distances = distancesToCrossings(finalGrid);

  return min(distances) || -1;
};

// -----

const input = readInputFile("2019-js/day03-input");

// const input = `R8,U5,L5,D3
// U7,R6,D4,L4`;

// const input = `R75,D30,R83,U83,L12,D49,R71,U7,L72
// U62,R66,U55,R34,D71,R55,D58,R83`;

// const input = `R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
// U98,R91,D20,R16,D67,R40,U7,R15,U6,R7`;

const result = solve(input);
console.log(`Result: ${result}`);

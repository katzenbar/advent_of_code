import { readInputFile } from "../js-utils/fileHelpers";
import { minBy } from "lodash";

type Layer = Array<number>;
type Layers = Array<Layer>;

function countDigits(layer: Layer, digit: number): number {
  return layer.filter((x) => x === digit).length;
}

function parseLayers(
  input: string,
  imageWidth: number,
  imageHeight: number,
): Layers {
  const inputAsArray = input.split("").map((x) => parseInt(x, 10));
  const numberOfPixelsPerLayer = imageWidth * imageHeight;
  const numberOfLayers = inputAsArray.length / numberOfPixelsPerLayer;
  const layers: Layers = [];

  for (let i = 0; i < numberOfLayers; i++) {
    layers.push(
      inputAsArray.slice(
        numberOfPixelsPerLayer * i,
        numberOfPixelsPerLayer * (i + 1),
      ),
    );
  }

  return layers;
}

function solve(input: string, imageWidth: number, imageHeight: number): number {
  const layers = parseLayers(input, imageWidth, imageHeight);

  const digitCounts = layers.map((layer) =>
    [0, 1, 2].map((digit) => countDigits(layer, digit)),
  );

  const digitCountsWithFewestZero = minBy(digitCounts, (counts) => counts[0]);
  if (!digitCountsWithFewestZero) {
    throw "minBy returned nothing?!";
  }

  return digitCountsWithFewestZero[1] * digitCountsWithFewestZero[2];
}

const input = readInputFile("2019-js/day08-input");

const result = solve(input, 25, 6);

console.log(result);

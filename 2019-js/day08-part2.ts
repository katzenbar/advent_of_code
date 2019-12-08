import { readInputFile } from "../js-utils/fileHelpers";
import { minBy } from "lodash";

type Layer = Array<number>;
type Layers = Array<Layer>;

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

function mergeLayers(lowerLayer: Layer, upperLayer: Layer): Layer {
  return lowerLayer.map((digit, index) => {
    if (digit === 1 || digit === 0) {
      return digit;
    } else {
      return upperLayer[index];
    }
  });
}

function printImage(
  image: Layer,
  imageWidth: number,
  imageHeight: number,
): void {
  for (let i = 0; i < imageHeight; i++) {
    const row = image
      .slice(imageWidth * i, imageWidth * (i + 1))
      .map((digit) => {
        switch (digit) {
          case 0:
            return "\u2588";
          default:
            return " ";
        }
      })
      .join("");
    console.log(row);
  }
}

function solve(input: string, imageWidth: number, imageHeight: number): void {
  const layers = parseLayers(input, imageWidth, imageHeight);
  const image: Layer = layers.reduce(mergeLayers);

  printImage(image, imageWidth, imageHeight);
}

const input = readInputFile("2019-js/day08-input");
solve(input, 25, 6);

import fs from "fs";

export const readInputFile = (path: string) =>
  fs
    .readFileSync(path)
    .toString()
    .trim();

import { readInputFile } from "../js-utils/fileHelpers";

let memory = readInputFile("2019-js/day02-input")
  .split(",")
  .map((x) => parseInt(x, 10));

memory[1] = 12;
memory[2] = 2;

let halted = false;
let executionPointer = 0;

while (!halted) {
  const opcode = memory[executionPointer];
  const value1 = memory[memory[executionPointer + 1]];
  const value2 = memory[memory[executionPointer + 2]];
  const target = memory[executionPointer + 3];

  console.log(
    `EXEC ${executionPointer}: ${opcode} - ${value1}, ${value2}, ${target}`,
  );

  switch (opcode) {
    case 1:
      memory[target] = value1 + value2;
      break;
    case 2:
      memory[target] = value1 * value2;
      break;
    case 99:
      halted = true;
      break;
    default:
      throw `Unknown opcode at pointer ${executionPointer}`;
  }
  executionPointer += 4;
}

console.log(`MEMORY: ${memory}`);

import { readInputFile } from "../js-utils/fileHelpers";

type Memory = Array<number>;

const executeProgram = (
  initialMemory: Memory,
  noun: number,
  verb: number,
): Memory => {
  let memory = [...initialMemory];
  memory[1] = noun;
  memory[2] = verb;

  let halted = false;
  let instructionPointer = 0;

  while (!halted) {
    const opcode = memory[instructionPointer];
    const value1 = memory[memory[instructionPointer + 1]];
    const value2 = memory[memory[instructionPointer + 2]];
    const target = memory[instructionPointer + 3];

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
        throw `Unknown opcode at pointer ${instructionPointer}`;
    }
    instructionPointer += 4;
  }

  return memory;
};

const search = (): number => {
  const memory = readInputFile("2019-js/day02-input")
    .split(",")
    .map((x) => parseInt(x, 10));

  for (let noun = 0; noun < 100; noun++) {
    for (let verb = 0; verb < 100; verb++) {
      const executionResult = executeProgram(memory, noun, verb);
      const output = executionResult[0];

      console.log(`Noun: ${noun}, Verb: ${verb}, Output: ${output}`);

      if (output === 19690720) {
        return 100 * noun + verb;
      }
    }
  }

  return -1;
};

console.log(`Result: ${search()}`);

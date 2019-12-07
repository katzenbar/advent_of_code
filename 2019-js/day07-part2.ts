// This is not great.

import { flatMap, max } from "lodash";
import { readInputFile } from "../js-utils/fileHelpers";

type Memory = Array<number>;
type InstructionPointer = number;
type InputPointer = number;
type Output = number | null;

enum ParameterMode {
  Position = 0,
  Immediate = 1,
}

enum OpCode {
  Add = 1,
  Multiply = 2,
  Input = 3,
  Output = 4,
  JumpIfTrue = 5,
  JumpIfFalse = 6,
  LessThan = 7,
  Equals = 8,
  Halt = 99,
}

type Instruction = {
  opcode: number;
  parameterMode1: ParameterMode;
  parameterMode2: ParameterMode;
  parameterMode3: ParameterMode;
};

const parseInstruction = (instructionCode: number): Instruction => {
  return {
    opcode: instructionCode % 100,
    parameterMode1: Math.floor((instructionCode % 1000) / 100),
    parameterMode2: Math.floor((instructionCode % 10000) / 1000),
    parameterMode3: Math.floor(instructionCode / 10000),
  };
};

const getValue = (
  parameterMode: ParameterMode,
  pointer: number,
  memory: Memory,
): number => {
  if (parameterMode === ParameterMode.Position) {
    return memory[memory[pointer]];
  } else {
    return memory[pointer];
  }
};

const executeInstruction = (
  instructionPointer: InstructionPointer,
  inputPointer: InputPointer,
  memory: Memory,
  inputs: Array<number>,
): [InstructionPointer, InputPointer, Output] => {
  const instruction = parseInstruction(memory[instructionPointer]);
  const parameter1 = getValue(
    instruction.parameterMode1,
    instructionPointer + 1,
    memory,
  );
  const parameter2 = getValue(
    instruction.parameterMode2,
    instructionPointer + 2,
    memory,
  );
  const parameter3 = getValue(
    instruction.parameterMode3,
    instructionPointer + 3,
    memory,
  );
  let nextInstructionPointer = -1;
  let nextInputPointer = inputPointer;
  let output = null;

  switch (instruction.opcode) {
    case OpCode.Add:
      memory[memory[instructionPointer + 3]] = parameter1 + parameter2;
      nextInstructionPointer = instructionPointer + 4;
      break;
    case OpCode.Multiply:
      memory[memory[instructionPointer + 3]] = parameter1 * parameter2;
      nextInstructionPointer = instructionPointer + 4;
      break;
    case OpCode.Input:
      memory[memory[instructionPointer + 1]] = inputs[inputPointer];
      nextInputPointer = inputPointer + 1;
      nextInstructionPointer = instructionPointer + 2;
      break;
    case OpCode.Output:
      output = parameter1;
      nextInstructionPointer = instructionPointer + 2;
      break;
    case OpCode.JumpIfTrue:
      if (parameter1 !== 0) {
        nextInstructionPointer = parameter2;
      } else {
        nextInstructionPointer = instructionPointer + 3;
      }
      break;
    case OpCode.JumpIfFalse:
      if (parameter1 === 0) {
        nextInstructionPointer = parameter2;
      } else {
        nextInstructionPointer = instructionPointer + 3;
      }
      break;
    case OpCode.LessThan:
      memory[memory[instructionPointer + 3]] = parameter1 < parameter2 ? 1 : 0;
      nextInstructionPointer = instructionPointer + 4;
      break;
    case OpCode.Equals:
      memory[memory[instructionPointer + 3]] =
        parameter1 === parameter2 ? 1 : 0;
      nextInstructionPointer = instructionPointer + 4;
      break;
    case OpCode.Halt:
      nextInstructionPointer = -1;
      break;
    default:
      throw "UNKNOWN OPCODE";
  }

  return [nextInstructionPointer, nextInputPointer, output];
};

const executeProgram = (
  memory: Memory,
  inputs: Array<number>,
  startingInstructionPointer: InstructionPointer,
): [InstructionPointer, Output] => {
  let instructionPointer = startingInstructionPointer;
  let inputPointer = 0;
  let output: Output = null;

  while (instructionPointer !== -1) {
    let newOutput = null;
    [instructionPointer, inputPointer, newOutput] = executeInstruction(
      instructionPointer,
      inputPointer,
      memory,
      inputs,
    );

    if (newOutput !== null) {
      return [instructionPointer, newOutput];
    }
  }

  return [instructionPointer, output];
};

function removeAtIndex<T>(array: Array<T>, index: number): Array<T> {
  const arrayCopy = [...array];
  arrayCopy.splice(index, 1);
  return arrayCopy;
}

function generatePermutations<T>(members: Array<T>): Array<Array<T>> {
  if (members.length === 0) {
    return [[]];
  }

  return flatMap(members, (member, index) => {
    const remainingMembers = removeAtIndex(members, index);
    let permutations = generatePermutations(remainingMembers);
    permutations = permutations.map((p) => [member, ...p]);
    return permutations;
  });
}

function executeWithPhaseSettings(
  phaseSettings: Array<number>,
  program: Memory,
): number {
  let lastOutput = 0;
  let ampMemories = [
    [...program],
    [...program],
    [...program],
    [...program],
    [...program],
  ];
  let ampInstructionPointers = [0, 0, 0, 0, 0];
  let runIndex = 0;

  while (true) {
    let ampIndex = runIndex % 5;
    const ampPhase = phaseSettings[ampIndex];
    const ampMemory = ampMemories[ampIndex];
    const ampInstructionPointer = ampInstructionPointers[ampIndex];
    const inputs = runIndex > 4 ? [lastOutput] : [ampPhase, lastOutput];
    const result = executeProgram(ampMemory, inputs, ampInstructionPointer);

    if (result[1] === null) {
      return lastOutput;
    } else {
      ampInstructionPointers[ampIndex] = result[0];
      lastOutput = result[1];
      runIndex += 1;
    }
  }
}

const initialMemory = readInputFile("2019-js/day07-input")
  .split(",")
  .map((x) => parseInt(x, 10));

const phaseSettings = generatePermutations([5, 6, 7, 8, 9]);

const result = max(
  phaseSettings.map((settings) => {
    return executeWithPhaseSettings(settings, initialMemory);
  }),
);

console.log(`Result: ${result}`);

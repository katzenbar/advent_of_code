import { readInputFile } from "../js-utils/fileHelpers";

type Memory = Array<number>;
type InstructionPointer = number;

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
  memory: Memory,
  input: number,
): InstructionPointer => {
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
      memory[memory[instructionPointer + 1]] = input;
      nextInstructionPointer = instructionPointer + 2;
      break;
    case OpCode.Output:
      console.log(parameter1);
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

  return nextInstructionPointer;
};

const executeProgram = (memory: Memory, input: number): void => {
  let instructionPointer = 0;
  while (instructionPointer !== -1) {
    instructionPointer = executeInstruction(instructionPointer, memory, input);
  }
};

const memory = readInputFile("2019-js/day05-input")
  .split(",")
  .map((x) => parseInt(x, 10));

executeProgram(memory, 5);

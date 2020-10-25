import { readInputFile } from "../js-utils/fileHelpers";

type Memory = Array<number>;
type Input = Array<number>;
type Output = Array<number>;

type Program = {
  memory: Memory;
  inputs: Input;
  outputs: Output;

  instructionPointer: number;
  inputPointer: number;
  relativeBase: number;
};

enum ParameterMode {
  Position = 0,
  Immediate = 1,
  Relative = 2,
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
  SetRelativeBase = 9,
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

const getParameterAddress = (
  parameterMode: ParameterMode,
  pointer: number,
  program: Program,
): number => {
  const { memory } = program;

  if (parameterMode === ParameterMode.Position) {
    return memory[pointer] || 0;
  } else if (parameterMode === ParameterMode.Relative) {
    return program.relativeBase + memory[pointer] || 0;
  } else {
    return pointer || 0;
  }
};

const getValue = (
  parameterMode: ParameterMode,
  pointer: number,
  program: Program,
): number => {
  const { memory } = program;
  const memoryAddress = getParameterAddress(parameterMode, pointer, program);

  return memory[memoryAddress] || 0;
};

const executeNextInstruction = (program: Program): boolean => {
  const { memory, inputs, instructionPointer, inputPointer } = program;
  let hasNewOutput = false;

  const instruction = parseInstruction(memory[instructionPointer]);
  const address1 = getParameterAddress(
    instruction.parameterMode1,
    instructionPointer + 1,
    program,
  );
  const parameter1 = getValue(
    instruction.parameterMode1,
    instructionPointer + 1,
    program,
  );
  const parameter2 = getValue(
    instruction.parameterMode2,
    instructionPointer + 2,
    program,
  );
  const address3 = getParameterAddress(
    instruction.parameterMode3,
    instructionPointer + 3,
    program,
  );

  switch (instruction.opcode) {
    case OpCode.Add:
      memory[address3] = parameter1 + parameter2;
      program.instructionPointer += 4;
      break;
    case OpCode.Multiply:
      memory[address3] = parameter1 * parameter2;
      program.instructionPointer += 4;
      break;
    case OpCode.Input:
      memory[address1] = inputs[inputPointer];
      program.inputPointer = inputPointer + 1;
      program.instructionPointer += 2;
      break;
    case OpCode.Output:
      program.outputs.push(parameter1);
      hasNewOutput = true;
      program.instructionPointer += 2;
      break;
    case OpCode.JumpIfTrue:
      if (parameter1 !== 0) {
        program.instructionPointer = parameter2;
      } else {
        program.instructionPointer += 3;
      }
      break;
    case OpCode.JumpIfFalse:
      if (parameter1 === 0) {
        program.instructionPointer = parameter2;
      } else {
        program.instructionPointer += 3;
      }
      break;
    case OpCode.LessThan:
      memory[address3] = parameter1 < parameter2 ? 1 : 0;
      program.instructionPointer += 4;
      break;
    case OpCode.Equals:
      memory[address3] = parameter1 === parameter2 ? 1 : 0;
      program.instructionPointer += 4;
      break;
    case OpCode.SetRelativeBase:
      program.relativeBase = program.relativeBase + parameter1;
      program.instructionPointer += 2;
      break;
    case OpCode.Halt:
      program.instructionPointer = -1;
      break;
    default:
      throw "UNKNOWN OPCODE";
  }

  return hasNewOutput;
};

const executeProgramToNextOutput = (program: Program): void => {
  while (program.instructionPointer !== -1) {
    const hasNewOutput = executeNextInstruction(program);

    if (hasNewOutput) {
      return;
    }
  }
};

const buildProgramFromMemory = (memory: Memory, inputs: Input): Program => {
  return {
    memory,
    inputs,
    outputs: [],
    instructionPointer: 0,
    inputPointer: 0,
    relativeBase: 0,
  };
};

const initialMemory = readInputFile("2019-js/day09-input")
  .split(",")
  .map((x) => parseInt(x, 10));

const program = buildProgramFromMemory(initialMemory, [1]);

while (program.instructionPointer !== -1) {
  executeProgramToNextOutput(program);
}

console.log(`Result: ${program.outputs}`);

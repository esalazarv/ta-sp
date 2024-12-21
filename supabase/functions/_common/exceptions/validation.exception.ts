import { Exception } from "./exception.ts";

export interface ValidationError {
  field?: string;
  message: string;
}

export class ValidationException extends Exception {
  code = "VALIDATION_ERROR";
  statusCode = 400;
  errors: ValidationError[];

  constructor(message = "Validation failed", errors: ValidationError[] = []) {
    super(message);
    this.name = "ValidationException";
    this.errors = errors;
  }
}

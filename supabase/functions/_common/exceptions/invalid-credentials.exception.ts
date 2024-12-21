import { Exception } from "./exception.ts";

export class InvalidCredentialsException extends Exception {
    code = "INVALID_CREDENTIALS";
    statusCode = 401;
}

import { Exception } from "./exception.ts";

export class InvalidTokenException extends Exception {
    code = "INVALID_TOKEN";
    statusCode = 401;
}

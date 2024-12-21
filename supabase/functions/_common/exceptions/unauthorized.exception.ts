import { Exception } from "./exception.ts";

export class UnauthorizedException extends Exception {
    statusCode = 401;
    code = "UNAUTHORIZED";
}

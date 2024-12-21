import { Exception } from "./exception.ts";

export class NotFoundException extends Exception {
    code = "NOT_FOUND";
    statusCode = 404;
}

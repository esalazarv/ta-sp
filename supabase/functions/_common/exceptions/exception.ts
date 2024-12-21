export abstract class Exception extends Error {
  abstract code: string;
  abstract statusCode: number;
}

import type { Context } from "hono";
import { HTTPException } from "hono/http-exception";
import { ValidationException } from "../../_common/exceptions/validation.exception.ts";
import { Exception } from "../../_common/exceptions/exception.ts";
import { StatusCode } from "https://deno.land/x/hono@v4.3.11/utils/http-status.ts";

export const errorHandler = (err: Error, c: Context) => {
  console.error(err);

  if (err instanceof ValidationException) {
    return c.json({
      error: { code: err.code, message: err.message },
      errors: err.errors,
    }, 400);
  }

  if (err instanceof Exception) {
    return c.json(
      { error: { code: err.code, message: err.message } },
      err.statusCode as StatusCode,
    );
  }

  if (err instanceof HTTPException) {
    return c.json({
      error: { code: err.name, message: err.message },
    }, err.status);
  }

  // Default error handler
  return c.json({
    error: {
      code: "INTERNAL_SERVER_ERROR",
      message: err.message,
    },
  }, 500);
};

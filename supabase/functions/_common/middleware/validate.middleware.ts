import type { Context, MiddlewareHandler } from "hono";
import { z } from "zod";
import { ValidationException } from "../exceptions/validation.exception.ts";

/**
 * Creates a validation middleware for request body using a Zod schema
 */
export function validate<T extends z.ZodType>(
  schema: T,
): MiddlewareHandler {
  return async (c: Context, next) => {
    try {
      const contentType = c.req.header("content-type") || "";
      console.log("Content-Type:", contentType);
      let parsedBody: unknown;

      try {
        if (contentType.includes("multipart/form-data")) {
          parsedBody = await c.req.parseBody();
        } else {
          parsedBody = await c.req.json();
        }
      } catch (e) {
        console.error("Error parsing request body:", e);
        parsedBody = {};
      }

      // Validate body against schema
      const result = schema.safeParse(parsedBody);
      if (!result.success) {
        console.error("Validation errors:", result.error.errors);
        throw new ValidationException(
          "Invalid request body",
          result.error.errors.map((err) => ({
            field: err.path.join("."),
            message: err.message,
          })),
        );
      }

      // Add validated body to context variables
      c.set("validated", result.data);
      await next();
    } catch (error) {
      if (error instanceof ValidationException) {
        throw error;
      }
      throw new ValidationException(
        "Invalid request format",
        [{ message: error instanceof Error ? error.message : "Unknown error" }],
      );
    }
  };
}

/**
 * Type-safe getter for validated request body
 */
export function getBody<T>(c: Context): T {
  return c.get("validated");
}

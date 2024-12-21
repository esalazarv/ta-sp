import { Context } from "hono";

export function showApiInfo(ctx: Context) {
    return ctx.json({
        name: "API",
        version: "1.0.0",
    });
}

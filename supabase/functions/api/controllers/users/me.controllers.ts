import { Context } from "hono";
import { currentUser } from "../../../_common/middleware/auth.middleware.ts";

export function me(ctx: Context) {
    const user = currentUser(ctx);

    return ctx.json(user);
}

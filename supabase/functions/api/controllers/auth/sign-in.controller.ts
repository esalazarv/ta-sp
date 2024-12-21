import { z } from "zod";
import { Context } from "hono";
import { getBody } from "../../../_common/middleware/validate.middleware.ts";
import { credentialsSignIn } from "../../../_common/services/credentials-sign-in.service.ts";

export const signInSchema = z.object({
    email: z.string().email(),
    password: z.string(),
});

export type SignInSchema = z.infer<typeof signInSchema>;

export async function signIn(ctx: Context) {
    const body = getBody<SignInSchema>(ctx);
    const result = await credentialsSignIn(body);

    return ctx.json(result);
}

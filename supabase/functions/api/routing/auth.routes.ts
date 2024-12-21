import { Hono } from "hono";
import { validate } from "../../_common/middleware/validate.middleware.ts";
import {
    signIn,
    signInSchema,
} from "../controllers/auth/sign-in.controller.ts";

const router = new Hono();

router.post("/sign-in", validate(signInSchema), signIn);

export default router;

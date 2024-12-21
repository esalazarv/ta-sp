import { Hono } from "hono";
import { errorHandler } from "../_common/middleware/error.middleware.ts";
import { showApiInfo } from "./controllers/root.controller.ts";
import authRouter from "./routing/auth.routes.ts";
import userRouter from "./routing/user.routes.ts";

const functionName = "api";
const app = new Hono().basePath(`/${functionName}`);

app.get("/", showApiInfo);
app.route("/auth", authRouter);
app.route("/users", userRouter);

app.onError(errorHandler);
Deno.serve(app.fetch);

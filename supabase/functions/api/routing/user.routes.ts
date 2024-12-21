import { Hono } from "hono";
import { me } from "../controllers/users/me.controllers.ts";
import { auth } from "../../_common/middleware/auth.middleware.ts";

const router = new Hono();

router.use(auth);
router.get("/me", me);

export default router;

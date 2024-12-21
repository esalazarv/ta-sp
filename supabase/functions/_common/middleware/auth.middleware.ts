import type { Context, MiddlewareHandler } from "hono";
import { supabase } from "../lib/supabase.client.ts";
import { InvalidTokenException } from "../exceptions/invalid-token.exception.ts";
import { UnauthorizedException } from "../exceptions/unauthorized.exception.ts";
import { UserRepository } from "../repositories/user.repository.ts";
import { OrganizationRepository } from "../repositories/organization.repository.ts";
import { WorkspaceRepository } from "../repositories/workspace.repository.ts";

declare module "hono" {
    interface ContextVariableMap {
        user: any;
        organization: any;
        workspace: any;
    }
}

export const auth: MiddlewareHandler = async (c, next) => {
    const token = c.req.header("Authorization")?.split(" ")[1];
    const workspaceId = c.req.header("x-workspace-id");

    if (!token) {
        throw new InvalidTokenException("No token provided");
    }

    const { data, error } = await supabase.auth.getUser(token);
    const isValidAuth = data.user && !error;

    if (!isValidAuth) {
        throw new UnauthorizedException("Invalid token");
    }

    const user = await UserRepository.findUserByAuthIdOrFail(
        data.user.id,
    );

    const [organization, workspace] = await Promise.all([
        OrganizationRepository.findOneByOrFail({ id: user.organization_id }),
        WorkspaceRepository.findOneByOrFail({
            id: workspaceId || user.default_workspace_id,
        }),
    ]);

    c.set("user", user);
    c.set("organization", organization);
    c.set("workspace", workspace);

    await next();
};

export function currentUser(c: Context) {
    return c.get("user");
}

export function currentOrganization(c: Context) {
    return c.get("organization");
}

export function currentWorkspace(c: Context) {
    return c.get("workspace");
}

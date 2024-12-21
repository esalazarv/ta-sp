import { NotFoundException } from "../exceptions/not-found.exception.ts";
import { supabase } from "../lib/supabase.client.ts";

export const UserRepository = {
    async findUserByAuthIdOrFail(authId: string) {
        const { data, error } = await supabase
            .from("users")
            .select("*")
            .eq("auth_id", authId)
            .maybeSingle();

        if (error) {
            throw new Error(error.message);
        }

        if (!data) {
            throw new NotFoundException("User not found");
        }

        return data;
    },
};

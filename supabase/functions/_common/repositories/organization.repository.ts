import { NotFoundException } from "../exceptions/not-found.exception.ts";
import { supabase } from "../lib/supabase.client.ts";

export const OrganizationRepository = {
    async findOneByOrFail(filter: { id: string }) {
        const query = supabase
            .from("organizations")
            .select("*");

        if (filter.id) {
            query.eq("id", filter.id);
        }

        const { data, error } = await query.maybeSingle();

        if (error) {
            throw new Error(error.message);
        }

        if (!data) {
            throw new NotFoundException("Organization not found");
        }

        return data;
    },
};

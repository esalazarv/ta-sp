import { createClient } from "jsr:@supabase/supabase-js";

export const supabase = createClient(
    Deno.env.get("CUSTOM_SUPABASE_URL") || Deno.env.get("SUPABASE_URL") || "",
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "",
);

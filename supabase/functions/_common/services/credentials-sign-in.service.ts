import { InvalidCredentialsException } from "../exceptions/invalid-credentials.exception.ts";
import { supabase } from "../lib/supabase.client.ts";

export interface Credentials {
    email: string;
    password: string;
}

export async function credentialsSignIn(credentials: Credentials) {
    const { email, password } = credentials;

    const { data, error } = await supabase.auth.signInWithPassword({
        email,
        password,
    });

    if (error) {
        console.error(error);
        throw new InvalidCredentialsException("Invalid credentials");
    }

    const { session } = data;

    return {
        access_token: session.access_token,
        refresh_token: session.refresh_token,
        expires_at: session.expires_in,
    };
}

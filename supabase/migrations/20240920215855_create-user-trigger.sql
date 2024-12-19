CREATE OR REPLACE FUNCTION public.create_user_for_auth_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
  INSERT INTO public.users (id, auth_id, email, phone_number)
  SELECT gen_random_uuid(), new.id, new.email, new.phone;

  RETURN new;
END;
$function$
;

CREATE trigger create_new_user_for_auth_user 
AFTER INSERT ON auth.users for each row execute function public.create_user_for_auth_user();
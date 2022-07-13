SET check_function_bodies = false;
CREATE TABLE public.sectoral_approach (
    id integer NOT NULL,
    region_code text NOT NULL,
    submission_id text NOT NULL,
    value_type_short text NOT NULL,
    pollutant_chemical text,
    fuel_id text,
    product_id text,
    species_id text,
    scenario text DEFAULT 'REF'::text NOT NULL,
    crf_variable_id integer,
    confidential boolean NOT NULL,
    unit text NOT NULL
);
CREATE FUNCTION public.activity_for_sectoral_approach(activity_row public.sectoral_approach) RETURNS text
    LANGUAGE sql STABLE
    AS $$
  SELECT activity_code FROM sectoral_approach_activities WHERE time_series_id = activity_row.id AND leaf
$$;
CREATE TABLE public.sectoral_approach_activities (
    id integer NOT NULL,
    time_series_id integer NOT NULL,
    activity_code text NOT NULL,
    level smallint NOT NULL,
    leaf boolean NOT NULL,
    CONSTRAINT sectoral_approach_activities_level_check CHECK ((level >= 0))
);
CREATE FUNCTION public.activity_is_category(activity_row public.sectoral_approach_activities) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  SELECT activity_row.activity_code SIMILAR TO '(REFERENCE_APPROACH|SECTORAL_APPROACH|\d%)'
$$;
CREATE FUNCTION public.set_current_timestamp_modified_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new.modified_at = NOW();
  RETURN _new;
END;
$$;
CREATE TABLE public.activity (
    code text NOT NULL,
    label_en text NOT NULL,
    label_de text,
    tree_label_en text,
    tree_label_de text,
    image_url text,
    order_by smallint NOT NULL,
    part_of text,
    CONSTRAINT activity_code_check CHECK ((char_length(code) > 0)),
    CONSTRAINT activity_label_de_check CHECK ((char_length(label_de) > 0)),
    CONSTRAINT activity_label_en_check CHECK ((char_length(label_en) > 0)),
    CONSTRAINT activity_order_by_check CHECK ((order_by >= 0)),
    CONSTRAINT activity_tree_label_de_check CHECK ((char_length(tree_label_de) > 0)),
    CONSTRAINT activity_tree_label_en_check CHECK ((char_length(tree_label_en) > 0))
);
CREATE TABLE public.crf_variable (
    id integer NOT NULL,
    variable text NOT NULL,
    submission text NOT NULL,
    category text NOT NULL,
    export boolean NOT NULL,
    unit text,
    text text,
    name text NOT NULL,
    commodity text NOT NULL,
    source text NOT NULL,
    target text NOT NULL,
    option text NOT NULL,
    method text NOT NULL,
    activity text NOT NULL,
    attribute text NOT NULL,
    gas text NOT NULL
);
CREATE SEQUENCE public.crf_variable_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.crf_variable_id_seq OWNED BY public.crf_variable.id;
CREATE TABLE public.fuel (
    id text NOT NULL,
    fossil boolean NOT NULL,
    category text NOT NULL,
    label_en text NOT NULL,
    label_de text,
    order_by smallint NOT NULL,
    CONSTRAINT fuel_id_check CHECK ((char_length(id) >= 2)),
    CONSTRAINT fuel_label_de_check CHECK ((char_length(label_de) > 0)),
    CONSTRAINT fuel_label_en_check CHECK ((char_length(label_en) > 0)),
    CONSTRAINT fuel_order_by_check CHECK ((order_by >= 0))
);
CREATE TABLE public.fuel_category (
    name text NOT NULL
);
CREATE TABLE public.notation_key (
    key text NOT NULL,
    label text NOT NULL
);
CREATE TABLE public.pollutant (
    chemical text NOT NULL,
    category text NOT NULL,
    label_en text NOT NULL,
    label_de text,
    order_by smallint NOT NULL,
    CONSTRAINT pollutant_chemical_check CHECK ((char_length(chemical) >= 2)),
    CONSTRAINT pollutant_label_de_check CHECK ((char_length(label_de) > 0)),
    CONSTRAINT pollutant_label_en_check CHECK ((char_length(label_en) > 0)),
    CONSTRAINT pollutant_order_by_check CHECK ((order_by >= 0))
);
CREATE TABLE public.pollutant_category (
    name text NOT NULL,
    comment text NOT NULL
);
CREATE TABLE public.product (
    id text NOT NULL,
    label_en text NOT NULL,
    label_de text,
    order_by smallint NOT NULL,
    CONSTRAINT product_id_check CHECK ((char_length(id) >= 2)),
    CONSTRAINT product_label_de_check CHECK ((char_length(label_de) > 0)),
    CONSTRAINT product_label_en_check CHECK ((char_length(label_en) > 0)),
    CONSTRAINT product_order_by_check CHECK ((order_by >= 0))
);
CREATE TABLE public.region (
    code text NOT NULL,
    label_en text NOT NULL,
    label_de text,
    order_by smallint NOT NULL,
    part_of text,
    CONSTRAINT region_code_check CHECK ((char_length(code) >= 2)),
    CONSTRAINT region_label_de_check CHECK ((char_length(label_de) > 0)),
    CONSTRAINT region_label_en_check CHECK ((char_length(label_en) > 0)),
    CONSTRAINT region_order_by_check CHECK ((order_by >= 0))
);
CREATE SEQUENCE public.sectoral_approach_activities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.sectoral_approach_activities_id_seq OWNED BY public.sectoral_approach_activities.id;
CREATE SEQUENCE public.sectoral_approach_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.sectoral_approach_id_seq OWNED BY public.sectoral_approach.id;
CREATE TABLE public.sectoral_approach_value (
    time_series_id integer NOT NULL,
    year smallint NOT NULL,
    value numeric DEFAULT 0.0 NOT NULL,
    notation_key text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text NOT NULL,
    modified_at timestamp with time zone DEFAULT now() NOT NULL,
    modified_by text NOT NULL,
    deleted_by text,
    deleted_at timestamp with time zone,
    CONSTRAINT sectoral_approach_value_delete_check CHECK ((((deleted_at IS NULL) AND (deleted_by IS NULL)) OR ((deleted_at IS NOT NULL) AND (deleted_by IS NOT NULL)))),
    CONSTRAINT sectoral_approach_value_year_check CHECK ((year >= 0))
);
CREATE TABLE public.species (
    id text NOT NULL,
    label_en text NOT NULL,
    label_de text,
    order_by smallint NOT NULL,
    CONSTRAINT species_id_check CHECK ((char_length(id) >= 2)),
    CONSTRAINT species_label_de_check CHECK ((char_length(label_de) > 0)),
    CONSTRAINT species_label_en_check CHECK ((char_length(label_en) > 0)),
    CONSTRAINT species_order_by_check CHECK ((order_by >= 0))
);
CREATE TABLE public.submission (
    id text NOT NULL,
    region_code text NOT NULL,
    date date NOT NULL,
    label_en text NOT NULL,
    label_de text,
    order_by smallint NOT NULL,
    CONSTRAINT submission_label_de_check CHECK ((char_length(label_de) > 0)),
    CONSTRAINT submission_label_en_check CHECK ((char_length(label_en) > 0)),
    CONSTRAINT submission_order_by_check CHECK ((order_by >= 0))
);
CREATE TABLE public."user" (
    id text NOT NULL,
    full_name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted boolean DEFAULT false NOT NULL
);
CREATE TABLE public.value_type (
    short text NOT NULL,
    label_en text NOT NULL,
    label_de text,
    order_by smallint NOT NULL,
    CONSTRAINT value_type_label_de_check CHECK ((char_length(label_de) > 0)),
    CONSTRAINT value_type_label_en_check CHECK ((char_length(label_en) > 0)),
    CONSTRAINT value_type_order_by_check CHECK ((order_by >= 0)),
    CONSTRAINT value_type_short_check CHECK ((char_length(short) >= 2))
);
ALTER TABLE ONLY public.crf_variable ALTER COLUMN id SET DEFAULT nextval('public.crf_variable_id_seq'::regclass);
ALTER TABLE ONLY public.sectoral_approach ALTER COLUMN id SET DEFAULT nextval('public.sectoral_approach_id_seq'::regclass);
ALTER TABLE ONLY public.sectoral_approach_activities ALTER COLUMN id SET DEFAULT nextval('public.sectoral_approach_activities_id_seq'::regclass);
ALTER TABLE ONLY public.activity
    ADD CONSTRAINT activity_pkey PRIMARY KEY (code);
ALTER TABLE ONLY public.crf_variable
    ADD CONSTRAINT crf_variable_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.crf_variable
    ADD CONSTRAINT crf_variable_variable_submission_key UNIQUE (variable, submission);
ALTER TABLE ONLY public.fuel_category
    ADD CONSTRAINT fuel_category_pkey PRIMARY KEY (name);
ALTER TABLE ONLY public.fuel
    ADD CONSTRAINT fuel_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.notation_key
    ADD CONSTRAINT notation_key_pkey PRIMARY KEY (key);
ALTER TABLE ONLY public.pollutant_category
    ADD CONSTRAINT pollutant_category_pkey PRIMARY KEY (name);
ALTER TABLE ONLY public.pollutant
    ADD CONSTRAINT pollutant_pkey PRIMARY KEY (chemical);
ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.region
    ADD CONSTRAINT region_pkey PRIMARY KEY (code);
ALTER TABLE ONLY public.sectoral_approach_activities
    ADD CONSTRAINT sectoral_approach_activities_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.sectoral_approach_activities
    ADD CONSTRAINT sectoral_approach_activities_time_series_id_activity_code_key UNIQUE (time_series_id, activity_code);
ALTER TABLE ONLY public.sectoral_approach
    ADD CONSTRAINT sectoral_approach_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.sectoral_approach_value
    ADD CONSTRAINT sectoral_approach_value_time_series_id_year_key UNIQUE (time_series_id, year);
ALTER TABLE ONLY public.species
    ADD CONSTRAINT species_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.submission
    ADD CONSTRAINT submission_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.value_type
    ADD CONSTRAINT value_type_pkey PRIMARY KEY (short);
CREATE TRIGGER set_public_sectoral_approach_value_modified_at BEFORE UPDATE ON public.sectoral_approach_value FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_modified_at();
ALTER TABLE ONLY public.activity
    ADD CONSTRAINT activity_part_of_fkey FOREIGN KEY (part_of) REFERENCES public.activity(code);
ALTER TABLE ONLY public.crf_variable
    ADD CONSTRAINT crf_variable_category_fkey FOREIGN KEY (category) REFERENCES public.activity(code);
ALTER TABLE ONLY public.crf_variable
    ADD CONSTRAINT crf_variable_submission_fkey FOREIGN KEY (submission) REFERENCES public.submission(id);
ALTER TABLE ONLY public.fuel
    ADD CONSTRAINT fuel_category_fkey FOREIGN KEY (category) REFERENCES public.fuel_category(name);
ALTER TABLE ONLY public.pollutant
    ADD CONSTRAINT pollutant_category_fkey FOREIGN KEY (category) REFERENCES public.pollutant_category(name);
ALTER TABLE ONLY public.region
    ADD CONSTRAINT region_part_of_fkey FOREIGN KEY (part_of) REFERENCES public.region(code);
ALTER TABLE ONLY public.sectoral_approach_activities
    ADD CONSTRAINT sectoral_approach_activities_activity_code_fkey FOREIGN KEY (activity_code) REFERENCES public.activity(code);
ALTER TABLE ONLY public.sectoral_approach_activities
    ADD CONSTRAINT sectoral_approach_activities_time_series_id_fkey FOREIGN KEY (time_series_id) REFERENCES public.sectoral_approach(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.sectoral_approach
    ADD CONSTRAINT sectoral_approach_crf_variable_id_fkey FOREIGN KEY (crf_variable_id) REFERENCES public.crf_variable(id);
ALTER TABLE ONLY public.sectoral_approach
    ADD CONSTRAINT sectoral_approach_fuel_id_fkey FOREIGN KEY (fuel_id) REFERENCES public.fuel(id);
ALTER TABLE ONLY public.sectoral_approach
    ADD CONSTRAINT sectoral_approach_pollutant_chemical_fkey FOREIGN KEY (pollutant_chemical) REFERENCES public.pollutant(chemical);
ALTER TABLE ONLY public.sectoral_approach
    ADD CONSTRAINT sectoral_approach_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(id);
ALTER TABLE ONLY public.sectoral_approach
    ADD CONSTRAINT sectoral_approach_region_code_fkey FOREIGN KEY (region_code) REFERENCES public.region(code);
ALTER TABLE ONLY public.sectoral_approach
    ADD CONSTRAINT sectoral_approach_species_id_fkey FOREIGN KEY (species_id) REFERENCES public.species(id);
ALTER TABLE ONLY public.sectoral_approach
    ADD CONSTRAINT sectoral_approach_submission_id_fkey FOREIGN KEY (submission_id) REFERENCES public.submission(id);
ALTER TABLE ONLY public.sectoral_approach_value
    ADD CONSTRAINT sectoral_approach_value_created_by_fkey FOREIGN KEY (created_by) REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.sectoral_approach_value
    ADD CONSTRAINT sectoral_approach_value_deleted_by_fkey FOREIGN KEY (deleted_by) REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.sectoral_approach_value
    ADD CONSTRAINT sectoral_approach_value_modified_by_fkey FOREIGN KEY (modified_by) REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.sectoral_approach_value
    ADD CONSTRAINT sectoral_approach_value_notation_key_fkey FOREIGN KEY (notation_key) REFERENCES public.notation_key(key);
ALTER TABLE ONLY public.sectoral_approach_value
    ADD CONSTRAINT sectoral_approach_value_time_series_id_fkey FOREIGN KEY (time_series_id) REFERENCES public.sectoral_approach(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.sectoral_approach
    ADD CONSTRAINT sectoral_approach_value_type_short_fkey FOREIGN KEY (value_type_short) REFERENCES public.value_type(short);
ALTER TABLE ONLY public.submission
    ADD CONSTRAINT submission_region_code_fkey FOREIGN KEY (region_code) REFERENCES public.region(code);

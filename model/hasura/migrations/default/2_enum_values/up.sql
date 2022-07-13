SET check_function_bodies = false;
INSERT INTO public.fuel_category (name) VALUES ('GASEOUS');
INSERT INTO public.fuel_category (name) VALUES ('LIQUID');
INSERT INTO public.fuel_category (name) VALUES ('SOLID');
INSERT INTO public.notation_key (key, label) VALUES ('NE', 'Not Estimated');
INSERT INTO public.notation_key (key, label) VALUES ('NA', 'Not Applicable');
INSERT INTO public.notation_key (key, label) VALUES ('NO', 'Not Occuring');
INSERT INTO public.notation_key (key, label) VALUES ('IE', 'Included Elsewhere');
INSERT INTO public.notation_key (key, label) VALUES ('C', 'Confidential');
INSERT INTO public.pollutant_category (name, comment) VALUES ('GHG', 'Greenhouse gases');
INSERT INTO public.pollutant_category (name, comment) VALUES ('AP', 'Air pollutants');
INSERT INTO public.pollutant_category (name, comment) VALUES ('TSP', 'Dust and particles');
INSERT INTO public.pollutant_category (name, comment) VALUES ('HM', 'Heavy metals');
INSERT INTO public.pollutant_category (name, comment) VALUES ('POP', 'Persistent organic pollutants');
INSERT INTO public.pollutant_category (name, comment) VALUES ('Other', 'Other pollutants');
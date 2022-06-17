### ZSEnext
Emission inventory tool based on PostgreSQL, Hasura/GraphQL and a web frontend.

### Usage
1. Clone this repository to a machine with `docker` and `docker-compose` installed
2. Create an `.env` file in the project directory and put passwords
3. Optional: Update the Caddyfile to match your domain settings
4. From the project directory, run `docker-compose up -d`
   - Postgres will be at `http://&lt;your-ip&gt;:5432'
   - pgAdmin will be at `http://&lt;your-ip&gt;:5050'
   - Hasura will be at `http://&lt;your-ip&gt;:8080' 
5. Optional: Put sample data
   - Install the Hasura CLI
   - Add a `config.yaml` to model/hasura
   - Run `hasura seed apply` from `model/hasura`

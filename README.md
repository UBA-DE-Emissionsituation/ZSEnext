## ZSEnext
An emission inventory tool based on PostgreSQL, Hasura/GraphQL and a React web frontend.

### Usage
1. Clone this repository to a machine with `docker`, `docker-compose` and `nodejs` installed
2. Create an `.env` file in the project directory and put passwords and other context info:
   - POSTGRES_PASSWORD=`<password>`
     - Postgres access with user 'postgres' and password given here
   - PGADMIN_DEFAULT_EMAIL=`<address>`
   - PGADMIN_DEFAULT_PASSWORD=`<password>`
   - HASURA_GRAPHQL_ADMIN_SECRET=`<password>`
   - REACT_APP_GRAPHQL_ENDPOINT=`<url>`
     - Should look something like `https://<your-domain>/v1/graphql` 
3. Optional: Update the `./Caddyfile` to match your domain settings
4. Move to the `./view` directory and execute `npm install`
5. From the project directory, run `docker-compose up -d` and find (depending on your Caddy configuration):
   - Postgres at `postgres://postgres:<POSTGRES_PASSWORD>@example.com:5432/postgres`
   - pgAdmin at `https://pgadmin.example.com` (or `http://<your-ip>:5050`)
   - Hasura at `https://hasura.example.com` (or `http://<your-ip>:8080`)
   - ZSEnext at `https://www.example.com`
6. Optional: Put sample data
   - Install the Hasura CLI, see https://hasura.io/docs/latest/graphql/core/hasura-cli/install-hasura-cli/
   - Add a `config.yaml` to `model/hasura` (refer to `config.example.yaml` for inspiration)
   - Run `hasura seed apply` from `model/hasura`

### Start over
0. CAUTION: These commands assume that your docker installation runs nothing but this app!
1. Stop all docker containers: `docker stop $(docker ps -aq)`
2. Remove all docker containers: `docker rm $(docker ps -aq)`
3. Delete all volumes: `docker volume prune`
4. Run `docker-compose up -d` again from the project directory
   - Note that Let's Encrypt certs used by Caddy are rate-limited, you will run into issues if you repeat this too often.

# wwWallet-stack Docker Compose

This project uses a **modular Docker Compose setup** to orchestrate the wwWallet components: 
* [wallet-frontend](https://github.com/wwWallet/wallet-frontend/)
* [wallet-backend](https://github.com/wwwallet/wallet-backend-server/)
* [wallet-issuer](https://github.com/wwWallet/wallet-ecosystem/)
* [wallet-verifier](https://github.com/wwWallet/wallet-ecosystem/)
* [Caddy reverse proxy](https://hub.docker.com/_/caddy)

The configuration is split into a main compose file and an override file to support different environments. The compose files use modern features, so make sure you are running Compose v2+. Podman (with docker-compose-v2) is untested.  

The wwWallet components *should* be Git submodules and code owners of those modules *should* co-ordinate with this repository to keep environment variables and versions updated. Let's help each other.  

If any Docker Compose feature is confusing, please see the links in the Reference section. There are also a lot of tips and trick in the Docker Compose documentation that can be handy.

---

## File Overview

- **`compose.yaml`**  
  The main Compose file. It includes all component (compose) service definitions by referencing the components individual `compose.yaml` files in the `components/` subdirectories.

- **`compose.override.yaml`**  
  An (optional) override file. This is automatically picked up by Docker Compose and allows you to customize or override settings (e.g., ports, networks) for local development or specific environments. 

- **`.env.template`**  
  An .env template to override environment variables and .env files in the (compose) services. The template *should* include all relevant environment variables in the components.

---

## How It Works

### Main Compose File (`compose.yaml`)

- **Purpose:**  
  Aggregates all (compose) service definitions into a single stack.
- **How it works:**  
  To support high modularity, each wwWallet component `compose.yaml` is defined in its own file.

### Override File (`compose.override.yaml`)

- **Purpose:**  
  Used to override or extend the main configuration.  
  Common use cases:
  - Expose services on interfaces other than localhost
  - Enable or disable services
  - Add or change networks (got your own reverse proxy?)
  - Adjust build contexts, resource limits, volumes, or environment variables
- **How it works:**  
  When you run `docker compose up`, Docker Compose automatically merges `compose.override.yaml` with `compose.yaml`.

---

## Usage

### Starting the Stack

Starting is as simple as running `docker compose up`. 
By default, both `compose.yaml` and `compose.override.yaml` are used.   

### Controlling overrides
You can create additional override files (e.g., `compose.prod.yaml`) and specify them with `-f`:
```sh
docker compose -f compose.yaml -f compose.prod.yaml up -d
```

## Adding or Modifying Services
- Add your service and `compose.yaml` under `components/your-service/`
- Add an `include` entry in the top-level `compose.yaml`.
- Update an overrides in `compose.override.yaml`, if needed.
---

## Troubleshooting

- **Compose confusion:**  
  If the enviroment isn't starting as you expected it to, use the command `docker compose config` to see the resulting compose file. 
  The command can be combined with the `-f` flag.
- **Port conflicts:**  
  If you get port binding errors, you might be trying to bind to all interfaces when the included compose binds to a specific one. 
  The Docker Compose merging rules do not take this scenario into account. Create a `ports` section in the override file for your (compose) service, and use `!override` to clear the `ports` section and only inject your overrides.
- **Extensions/Fragments/YAML aliases and anchors don't work:**  
  Because of the way the "include" feature works, these will only work on anything that is inside the file it is defined in.
- **My linter/IDE is really angry with this YAML!:**  
  Some of the features used (`!override`) haven't been added to the linters yet. At the time of writing, [VSCode for example](https://github.com/microsoft/vscode-docker/issues/4523). Use `docker compose config` and `docker compose up --dry-run` to verify it yourself.

---

## References

- [Docker Compose documentation (how-tos, tips and tricks)](https://docs.docker.com/compose/)
- [Compose file reference (what directives and settings are available)](https://docs.docker.com/reference/compose-file/)
- [Docker Compose environment variable interpolation how-to](https://docs.docker.com/compose/how-tos/environment-variables/variable-interpolation/)
- [Docker Compose enviroment variable interpolation reference](https://docs.docker.com/reference/compose-file/interpolation/)
- [Docker Compose merging rules (multiple compose files)](https://docs.docker.com/compose/how-tos/multiple-compose-files/merge/#merging-rules)
- [Docker Compose "include" how-to](https://docs.docker.com/compose/how-tos/multiple-compose-files/include/)
- [Docker Compose "include" reference](https://docs.docker.com/reference/compose-file/include/)

---  

## Footnote
Together we can make this Docker Compose project modular and easy to use: 
- Submit PRs with different overrides that fit your needs.
- Clarify and update the documentation 
If you ever get stuck or find anything confusing. Don't hesitate to ask for help from of the Ops people in the wwWallet Slack.

# bashman
Postman for the terminal, made with Bash.

A simple Bash-based REST API client designed to mimic Postman functionality — right from your terminal. Ideal for developers who prefer command-line tools or want a lightweight alternative to heavy GUI-based tools like Postman.

---

## ✨ Features

- Supports **GET**, **POST**, **PUT**, **DELETE** requests
- Add **custom headers**, **query parameters**, and **JSON bodies**
- Use **environments** (base URL + token) for reuse
- **Pretty-prints JSON** (requires `jq`)
- Interactive command-line prompts for saving environment configs
- Human-friendly output with **colors**, **status indicators**, and **examples**

---

## 📁 Folder Structure

```bash
api-platform/
├── api-client.sh     # The main API client script
└── README.md         # You're reading this!
```

---

## 🚀 Getting Started

1. Clone the folder or download the script.

```bash
chmod +x api-client.sh
```

2. Run a simple GET request:

```bash
./api-client.sh GET https://jsonplaceholder.typicode.com/posts
```

3. Add headers and body for a POST request:

```bash
./api-client.sh POST https://example.com/api -d '{"name":"John"}' -H "Authorization: Bearer <token>"
```

4. Save a reusable environment:

```bash
./api-client.sh --save-env
```

Then use it:

```bash
./api-client.sh GET /users -e dev
```

---

## 🔧 Options

| Flag             | Description                                  |
|------------------|----------------------------------------------|
| `-d`, `--data`   | JSON payload for POST/PUT                    |
| `-H`, `--header` | Add custom headers (can be repeated)         |
| `-q`, `--query`  | Add query params as key=value                |
| `-e`, `--env`    | Use a saved environment                      |
| `--save-env`     | Save a new environment (name, URL, token)    |
| `--list-envs`    | Show saved environments                      |
| `--help`, `-h`   | Show usage help                              |
| `--desc`, `-desc`| Show a short description of this CLI tool    |

---

## 🔍 Description Output

You can run the following to get a brief idea about what the tool does:

```bash
./api-client.sh --desc
```

This prints:

```bash
API Client — A Postman-style interactive REST API tool for your terminal. Supports headers, tokens, environments, pretty JSON responses, and much more.
```

---

## 📁 Environment Storage

Environments are stored at:

```
~/.api_client_envs
```

Format:

```bash
<name>|<base_url>|<token>
```

Example:

```bash
dev|https://dev.api.com|eyJhbGciOi...
```

---

## 🎓 Dependencies

- Bash
- curl
- Optional: [jq](https://stedolan.github.io/jq/) (for pretty-printing JSON)

Install `jq` on Ubuntu:
```bash
sudo apt install jq
```

---

## 🎉 Contribute / Extend

This script is intentionally modular. You can easily:

- Add OAuth2 support
- Add export-to-file option
- Add API test suites or health checks

Feel free to fork and enhance it further!

---

## ❤️ Credits

Crafted with love for all CLI lovers and terminal warriors. Ditch the GUI, script your flows!




### 📂 Supported Stacks

- `angular.Dockerfile`
- `mongodb.Dockerfile`
- `nginx.Dockerfile`
- `node.Dockerfile`
- `php.Dockerfile`
- `react.Dockerfile`
- `redis.Dockerfile`
- `flask.Dockerfile`
- `phpmyadmin.Dockerfile`
- `mailhog.Dockerfile`
- `pgadmin.Dockerfile`

---

## 🔧 How to Build All Images
```bash
docker build --build-arg VERSION=latest  --build-arg HOST_UID=1000  -f name.Dockerfile -t name:local 
```

## EXAMPLE 
```bash
docker build --build-arg VERSION=latest  --build-arg HOST_UID=1000 -f mariadb.Dockerfile -t mariadb:local .
```
## FOR MORE INFO CHECK docker-compose.yml
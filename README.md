
### 📂 Supported Stacks

- `angular.Dockerfile`
- `mariadb.Dockerfile`
- `mongodb.Dockerfile`
- `mssql.Dockerfile`
- `nginx.Dockerfile`
- `node.Dockerfile`
- `php.Dockerfile`
- `postgress.Dockerfile`
- `react.Dockerfile`
- `redis.Dockerfile`

---

## 🔧 How to Build All Images
```bash
docker build  -f name.Dockerfile -t name:latest
```

## EXAMPLE 
```bash
docker build -f mariadb.Dockerfile -t mariadb:latest .
```
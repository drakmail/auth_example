# README

## Usage

```
bundle
cp config/database.example.yml config/database.yml
# vim config/database.yml to update values (or just create db)
./bin/rails db:migrate
./bin/rails s
```

## Specs

```
./bin/rails db:migrate RAILS_ENV=test
./bin/rspec
```

## Linter

```
gem install rubocop
rubocop
```

## Usage and Endpoints

For testing you can use following JWT token: `eyJhbGciOiJub25lIn0.eyJzdWIiOiJjYWxsZXIifQ.`.

### Create user

```
curl -H 'Content-Type: application/json' -H 'Authorization: Bearer eyJhbGciOiJub25lIn0.eyJzdWIiOiJjYWxsZXIifQ.' -d '{"user": {"username": "drakmail"}}' http://localhost:3000/api/v1/users
```

### Create role

```
curl -H 'Content-Type: application/json' -H 'Authorization: Bearer eyJhbGciOiJub25lIn0.eyJzdWIiOiJjYWxsZXIifQ.' -d '{"role": {"title": "sysadmin"}}' http://localhost:3000/api/v1/roles
```

### Create permissions

```
curl -H 'Content-Type: application/json' -H 'Authorization: Bearer eyJhbGciOiJub25lIn0.eyJzdWIiOiJjYWxsZXIifQ.' -d '{"permission": {"action": "reboot_server", "resource": "127.0.0.1"} }' http://localhost:3000/api/v1/permissions
```

### Assign permissions to role

```
curl -H 'Content-Type: application/json' -H 'Authorization: Bearer eyJhbGciOiJub25lIn0.eyJzdWIiOiJjYWxsZXIifQ.' -d '{"role_permission": {"role_title": "sysadmin", "permission_action": "reboot_server", "permission_resource": "127.0.0.1"} }' http://localhost:3000/api/v1/role_permissions
```

### Assign role to user

```
curl -H 'Content-Type: application/json' -H 'Authorization: Bearer eyJhbGciOiJub25lIn0.eyJzdWIiOiJjYWxsZXIifQ.' -d '{"user_role": {"role": "sysadmin", "user": "drakmail"}}' http://localhost:3000/api/v1/user_roles
```

### Check user permissions

```
curl -H 'Content-Type: application/json' -H 'Authorization: Bearer eyJhbGciOiJub25lIn0.eyJzdWIiOiJjYWxsZXIifQ.' http://localhost:3000/api/v1/user_permissions\?user=drakmail
```

### Assign permissions to user

```
curl -H 'Content-Type: application/json' -H 'Authorization: Bearer eyJhbGciOiJub25lIn0.eyJzdWIiOiJjYWxsZXIifQ.' -d '{"user_permission": {"user": "drakmail", "permission_action": "reboot_server", "permission_resource": "127.0.0.1"} }' http://localhost:3000/api/v1/user_permissions
```

### Remove user permissions for given user

```
curl -X DELETE -H 'Content-Type: application/json' -H 'Authorization: Bearer eyJhbGciOiJub25lIn0.eyJzdWIiOiJjYWxsZXIifQ.' -d '{"user_permission": {"user": "drakmail", "permission_action": "reboot_server", "permission_resource": "127.0.0.1"} }' http://localhost:3000/api/v1/user_permissions
```

### Remove role from user

```
curl -X DELETE -H 'Content-Type: application/json' -H 'Authorization: Bearer eyJhbGciOiJub25lIn0.eyJzdWIiOiJjYWxsZXIifQ.' -d '{"user_role": {"user": "drakmail", "role": "sysadmin"} }' http://localhost:3000/api/v1/user_roles
```

### Remove permissions from role

```
curl -X DELETE -H 'Content-Type: application/json' -H 'Authorization: Bearer eyJhbGciOiJub25lIn0.eyJzdWIiOiJjYWxsZXIifQ.' -d '{"role_permission": {"role_title": "sysadmin", "permission_action": "reboot_server", "permission_resource": "127.0.0.1"} }' http://localhost:3000/api/v1/role_permissions
```

### Remove permission

```
curl -X DELETE -H 'Content-Type: application/json' -H 'Authorization: Bearer eyJhbGciOiJub25lIn0.eyJzdWIiOiJjYWxsZXIifQ.' -d '{"permission": { "action": "reboot_server", "resource": "127.0.0.1"} }' http://localhost:3000/api/v1/permissions
```
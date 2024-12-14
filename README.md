# README

## Setup

```
$ git clone git@github.com:XuanTaiDV/system_project_management.git
$ cd project_management_system
$ bundle install # install gem
$ rake db:create # create db
$ rake db:migrate # migrate database
$ rake db:seed # create mock data

```

## Default user
```
email: tainx@gmail.com
password: 123456
```
## API


### **User Registration**

#### POST `/api/v1/register`
```

**Request:**
- **Authorization:** Not required
- **Payload:**
{
  "user": {
    "email": "",
    "password": "",
    "password_confirmation": ""
  }
}

**Response:**
{
  "email": ""
}
```
---
### **User Login**

#### POST `/api/v1/login`
```

**Request:**
- **Authorization:** Not required
- **Payload:**
{
  "email": "",
  "password": ""
}

**Response:**
{
  "token": ""
}
```
---
### **Projects**

#### GET `/api/v1/projects`
```

**Request:**
- **Headers:**
{
  "Authorization": "Bearer <token>"
}

**Response:**
[
  {
    "name": "",
    "description": ""
  },
  {
    "name": "",
    "description": ""
  }
]
```
---
#### POST `/api/v1/projects`
```

**Request:**
- **Headers:**
{
  "Authorization": "Bearer <token>"
}
- **Payload:**
{
  "project": {
    "name": "",
    "description": ""
  }
}

**Response:**
{
  "name": "",
  "description": ""
}
```

#### PATCH/PUT `/api/v1/projects/:id`
---

```
**Request:**
- **Headers:**
{
  "Authorization": "Bearer <token>"
}
- **Payload:**
{
  "name": "",
  "description": ""
}

**Response:**
{
  "name": "",
  "description": ""
}
```
---
#### DELETE `/api/v1/projects/:id`
```
**Request:**
- **Headers:**
{
  "Authorization": "Bearer <token>"
}

**Response:**
HEAD

---
```
### **Tasks**

#### GET `/api/v1/projects/:project_id/tasks`
```

**Request:**
- **Headers:**
{
  "Authorization": "Bearer <token>"
}

**Response:**
[
  {
    "id": "",
    "title": "",
    "description": "",
    "status": "",
    "due_date": "",
    "project_id": ""
  }
]
```
---
#### POST `/api/v1/projects/:project_id/tasks`

```

**Request:**
- **Headers:**
{
  "Authorization": "Bearer <token>"
}
- **Payload:**
{
  "task": {
    "title": "",
    "description": "",
    "status": "",
    "due_date": ""
  }
}

**Response:**
{
  "id": "",
  "title": "",
  "description": "",
  "status": "",
  "due_date": "",
  "project_id": ""
}
```

#### PATCH/PUT `/api/v1/tasks/:id`
```

**Request:**
- **Headers:**
{
  "Authorization": "Bearer <token>"
}
- **Payload:**
{
  "task": {
    "title": "",
    "description": "",
    "status": "",
    "due_date": ""
  }
}

**Response:**
{
  "id": "",
  "title": "",
  "description": "",
  "status": "",
  "due_date": "",
  "project_id": ""
}
```

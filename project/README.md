# Multi-Profession Services Platform API

This is a RESTful API for a multi-profession services platform built with Node.js, TypeScript, Express, and Prisma with MongoDB.

## Features

- **Authentication**: JWT-based authentication with registration and login
- **Authorization**: Role-based access control (USER, MASTER, ADMIN)
- **Data Models**: User, Master, Admin, Profession, and Review
- **API Documentation**: Swagger UI at `/api-docs`
- **Database**: MongoDB integration via Prisma ORM
- **Error Handling**: Centralized error handling with proper status codes
- **Logging**: Winston logger for development and production
- **Validation**: Request validation with express-validator
- **Security**: Helmet middleware for setting security-related HTTP headers

## Getting Started

### Prerequisites

- Node.js 16+
- MongoDB (local or Atlas)

### Installation

1. Clone the repository

2. Install dependencies

```bash
npm install
```

3. Create a `.env` file in the root directory based on `.env.example`

```
# Database
DATABASE_URL="mongodb+srv://username:password@cluster0.mongodb.net/services_platform?retryWrites=true&w=majority"

# Authentication
JWT_SECRET="your-super-secret-key-change-in-production"
JWT_EXPIRES_IN="7d"

# Server
PORT=5000
NODE_ENV="development"
```

4. Generate Prisma client

```bash
npm run prisma:generate
```

5. Push the Prisma schema to your database

```bash
npm run prisma:push
```

6. Seed the database (optional)

```bash
npm run seed
```

7. Start the development server

```bash
npm run dev
```

### API Documentation

Once the server is running, you can access the Swagger documentation at:

```
http://localhost:5000/api-docs
```

## Project Structure

```
├── prisma/                # Prisma schema and migrations
│   ├── schema.prisma      # Database schema
│   └── seed.ts            # Database seeding script
├── src/
│   ├── config/            # Configuration files
│   │   ├── prisma.ts      # Prisma client configuration
│   │   └── swagger.ts     # Swagger configuration
│   ├── controllers/       # Request handlers
│   ├── middlewares/       # Custom middleware
│   ├── routes/            # API routes
│   ├── services/          # Business logic
│   ├── utils/             # Utility functions
│   └── index.ts           # Application entry point
├── .env.example           # Example environment variables
├── .gitignore             # Git ignore file
├── package.json           # Project dependencies and scripts
├── tsconfig.json          # TypeScript configuration
└── README.md              # Project documentation
```

## API Endpoints

### Authentication

- `POST /api/auth/register` - Register a new user
- `POST /api/auth/login` - Login user
- `GET /api/auth/me` - Get current user

### Professions

- `GET /api/professions` - Get all professions
- `GET /api/professions/:id` - Get single profession
- `POST /api/professions` - Create new profession (Admin only)
- `PUT /api/professions/:id` - Update profession (Admin only)
- `DELETE /api/professions/:id` - Delete profession (Admin only)

### Users, Masters, and Reviews

Additional endpoints for users, masters, and reviews can be implemented as needed.

## License

This project is licensed under the MIT License.
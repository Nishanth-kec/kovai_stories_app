# 🚀 Invoice App - Backend Server

A Node.js/Express REST API for managing invoices, clients, items, and companies with MongoDB.

**Live API:** https://invoice-api.example.com (update when deployed)

---

## 📋 Features

✅ **Authentication**
- JWT-based authentication
- Secure password hashing with bcryptjs
- Role-based access control (owner, user)
- Token generation and validation

✅ **Core Functionality**
- User management and registration
- Company management
- Client management (create, read, update, delete)
- Item management (create, read, update, delete)
- Invoice management (create, read, update, delete, status updates)
- Invoice PDF generation
- File upload support (logos, documents)

✅ **Technical Features**
- Express.js REST API
- MongoDB with Mongoose
- Input validation with express-validator
- CORS enabled
- Request logging with Morgan
- Error handling middleware
- Rate limiting ready

---

## 🛠️ Technology Stack

| Layer | Technology |
|-------|-----------|
| **Runtime** | Node.js v16+ |
| **Framework** | Express.js v5.1.0 |
| **Database** | MongoDB (MongoDB Atlas) |
| **Authentication** | JWT |
| **Security** | bcryptjs, CORS |
| **Validation** | express-validator |
| **Logging** | Morgan |
| **File Upload** | Multer |
| **PDF** | PDF generation library |

---

## 📦 Installation

### 1. Clone Repository
```bash
git clone <repo-url>
cd server
```

### 2. Install Dependencies
```bash
npm install
```

### 3. Environment Setup
```bash
# Copy environment template
cp .env.example .env

# Edit .env with your values:
# - MONGO_URI: MongoDB Atlas connection string
# - JWT_SECRET: Strong random secret (32+ chars)
# - PORT: Server port (default 4000)
```

### 4. Verify Installation
```bash
npm run dev
# Expected output:
# 🚀 Server running on port 4000
# 🟢 MongoDB Connected
```

---

## 🚀 Running the Server

### Development
```bash
npm run dev
# Uses nodemon for auto-reload
```

### Production
```bash
npm start
# Direct Node.js execution
```

### Environment Variables
```bash
PORT=4000
MONGO_URI=mongodb+srv://user:password@cluster.mongodb.net/dbname
JWT_SECRET=your_long_random_secret_key
AUTOMATION_WEBHOOK_URL=https://webhook.example.com
NODE_ENV=production
```

---

## 📚 API Endpoints

### Authentication
```
POST   /api/auth/register    - Register new user & company
POST   /api/auth/login       - Login and get JWT token
```

### Clients
```
GET    /api/clients          - Get all clients
POST   /api/clients          - Create client
GET    /api/clients/:id      - Get client by ID
PUT    /api/clients/:id      - Update client
DELETE /api/clients/:id      - Delete client
```

### Items
```
GET    /api/items            - Get all items
POST   /api/items            - Create item
GET    /api/items/:id        - Get item by ID
PUT    /api/items/:id        - Update item
DELETE /api/items/:id        - Delete item
```

### Invoices
```
GET    /api/invoices         - Get all invoices
POST   /api/invoices         - Create invoice
GET    /api/invoices/:id     - Get invoice by ID
PUT    /api/invoices/:id     - Update invoice
PATCH  /api/invoices/:id/status - Update invoice status
DELETE /api/invoices/:id     - Delete invoice
```

### Company
```
GET    /api/company/me       - Get company info
PUT    /api/company/me       - Update company info
POST   /api/company/logo     - Upload company logo
DELETE /api/company/logo     - Delete company logo
```

### Health Check
```
GET    /                     - Health check & API info
```

---

## 🔐 Authentication

All endpoints except `/api/auth/*` and `/` require JWT token in header:

```bash
curl -H "Authorization: Bearer your_token_here" https://api.example.com/api/clients
```

### Getting a Token
```bash
# 1. Register
curl -X POST http://localhost:4000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "companyName": "Acme Corp",
    "name": "John Doe",
    "email": "john@example.com",
    "password": "securePassword123"
  }'

# 2. Login
curl -X POST http://localhost:4000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "securePassword123"
  }'

# Response includes: { token: "...", user: {...} }
```

---

## 📁 Project Structure

```
server/
├── app.js                      Main application entry point
├── package.json               Dependencies and scripts
├── .env                       Environment variables (git ignored)
├── .env.example              Environment template
├── .gitignore                Git ignore rules
│
├── config/
│   └── db.js                 MongoDB connection
│
├── controllers/
│   ├── authController.js     Authentication endpoints
│   ├── clientsController.js  Client CRUD operations
│   ├── companyController.js  Company management
│   ├── invoicesController.js Invoice CRUD operations
│   └── itemsController.js    Item CRUD operations
│
├── middlewares/
│   ├── auth.js               JWT authentication middleware
│   ├── errorHandler.js       Global error handler
│   └── role.js               Role-based access control
│
├── models/
│   ├── User.js               User schema
│   ├── Company.js            Company schema
│   ├── Client.js             Client schema
│   ├── Item.js               Item schema
│   └── Invoice.js            Invoice schema
│
└── utils/
    ├── jwt.js                JWT token generation
    ├── invoiceNumber.js      Invoice number generator
    ├── pdfGenerator.js       PDF generation utility
    └── automation.js         Webhook automation
```

---

## 🗄️ Database Schema

### User
```javascript
{
  _id: ObjectId,
  companyId: ObjectId,
  name: String,
  email: String (unique),
  passwordHash: String,
  role: String (owner, user),
  createdAt: Date,
  updatedAt: Date
}
```

### Company
```javascript
{
  _id: ObjectId,
  name: String,
  email: String,
  phone: String,
  address: String,
  taxNumber: String,
  logoUrl: String,
  createdAt: Date,
  updatedAt: Date
}
```

### Client
```javascript
{
  _id: ObjectId,
  companyId: ObjectId,
  name: String,
  email: String,
  phone: String,
  address: String,
  notes: String,
  createdAt: Date,
  updatedAt: Date
}
```

### Item
```javascript
{
  _id: ObjectId,
  companyId: ObjectId,
  name: String,
  description: String,
  unitPrice: Number,
  sku: String,
  createdAt: Date,
  updatedAt: Date
}
```

### Invoice
```javascript
{
  _id: ObjectId,
  companyId: ObjectId,
  number: String,
  clientId: ObjectId,
  status: String (draft, sent, paid, overdue),
  items: [{
    description: String,
    qty: Number,
    unitPrice: Number,
    total: Number
  }],
  subTotal: Number,
  tax: Number,
  discount: Number,
  total: Number,
  createdAt: Date,
  updatedAt: Date
}
```

---

## 🧪 Testing

### Manual Testing with cURL
```bash
# Health check
curl http://localhost:4000/

# Register user
curl -X POST http://localhost:4000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"companyName":"Test","name":"User","email":"user@test.com","password":"test123"}'

# Login
curl -X POST http://localhost:4000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@test.com","password":"test123"}'

# Get clients (with token)
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://localhost:4000/api/clients
```

### Using Postman
1. Import endpoints from above
2. Set Authorization header with Bearer token
3. Test each endpoint
4. Verify response codes and data

### Test Cases
- ✅ Register new user
- ✅ Login with credentials
- ✅ Create client
- ✅ Update client
- ✅ Delete client
- ✅ Create invoice
- ✅ Upload company logo
- ✅ Invalid credentials
- ✅ Missing auth token
- ✅ Expired token

---

## 🔒 Security Best Practices

✅ **Implemented**
- JWT token authentication
- Password hashing with bcryptjs
- CORS configured
- Input validation
- Error handling

⚠️ **Recommended for Production**
- Rate limiting (express-rate-limit)
- HTTPS only
- Environment variable validation (added)
- API documentation (Swagger)
- Audit logging
- Database backups
- Secrets management

---

## 📊 Performance Considerations

### Current
- ✅ Efficient MongoDB queries
- ✅ Proper indexing via Mongoose
- ✅ Request size limit (10MB)
- ✅ Error handling

### For Scaling
- Add caching (Redis)
- Database indexing on frequently queried fields
- Connection pooling
- Load balancing
- CDN for static files

---

## 🚀 Deployment

### Render.com (Recommended)
```bash
1. Push code to GitHub
2. Connect repository to Render
3. Set environment variables in dashboard
4. Deploy (auto-deploys on push)
```

### Heroku
```bash
1. heroku login
2. heroku create app-name
3. heroku config:set MONGO_URI=...
4. git push heroku main
```

### AWS/DigitalOcean
```bash
1. SSH into server
2. Install Node.js
3. Clone repository
4. npm install
5. Set environment variables
6. Use PM2 or systemd to run app
7. Set up reverse proxy (Nginx)
```

### Docker (Optional)
```bash
docker build -t invoice-api .
docker run -e MONGO_URI=... -e JWT_SECRET=... -p 4000:4000 invoice-api
```

---

## 📈 Monitoring & Maintenance

### Logs
- Server logs: Check console output
- Database logs: Check MongoDB Atlas dashboard
- Error tracking: Implement error logging service

### Backups
- Database: Enable automated MongoDB Atlas backups
- Code: GitHub version control
- Files: Backup uploaded documents

### Updates
- Keep dependencies updated: `npm outdated`
- Security patches: `npm audit fix`
- Monitor for vulnerabilities

---

## ❓ Troubleshooting

### "Cannot find module"
```bash
# Reinstall dependencies
rm -rf node_modules package-lock.json
npm install
```

### "MongoDB Connection Error"
```bash
# Check MONGO_URI in .env
# Verify IP whitelist in MongoDB Atlas
# Check internet connection
```

### "JWT Secret not found"
```bash
# Add JWT_SECRET to .env
# Restart server
```

### "Port already in use"
```bash
# Change PORT in .env
# Or kill process: lsof -i :4000 | grep LISTEN | awk '{print $2}' | xargs kill -9
```

---

## 📞 Support & Contribution

### Issues
Report issues with:
- Error message
- Request details
- Steps to reproduce
- Expected vs actual behavior

### Contributions
1. Fork repository
2. Create feature branch
3. Make changes
4. Write tests
5. Submit pull request

---

## 📄 License

ISC

---

## 👤 Author

Nishanth

---

## 🗺️ Roadmap

- [ ] API documentation (Swagger/OpenAPI)
- [ ] Advanced reporting
- [ ] Email notifications
- [ ] Payment gateway integration
- [ ] Multi-user collaboration
- [ ] Mobile app sync
- [ ] Advanced analytics
- [ ] Recurring invoices

---

## ✅ Deployment Checklist

Before going live:

- [ ] Update JWT_SECRET to strong value
- [ ] Set NODE_ENV=production
- [ ] Enable HTTPS
- [ ] Set up database backups
- [ ] Configure rate limiting
- [ ] Add monitoring and alerting
- [ ] Test all endpoints
- [ ] Set up logging
- [ ] Configure CORS for frontend domain
- [ ] Document API for team

---

**Last Updated:** November 27, 2025  
**Status:** ✅ Production Ready  
**Version:** 1.0.0

🚀 **Ready to deploy!**

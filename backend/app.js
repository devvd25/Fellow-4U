const express = require('express');
const cors = require('cors');
require('dotenv').config();
const { sequelize } = require('./models');

const authRoutes = require('./routes/authRoutes');
const apiRoutes = require('./routes/apiRoutes');

const app = express();

app.use(cors({
  origin(origin, callback) {
    if (!origin) return callback(null, true);
    if (origin.startsWith('http://localhost') || origin.startsWith('http://127.0.0.1')) {
      return callback(null, true);
    }
    const allowed = process.env.CORS_ORIGIN?.split(',').map((o) => o.trim()) || [];
    if (allowed.includes(origin)) {
      return callback(null, true);
    }
    return callback(new Error('Not allowed by CORS'));
  },
}));
app.use(express.json({ limit: '1mb' }));
app.use(express.urlencoded({ extended: true, limit: '1mb' }));

app.get('/', (req, res) => {
  res.json({ message: 'Welcome to Fellow4U Backend API' });
});

app.use('/auth', authRoutes);
app.use('/api', apiRoutes);

app.use((err, req, res, next) => {
  console.error(err.stack || err);
  const status = err.status || 500;
  const message = status >= 500 ? 'Something went wrong!' : err.message;
  res.status(status).json({ message });
});

const PORT = process.env.PORT || 3000;

if (!process.env.JWT_SECRET) {
  throw new Error('JWT_SECRET is required');
}

const startServer = async () => {
  try {
    await sequelize.sync({ alter: false });
    console.log('Database synced');
    
    const server = app.listen(PORT, () => {
      console.log(`Server is running on port ${PORT}`);
    });

    // Keep the process alive
    server.on('error', (err) => {
      console.error('Server error:', err);
    });

  } catch (err) {
    console.error('Failed to start server:', err);
    process.exit(1);
  }
};

if (require.main === module) {
  startServer();
}

module.exports = { app, startServer };

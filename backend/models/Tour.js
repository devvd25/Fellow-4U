const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Tour = sequelize.define('Tour', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true,
  },
  title: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  price: {
    type: DataTypes.DECIMAL(10, 2),
    allowNull: false,
  },
  imageUrl: {
    type: DataTypes.STRING,
  },
  description: {
    type: DataTypes.TEXT,
  },
  location: {
    type: DataTypes.STRING,
  },
  duration: {
    type: DataTypes.STRING, // e.g., "3 days"
  },
});

module.exports = Tour;

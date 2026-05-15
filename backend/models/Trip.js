const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Trip = sequelize.define('Trip', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true,
  },
  title: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  location: {
    type: DataTypes.STRING,
  },
  date: {
    type: DataTypes.STRING,
  },
  time: {
    type: DataTypes.STRING,
  },
  adults: {
    type: DataTypes.INTEGER,
    defaultValue: 1,
  },
  children: {
    type: DataTypes.INTEGER,
    defaultValue: 0,
  },
  status: {
    type: DataTypes.ENUM('planned', 'ongoing', 'completed'),
    defaultValue: 'planned',
  },
  imageUrl: {
    type: DataTypes.STRING,
  },
  userId: {
    type: DataTypes.UUID,
    allowNull: false,
  },
});

module.exports = Trip;

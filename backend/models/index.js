const sequelize = require('../config/database');
const User = require('./User');
const News = require('./News');
const Tour = require('./Tour');
const Trip = require('./Trip');
const Conversation = require('./Conversation');
const Message = require('./Message');

// Relationships
User.hasMany(Trip, { foreignKey: 'userId' });
Trip.belongsTo(User, { foreignKey: 'userId' });

// Chat Relationships
User.belongsToMany(Conversation, { through: 'UserConversations' });
Conversation.belongsToMany(User, { through: 'UserConversations' });

Conversation.hasMany(Message, { foreignKey: 'conversationId' });
Message.belongsTo(Conversation, { foreignKey: 'conversationId' });

User.hasMany(Message, { foreignKey: 'senderId' });
Message.belongsTo(User, { foreignKey: 'senderId' });

module.exports = {
  sequelize,
  User,
  News,
  Tour,
  Trip,
  Conversation,
  Message,
};

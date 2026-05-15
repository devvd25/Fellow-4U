const { Conversation, Message, User } = require('../models');

// API 10: Get Conversations
exports.getConversations = async (req, res) => {
  try {
    const user = await User.findByPk(req.user.id, {
      include: [{
        model: Conversation,
        include: [User, { model: Message, limit: 1, order: [['createdAt', 'DESC']] }]
      }]
    });
    res.json(user.Conversations);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// API 11: Create Conversation
exports.createConversation = async (req, res) => {
  try {
    const { participantId } = req.body;
    const conversation = await Conversation.create();
    await conversation.addUsers([req.user.id, participantId]);
    res.status(201).json(conversation);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// API 12: Get Messages
exports.getMessages = async (req, res) => {
  try {
    const { conversationId } = req.query;
    const messages = await Message.findAll({
      where: { conversationId },
      include: [User],
      order: [['createdAt', 'ASC']]
    });
    res.json(messages);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// API 13: Send Message
exports.sendMessage = async (req, res) => {
  try {
    const { conversationId, text } = req.body;
    const message = await Message.create({
      text,
      conversationId,
      senderId: req.user.id
    });
    res.status(201).json(message);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

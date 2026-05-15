const { User, News, Tour } = require('../models');

// API 4: Get Users
exports.getUsers = async (req, res) => {
  try {
    const users = await User.findAll({
      attributes: ['id', 'name', 'email', 'avatar', 'location'],
    });
    res.json(users);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// API 5: Get News
exports.getNews = async (req, res) => {
  try {
    const news = await News.findAll({ order: [['date', 'DESC']] });
    res.json(news);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// API 6: Get Tours
exports.getTours = async (req, res) => {
  try {
    const tours = await Tour.findAll();
    res.json(tours);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

const { User } = require('../models');
const jwt = require('jsonwebtoken');
require('dotenv').config();

const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

const sendServerError = (res) => {
  res.status(500).json({ message: 'Something went wrong!' });
};

const validateSignup = ({ name, email, password }) => {
  if (!name || typeof name !== 'string' || name.trim().length < 2) return 'Name is required';
  if (!email || typeof email !== 'string' || !emailPattern.test(email)) return 'Valid email is required';
  if (!password || typeof password !== 'string' || password.length < 6) return 'Password must be at least 6 characters';
  return null;
};

const validateLogin = ({ email, password }) => {
  if (!email || typeof email !== 'string' || !emailPattern.test(email)) return 'Valid email is required';
  if (!password || typeof password !== 'string') return 'Password is required';
  return null;
};

const generateToken = (id) => {
  if (!process.env.JWT_SECRET) {
    throw new Error('JWT_SECRET is required');
  }
  return jwt.sign({ id }, process.env.JWT_SECRET, { expiresIn: '30d' });
};

exports.signup = async (req, res) => {
  try {
    const validationError = validateSignup(req.body);
    if (validationError) {
      return res.status(400).json({ message: validationError });
    }

    const { name, email, password } = req.body;
    const normalizedEmail = email.trim().toLowerCase();
    const userExists = await User.findOne({ where: { email: normalizedEmail } });

    if (userExists) {
      return res.status(400).json({ message: 'User already exists' });
    }

    const user = await User.create({ name: name.trim(), email: normalizedEmail, password });
    res.status(201).json({
      id: user.id,
      name: user.name,
      email: user.email,
      token: generateToken(user.id),
    });
  } catch (error) {
    sendServerError(res);
  }
};

exports.login = async (req, res) => {
  try {
    const validationError = validateLogin(req.body);
    if (validationError) {
      return res.status(400).json({ message: validationError });
    }

    const { email, password } = req.body;
    const user = await User.findOne({ where: { email: email.trim().toLowerCase() } });

    if (user && (await user.comparePassword(password))) {
      return res.json({
        id: user.id,
        name: user.name,
        email: user.email,
        avatar: user.avatar,
        token: generateToken(user.id),
      });
    }

    res.status(401).json({ message: 'Invalid email or password' });
  } catch (error) {
    sendServerError(res);
  }
};

exports.updateProfile = async (req, res) => {
  try {
    const allowedFields = ['name', 'phone', 'location', 'avatar', 'password'];
    const invalidField = Object.keys(req.body).find((key) => !allowedFields.includes(key));
    if (invalidField) {
      return res.status(400).json({ message: `Invalid field: ${invalidField}` });
    }
    if (req.body.name !== undefined && (typeof req.body.name !== 'string' || req.body.name.trim().length < 2)) {
      return res.status(400).json({ message: 'Name must be at least 2 characters' });
    }
    if (req.body.password !== undefined && (typeof req.body.password !== 'string' || req.body.password.length < 6)) {
      return res.status(400).json({ message: 'Password must be at least 6 characters' });
    }

    const user = await User.findByPk(req.user.id);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    if (req.body.name !== undefined) user.name = req.body.name.trim();
    if (req.body.phone !== undefined) user.phone = req.body.phone;
    if (req.body.location !== undefined) user.location = req.body.location;
    if (req.body.avatar !== undefined) user.avatar = req.body.avatar;
    if (req.body.password !== undefined) user.password = req.body.password;

    await user.save();
    res.json({
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      location: user.location,
      avatar: user.avatar,
    });
  } catch (error) {
    sendServerError(res);
  }
};

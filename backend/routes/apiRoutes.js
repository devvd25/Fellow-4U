const express = require('express');
const router = express.Router();
const coreController = require('../controllers/coreController');
const tripController = require('../controllers/tripController');
const chatController = require('../controllers/chatController');
const uploadController = require('../controllers/uploadController');
const authMiddleware = require('../middleware/authMiddleware');
const upload = require('../middleware/uploadMiddleware');

// API 4, 5, 6 (Public)
router.get('/users', coreController.getUsers);
router.get('/news', coreController.getNews);
router.get('/tours', coreController.getTours);

// API 7, 8, 9 (Trips)
router.get('/trips', authMiddleware, tripController.getUserTrips);
router.post('/trips', authMiddleware, tripController.createTrip);
router.get('/trips/:id', tripController.getTripDetail);

// API 10, 11, 12, 13 (Chat)
router.get('/chat/conversations', authMiddleware, chatController.getConversations);
router.post('/chat/conversations', authMiddleware, chatController.createConversation);
router.get('/chat/messages', authMiddleware, chatController.getMessages);
router.post('/chat/messages', authMiddleware, chatController.sendMessage);

// API 14 (Upload)
router.post('/upload', upload.single('file'), uploadController.uploadFile);

module.exports = router;

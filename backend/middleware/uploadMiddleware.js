const cloudinary = require('cloudinary').v2;
const { CloudinaryStorage } = require('multer-storage-cloudinary');
const multer = require('multer');
require('dotenv').config();

cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET,
});

const storage = new CloudinaryStorage({
  cloudinary,
  params: {
    folder: process.env.CLOUDINARY_FOLDER || 'fellow4u',
    allowed_formats: ['jpg', 'png', 'jpeg'],
  },
});

const upload = multer({
  storage,
  limits: { fileSize: 5 * 1024 * 1024 },
  fileFilter(req, file, callback) {
    if (['image/jpeg', 'image/png'].includes(file.mimetype)) {
      return callback(null, true);
    }
    return callback(Object.assign(new Error('Only JPG and PNG files are allowed'), { status: 400 }));
  },
});

module.exports = upload;

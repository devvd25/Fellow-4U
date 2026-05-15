// API 14: Upload File
exports.uploadFile = (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ message: 'No file uploaded' });
    }
    res.json({
      message: 'File uploaded successfully',
      url: req.file.path, // Cloudinary URL
      filename: req.file.filename,
    });
  } catch (error) {
    res.status(500).json({ message: 'Upload failed' });
  }
};

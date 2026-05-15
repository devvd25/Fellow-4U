const { Trip } = require('../models');

// API 7: Get User Trips
exports.getUserTrips = async (req, res) => {
  try {
    console.log('Fetching trips for user:', req.user.id);
    const trips = await Trip.findAll({ where: { userId: req.user.id } });
    console.log('Found trips count:', trips.length);
    res.json(trips);
  } catch (error) {
    console.error('Error in getUserTrips:', error);
    res.status(500).json({ message: error.message });
  }
};

// API 8: Create Trip
exports.createTrip = async (req, res) => {
  try {
    const trip = await Trip.create({
      ...req.body,
      userId: req.user.id,
    });
    res.status(201).json(trip);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// API 9: Trip Detail
exports.getTripDetail = async (req, res) => {
  try {
    const trip = await Trip.findByPk(req.params.id);
    if (!trip) {
      return res.status(404).json({ message: 'Trip not found' });
    }
    res.json(trip);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

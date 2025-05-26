import express from 'express';
import { protect, authorize } from '../middlewares/auth';

const router = express.Router();

// Placeholder for master routes
router.get('/', protect, (req, res) => {
  res.status(200).json({
    success: true,
    message: 'Master routes not implemented yet',
  });
});

export default router;
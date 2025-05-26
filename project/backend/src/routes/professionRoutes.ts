import express from 'express';
import { body } from 'express-validator';
import {
  getProfessions,
  getProfession,
  createProfession,
  updateProfession,
  deleteProfession,
} from '../controllers/professionController';
import { protect, authorize } from '../middlewares/auth';
import { validate } from '../middlewares/validate';

const router = express.Router();

/**
 * @swagger
 * /api/professions:
 *   get:
 *     summary: Get all professions
 *     tags: [Professions]
 *     responses:
 *       200:
 *         description: List of professions
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 count:
 *                   type: integer
 *                 data:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/Profession'
 */
router.get('/', getProfessions);

/**
 * @swagger
 * /api/professions/{id}:
 *   get:
 *     summary: Get single profession
 *     tags: [Professions]
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: Profession ID
 *     responses:
 *       200:
 *         description: Profession data
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   $ref: '#/components/schemas/Profession'
 *       404:
 *         description: Profession not found
 */
router.get('/:id', getProfession);

/**
 * @swagger
 * /api/professions:
 *   post:
 *     summary: Create a new profession
 *     tags: [Professions]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - name
 *               - description
 *             properties:
 *               name:
 *                 type: string
 *               description:
 *                 type: string
 *               imageUrl:
 *                 type: string
 *     responses:
 *       201:
 *         description: Profession created
 *       400:
 *         description: Validation error
 *       401:
 *         description: Not authorized
 *       403:
 *         description: Forbidden, not admin
 */
router.post(
  '/',
  protect,
  authorize('ADMIN'),
  validate([
    body('name').notEmpty().withMessage('Name is required'),
    body('description').notEmpty().withMessage('Description is required'),
  ]),
  createProfession
);

/**
 * @swagger
 * /api/professions/{id}:
 *   put:
 *     summary: Update profession
 *     tags: [Professions]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: Profession ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *               description:
 *                 type: string
 *               imageUrl:
 *                 type: string
 *               isActive:
 *                 type: boolean
 *     responses:
 *       200:
 *         description: Profession updated
 *       400:
 *         description: Validation error
 *       401:
 *         description: Not authorized
 *       403:
 *         description: Forbidden, not admin
 *       404:
 *         description: Profession not found
 */
router.put(
  '/:id',
  protect,
  authorize('ADMIN'),
  validate([
    body('name').optional().notEmpty().withMessage('Name cannot be empty'),
    body('description').optional().notEmpty().withMessage('Description cannot be empty'),
  ]),
  updateProfession
);

/**
 * @swagger
 * /api/professions/{id}:
 *   delete:
 *     summary: Delete profession or mark as inactive
 *     tags: [Professions]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: Profession ID
 *     responses:
 *       200:
 *         description: Profession deleted or marked inactive
 *       401:
 *         description: Not authorized
 *       403:
 *         description: Forbidden, not admin
 *       404:
 *         description: Profession not found
 */
router.delete('/:id', protect, authorize('ADMIN'), deleteProfession);

export default router;
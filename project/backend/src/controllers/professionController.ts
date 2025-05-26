import { Request, Response, NextFunction } from 'express';
import { asyncHandler } from '../utils/asyncHandler';
import { ErrorResponse } from '../utils/errorResponse';
import prisma from '../config/prisma';

/**
 * Get all professions
 * @route GET /api/professions
 * @access Public
 */
export const getProfessions = asyncHandler(
  async (req: Request, res: Response, next: NextFunction) => {
    const professions = await prisma.profession.findMany({
      where: {
        isActive: true,
      },
      orderBy: {
        name: 'asc',
      },
    });

    res.status(200).json({
      success: true,
      count: professions.length,
      data: professions,
    });
  }
);

/**
 * Get single profession
 * @route GET /api/professions/:id
 * @access Public
 */
export const getProfession = asyncHandler(
  async (req: Request, res: Response, next: NextFunction) => {
    const profession = await prisma.profession.findUnique({
      where: {
        id: req.params.id,
      },
      include: {
        masters: {
          include: {
            user: {
              select: {
                id: true,
                firstName: true,
                lastName: true,
                email: true,
              },
            },
          },
        },
      },
    });

    if (!profession) {
      return next(new ErrorResponse(`Profession not found with id of ${req.params.id}`, 404));
    }

    res.status(200).json({
      success: true,
      data: profession,
    });
  }
);

/**
 * Create new profession
 * @route POST /api/professions
 * @access Private (Admin only)
 */
export const createProfession = asyncHandler(
  async (req: Request, res: Response, next: NextFunction) => {
    const { name, description, imageUrl } = req.body;

    const profession = await prisma.profession.create({
      data: {
        name,
        description,
        imageUrl,
      },
    });

    res.status(201).json({
      success: true,
      data: profession,
    });
  }
);

/**
 * Update profession
 * @route PUT /api/professions/:id
 * @access Private (Admin only)
 */
export const updateProfession = asyncHandler(
  async (req: Request, res: Response, next: NextFunction) => {
    const { name, description, imageUrl, isActive } = req.body;

    let profession = await prisma.profession.findUnique({
      where: {
        id: req.params.id,
      },
    });

    if (!profession) {
      return next(new ErrorResponse(`Profession not found with id of ${req.params.id}`, 404));
    }

    profession = await prisma.profession.update({
      where: {
        id: req.params.id,
      },
      data: {
        name,
        description,
        imageUrl,
        isActive,
      },
    });

    res.status(200).json({
      success: true,
      data: profession,
    });
  }
);

/**
 * Delete profession
 * @route DELETE /api/professions/:id
 * @access Private (Admin only)
 */
export const deleteProfession = asyncHandler(
  async (req: Request, res: Response, next: NextFunction) => {
    const profession = await prisma.profession.findUnique({
      where: {
        id: req.params.id,
      },
    });

    if (!profession) {
      return next(new ErrorResponse(`Profession not found with id of ${req.params.id}`, 404));
    }

    // Check if profession has masters
    const mastersCount = await prisma.master.count({
      where: {
        professionId: req.params.id,
      },
    });

    if (mastersCount > 0) {
      // Instead of deleting, mark as inactive
      await prisma.profession.update({
        where: {
          id: req.params.id,
        },
        data: {
          isActive: false,
        },
      });

      return res.status(200).json({
        success: true,
        message: 'Profession has masters. Marked as inactive instead of deleting.',
      });
    }

    // No masters, safe to delete
    await prisma.profession.delete({
      where: {
        id: req.params.id,
      },
    });

    res.status(200).json({
      success: true,
      data: {},
    });
  }
);
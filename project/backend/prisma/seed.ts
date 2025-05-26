import { PrismaClient, Role } from '@prisma/client';
import bcrypt from 'bcryptjs';

const prisma = new PrismaClient();

async function main() {
  // Clear existing data
  await prisma.review.deleteMany();
  await prisma.master.deleteMany();
  await prisma.admin.deleteMany();
  await prisma.user.deleteMany();
  await prisma.profession.deleteMany();

  console.log('Seeding database...');

  // Create admin user
  const adminPassword = await bcrypt.hash('admin123', 10);
  const admin = await prisma.user.create({
    data: {
      email: 'admin@example.com',
      password: adminPassword,
      firstName: 'Admin',
      lastName: 'User',
      role: Role.ADMIN,
      adminProfile: {
        create: {
          department: 'Management',
        },
      },
    },
  });

  console.log('Admin created:', admin.email);

  // Create professions
  const professions = await Promise.all([
    prisma.profession.create({
      data: {
        name: 'Plumber',
        description: 'Installation and repair of water systems in homes and businesses',
        imageUrl: 'https://example.com/images/plumber.jpg',
      },
    }),
    prisma.profession.create({
      data: {
        name: 'Electrician',
        description: 'Installation and repair of electrical systems',
        imageUrl: 'https://example.com/images/electrician.jpg',
      },
    }),
    prisma.profession.create({
      data: {
        name: 'Carpenter',
        description: 'Woodworking, furniture making, and structural repairs',
        imageUrl: 'https://example.com/images/carpenter.jpg',
      },
    }),
  ]);

  console.log('Professions created:', professions.length);

  // Create master users
  const masterPassword = await bcrypt.hash('master123', 10);
  const masters = await Promise.all(
    professions.map(async (profession, index) => {
      const user = await prisma.user.create({
        data: {
          email: `master${index + 1}@example.com`,
          password: masterPassword,
          firstName: `Master${index + 1}`,
          lastName: 'Provider',
          role: Role.MASTER,
          masterProfile: {
            create: {
              bio: `Experienced ${profession.name} with over 5 years of experience`,
              yearsOfExperience: 5,
              professionId: profession.id,
              isVerified: true,
            },
          },
        },
      });
      return user;
    })
  );

  console.log('Masters created:', masters.length);

  // Create regular users
  const userPassword = await bcrypt.hash('user123', 10);
  const users = await Promise.all(
    Array.from({ length: 5 }).map(async (_, index) => {
      return prisma.user.create({
        data: {
          email: `user${index + 1}@example.com`,
          password: userPassword,
          firstName: `User${index + 1}`,
          lastName: 'Client',
          role: Role.USER,
        },
      });
    })
  );

  console.log('Users created:', users.length);

  // Create reviews
  for (let i = 0; i < users.length; i++) {
    for (let j = 0; j < masters.length; j++) {
      if (i % 2 === 0 || j % 2 === 0) {
        await prisma.review.create({
          data: {
            rating: Math.floor(Math.random() * 3) + 3, // 3-5 stars
            comment: `Great service from ${masters[j].firstName}. Would recommend!`,
            reviewerId: users[i].id,
            masterId: masters[j].id,
          },
        });
      }
    }
  }

  console.log('Database seeded successfully');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
const { User, News, Tour, Trip, Conversation, Message, sequelize } = require('./models');
const bcrypt = require('bcryptjs');

const seedData = async () => {
  try {
    await sequelize.sync({ force: true }); // Reset DB
    console.log('Database synced');

    // 1. Create Default User với tên Đặng Công Vũ
    const userReal = await User.create({
      name: 'Đặng Công Vũ',
      email: 'belavu9999@gmail.com',
      password: '20052005',
      location: 'Ho Chi Minh, Vietnam',
    });
    console.log('User Đặng Công Vũ created');

    // 2. Create Sample News
    await News.bulkCreate([
      {
        title: 'New Destination in Danang City',
        content: 'Discover the hidden gems of Danang...',
        imageUrl: 'https://picsum.photos/seed/news-danang/800/400',
        date: new Date('2026-02-05'),
      },
      {
        title: '$1 Flight Ticket',
        content: 'Huge promotion for summer travel...',
        imageUrl: 'https://picsum.photos/seed/news-flight/800/400',
        date: new Date('2026-02-05'),
      },
    ]);

    // 3. Create Sample Tours
    await Tour.bulkCreate([
      {
        title: 'Da Nang - Ba Na - Hoi An',
        price: 400.00,
        imageUrl: 'https://picsum.photos/seed/tour-danang/800/400',
        description: 'Explore the best of Central Vietnam...',
        location: 'Da Nang',
        duration: '3 days',
      },
      {
        title: 'Melbourne - Sydney',
        price: 600.00,
        imageUrl: 'https://picsum.photos/seed/tour-australia/800/400',
        description: 'A grand tour across Australia...',
        location: 'Australia',
        duration: '5 days',
      },
    ]);

    // 4. Create Sample Trips for User Real
    await Trip.bulkCreate([
      {
        title: 'Chuyến du lịch Hội An',
        location: 'Hội An, Quảng Nam',
        date: '2026-06-15',
        time: '08:00 - 22:00',
        adults: 2,
        children: 1,
        status: 'planned',
        imageUrl: 'https://picsum.photos/seed/hoian/800/400',
        userId: userReal.id
      },
      {
        title: 'Khám phá Bà Nà Hills',
        location: 'Bà Nà, Đà Nẵng',
        date: '2026-05-20',
        time: '07:00 - 18:00',
        adults: 4,
        children: 0,
        status: 'planned',
        imageUrl: 'https://picsum.photos/seed/banahills/800/400',
        userId: userReal.id
      },
      {
        title: 'Nghỉ dưỡng Phú Quốc',
        location: 'Phú Quốc, Kiên Giang',
        date: '2026-08-10',
        time: '10:00 - 17:00',
        adults: 2,
        children: 2,
        status: 'planned',
        imageUrl: 'https://picsum.photos/seed/phuquoc/800/400',
        userId: userReal.id
      }
    ]);
    // 5. Create Sample Chat
    const guide = await User.create({
      name: 'Fellow4U Guide',
      email: 'guide@fellow4u.com',
      password: 'password123',
      avatar: 'https://picsum.photos/seed/guide/150',
    });

    const conversation = await Conversation.create();
    await conversation.addUsers([userReal, guide]);

    await Message.bulkCreate([
      {
        text: 'Chào bạn, tôi có thể giúp gì cho chuyến đi của bạn?',
        senderId: guide.id,
        conversationId: conversation.id,
      },
      {
        text: 'Tôi muốn hỏi về tour Hội An ngày mai.',
        senderId: userReal.id,
        conversationId: conversation.id,
      },
      {
        text: 'Vâng, tour ngày mai sẽ bắt đầu lúc 8:00 sáng bạn nhé.',
        senderId: guide.id,
        conversationId: conversation.id,
      }
    ]);
    console.log('Sample chat created');

    console.log('Seed data created successfully!');
    process.exit();
  } catch (error) {
    console.error('Error seeding data:', error);
    process.exit(1);
  }
};

seedData();

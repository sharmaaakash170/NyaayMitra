const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const Name = require('./models/Name');

const app = express();
app.use(cors());
app.use(express.json());

const mongoURL = process.env.MONGO_URL || 'mongodb://mongo:27017/namesdb';

mongoose.connect(mongoURL, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

app.post('/api/names', async (req, res) => {
  const { name } = req.body;
  const newName = new Name({ name });
  await newName.save();
  res.json({ message: 'Name saved' });
});

app.get('/api/names', async (req, res) => {
  const names = await Name.find();
  res.json(names);
});

app.listen(3000, () => console.log('Backend running on port 3000'));

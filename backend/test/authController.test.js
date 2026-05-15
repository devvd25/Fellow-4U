process.env.JWT_SECRET = process.env.JWT_SECRET || 'test-secret';

const test = require('node:test');
const assert = require('node:assert/strict');
const authController = require('../controllers/authController');

const createResponse = () => {
  const response = {
    statusCode: 200,
    body: null,
    status(code) {
      this.statusCode = code;
      return this;
    },
    json(payload) {
      this.body = payload;
      return this;
    },
  };
  return response;
};

test('signup rejects invalid email', async () => {
  const response = createResponse();
  await authController.signup({ body: { name: 'Test User', email: 'bad-email', password: '123456' } }, response);

  assert.equal(response.statusCode, 400);
  assert.equal(response.body.message, 'Valid email is required');
});

test('signup rejects short password', async () => {
  const response = createResponse();
  await authController.signup({ body: { name: 'Test User', email: 'test@example.com', password: '123' } }, response);

  assert.equal(response.statusCode, 400);
  assert.equal(response.body.message, 'Password must be at least 6 characters');
});

test('login rejects missing password', async () => {
  const response = createResponse();
  await authController.login({ body: { email: 'test@example.com' } }, response);

  assert.equal(response.statusCode, 400);
  assert.equal(response.body.message, 'Password is required');
});

test('updateProfile rejects unknown fields', async () => {
  const response = createResponse();
  await authController.updateProfile({ user: { id: 'user-id' }, body: { role: 'admin' } }, response);

  assert.equal(response.statusCode, 400);
  assert.equal(response.body.message, 'Invalid field: role');
});

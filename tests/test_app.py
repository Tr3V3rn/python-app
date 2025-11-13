import unittest
import json
import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from src.app import app


class TestApp(unittest.TestCase):
    
    def setUp(self):
        self.client = app.test_client()
    
    def test_info_endpoint(self):
        response = self.client.get('/api/v1/info')
        self.assertEqual(response.status_code, 200)
        data = json.loads(response.data)
        self.assertIn('time', data)
        self.assertIn('hostname', data)
        # self.assertEqual(data['message'], 'Hello jamF')
        self.assertEqual(data['deployed_on'], 'kubernetes')
    
    def test_health_endpoint(self):
        response = self.client.get('/api/v1/healthz')
        self.assertEqual(response.status_code, 200)
        data = json.loads(response.data)
        self.assertEqual(data['status'], 'up')


if __name__ == '__main__':
    unittest.main()
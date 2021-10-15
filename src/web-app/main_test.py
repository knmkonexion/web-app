"""Test module"""
import pytest
import app

@pytest.fixture
def client():
    """Conects the pytest client"""
    app.app.testing = True
    return app.app.test_client()

def test_handler_no_env_variable(client):
    """Tests the /test route on the main application"""
    results = client.get('/test')

    assert results.data.decode() == 'success'
    assert results.status_code == 200

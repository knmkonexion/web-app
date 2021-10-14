import os
import pytest
import app

@pytest.fixture
def client():
    app.app.testing = True
    return app.app.test_client()

def test_handler_no_env_variable(client):
    r = client.get('/health-check')

    assert r.data.decode() == 'success'
    assert r.status_code == 200

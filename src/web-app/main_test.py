import os
import pytest
import main

@pytest.fixture
def client():
    main.app.testing = True
    return main.app.test_client()

def test_handler_no_env_variable(client):
    r = client.get('/health-check')

    assert r.data.decode() == 'success'
    assert r.status_code == 200

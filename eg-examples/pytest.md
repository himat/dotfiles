
# General main useful commands
Run all tests in current dir and below
    pytest

Run only the failed tests from the last run
    pytest --lf 

This command is used to run tests from a specific folder.
    pytest test_module/

This command is used to run tests from a specific file.
    pytest test_module.py

Tests that include a specific keyword in their names:
    pytest -k "keyword"

Stop tests after the first failure
    pytest -x

Show verbose output
    pytest -v


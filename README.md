# antlr-tsql

[![Build Status](https://travis-ci.org/datacamp/antlr-tsql.svg?branch=master)](https://travis-ci.org/datacamp/antlr-tsql)
[![PyPI version](https://badge.fury.io/py/antlr-tsql.svg)](https://badge.fury.io/py/antlr-tsql)

## Development

ANTLR requires Java, so we suggest you use Docker when building grammars. The `Makefile` contains directives to clean, build, test and deploy the ANTLR grammar. It does not run Docker itself, so run `make` inside Docker.

```bash
# Build the docker container
docker build -t antlr_tsql .

# Run the container to build the python and js grammars
# Write parser files to local file system through volume mounting
docker run -it -v ${PWD}:/usr/src/app antlr_tsql make build
```

Now that the Python parsing files are available, you can install them with `pip`:

```bash
pip install -r requirements.txt
pip install -e .
```

And parse SQL code in Python:

```python
from antlr_tsql import ast
ast.parse("SELECT a from b")
```

If you're actively developing on the ANLTR grammar or the tree shaping, it's a good idea to set up the [AST viewer](https://github.com/datacamp/ast-viewer) locally so you can immediately see the impact of your changes in a visual way. Currently, the AST viewer still uses the JS grammar for the actual parsing and Python for the tree shaping ([open issue](https://github.com/datacamp/ast-viewer/issues/13)), so there's some work needed:

- Clone the ast-viewer repo and build the Docker image according to the instructions.
- Spin up a docker container that volume mounts the grammar JS and the Python package, rebuilds the JS and symlink-installs the package, and runs the server on port 3000:

  ```bash
  docker run -it \
    -u root \
    -v ~/workspace/antlr-tsql/antlr_tsql:/app/app/static/grammar/antlr_tsql \
    -v ~/workspace/antlr-tsql:/app/app/antlr-tsql \
    -p 3000:3000 \
    ast-viewer \
    /bin/bash -c "make build_js && pip install -e app/antlr-tsql && python3 run.py"
  ```

- If you update the tree shaping logic in this repo, the app will auto-update.
- If you change the grammar, you will have to first rebuild the grammar (with the `antlr_tsql` docker image) and restart the `ast-viewer` container.

### Run tests

```
docker build -t antlr_tsql .
docker run -t antlr_tsql make build test
```

## Travis deployment

- Builds the Docker image.
- Runs the Docker image to build the grammar and run the unit tests.
- Deploys the resulting python and js files to PyPi when a new release is made, so they can be installed easily.

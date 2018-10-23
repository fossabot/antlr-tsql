JS_DIR=antlr_tsql/js
PY_DIR=antlr_plsql/antlr_py

.PHONY: clean

all: clean test

buildpy:
	antlr4 -Dlanguage=Python3 -o $(PY_DIR) -visitor antlr_tsql/tsql.g4

buildjs:
	antlr4 -Dlanguage=JavaScript -o $(JS_DIR) antlr_tsql/tsql.g4 && mv $(JS_DIR)/antlr_tsql/* $(JS_DIR)

build: buildpy

clean:
	find . \( -name \*.pyc -o -name \*.pyo -o -name __pycache__ \) -prune -exec rm -rf {} +
	rm -rf antlr_tsql.egg-info

test: clean
	pytest

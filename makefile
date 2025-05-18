# --------------------------------------------------------------------------- #
.RECIPEPREFIX = +
.ONESHELL:
SHELL := Rscript
.SHELLFLAGS := -e
MAKEFLAGS = --warn-undefined-variables
MAKEFLAGS = --no-builtin-rules
# --------------------------------------------------------------------------- #

all: docs/index.html docs/.nojekyll

docs:
+ dir.create("$@")

docs/index.html: restocking_ingredients.html | docs
+ file.copy("$<", "$@") |> invisible()

restocking_ingredients.html: restocking_ingredients.rmd
+ litedown::fuse("$<")

docs/.nojekyll: | docs
+ file.create("$@") |> invisible()

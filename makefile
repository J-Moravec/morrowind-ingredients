# --------------------------------------------------------------------------- #
.RECIPEPREFIX = +
.ONESHELL:
SHELL := Rscript
.SHELLFLAGS := -e
MAKEFLAGS = --warn-undefined-variables
MAKEFLAGS = --no-builtin-rules
# --------------------------------------------------------------------------- #

all: doc/index.html

doc:
+ dir.create("$@")

doc/index.html: restocking_ingredients.html | doc
+ file.copy("$<", "$@") |> invisible()

restocking_ingredients.html: restocking_ingredients.rmd
+ litedown::fuse("$<")

SHELL := /usr/bin/env bash

CONFIG_HOME ?= $(HOME)/.config/hypr
SCRIPTS_DEST ?= $(CONFIG_HOME)/scripts
CONFIG_DEST ?= $(CONFIG_HOME)/ravenslide.conf
HYPRLAND_MAIN ?= $(CONFIG_HOME)/hyprland.conf

RAVENSLIDE_SRC := scripts/ravenslide
RAVEN_APPLY_SRC := scripts/ravenslide-apply-carousel
RAVEN_CAROUSEL_SRC := scripts/raven-carousel
RAVEN_CONF_SRC := hypr/ravenslide.conf

RAVENSLIDE := $(SCRIPTS_DEST)/ravenslide
RAVEN_APPLY := $(SCRIPTS_DEST)/ravenslide-apply-carousel
RAVEN_CAROUSEL := $(SCRIPTS_DEST)/raven-carousel

.DEFAULT_GOAL := help

.PHONY: help install update install-scripts install-config ensure-source \
	validate test apply-carousel panel carousel panel-next panel-prev \
	carousel-start carousel-next carousel-prev carousel-open carousel-cancel \
	status runtime-binds reload-config

help:
	@echo "RavenSlide Make targets"
	@echo
	@echo "Install / update:"
	@echo "  make install            Copy scripts + config into ~/.config/hypr"
	@echo "  make update             Same as install"
	@echo "  make ensure-source      Ensure hyprland.conf sources ravenslide.conf"
	@echo
	@echo "Validation:"
	@echo "  make validate           Syntax-check scripts and print help output"
	@echo "  make test               Alias of validate"
	@echo
	@echo "Run:"
	@echo "  make apply-carousel     Apply runtime animation preset"
	@echo "  make panel CMD='next'   Run ravenslide command"
	@echo "  make carousel CMD='start' Run raven-carousel command"
	@echo "  make panel-next | panel-prev"
	@echo "  make carousel-start | carousel-next | carousel-prev | carousel-open | carousel-cancel"
	@echo "  make status             Show status for both tools"
	@echo
	@echo "Hyprland runtime helpers:"
	@echo "  make runtime-binds      Add temporary runtime keybinds via hyprctl keyword"
	@echo "  make reload-config      Run configerrors + reload config-only + configerrors"
	@echo
	@echo "Config vars (override like: make install CONFIG_HOME=...):"
	@echo "  CONFIG_HOME=$(CONFIG_HOME)"
	@echo "  SCRIPTS_DEST=$(SCRIPTS_DEST)"
	@echo "  CONFIG_DEST=$(CONFIG_DEST)"
	@echo "  HYPRLAND_MAIN=$(HYPRLAND_MAIN)"

install: install-scripts install-config

update: install

install-scripts:
	@mkdir -p "$(SCRIPTS_DEST)"
	@cp "$(RAVENSLIDE_SRC)" "$(RAVENSLIDE)"
	@cp "$(RAVEN_APPLY_SRC)" "$(RAVEN_APPLY)"
	@cp "$(RAVEN_CAROUSEL_SRC)" "$(RAVEN_CAROUSEL)"
	@chmod +x "$(RAVENSLIDE)" "$(RAVEN_APPLY)" "$(RAVEN_CAROUSEL)"
	@echo "Installed scripts into $(SCRIPTS_DEST)"

install-config:
	@mkdir -p "$(CONFIG_HOME)"
	@cp "$(RAVEN_CONF_SRC)" "$(CONFIG_DEST)"
	@echo "Installed config into $(CONFIG_DEST)"

ensure-source:
	@mkdir -p "$(CONFIG_HOME)"
	@touch "$(HYPRLAND_MAIN)"
	@if ! grep -qxF "source = $(CONFIG_DEST)" "$(HYPRLAND_MAIN)"; then \
		echo "source = $(CONFIG_DEST)" >> "$(HYPRLAND_MAIN)"; \
		echo "Added source line to $(HYPRLAND_MAIN)"; \
	else \
		echo "Source line already present in $(HYPRLAND_MAIN)"; \
	fi

validate:
	@bash -n "$(RAVENSLIDE_SRC)"
	@bash -n "$(RAVEN_APPLY_SRC)"
	@bash -n "$(RAVEN_CAROUSEL_SRC)"
	@"$(RAVENSLIDE_SRC)" help >/dev/null
	@"$(RAVEN_CAROUSEL_SRC)" help >/dev/null
	@echo "Validation passed."

test: validate

apply-carousel:
	@"$(RAVEN_APPLY)"

panel:
	@cmd='$(CMD)'; \
	if [[ -z "$$cmd" ]]; then cmd='help'; fi; \
	"$(RAVENSLIDE)" $$cmd

carousel:
	@cmd='$(CMD)'; \
	if [[ -z "$$cmd" ]]; then cmd='help'; fi; \
	"$(RAVEN_CAROUSEL)" $$cmd

panel-next:
	@"$(RAVENSLIDE)" next

panel-prev:
	@"$(RAVENSLIDE)" prev

carousel-start:
	@"$(RAVEN_CAROUSEL)" start

carousel-next:
	@"$(RAVEN_CAROUSEL)" next

carousel-prev:
	@"$(RAVEN_CAROUSEL)" prev

carousel-open:
	@"$(RAVEN_CAROUSEL)" open

carousel-cancel:
	@"$(RAVEN_CAROUSEL)" cancel

status:
	@echo "ravenslide list:"
	@"$(RAVENSLIDE)" list || true
	@echo
	@echo "raven-carousel status:"
	@"$(RAVEN_CAROUSEL)" status || true

runtime-binds:
	@hyprctl keyword bind "SUPER, bracketright, exec, $(RAVENSLIDE) next"
	@hyprctl keyword bind "SUPER, bracketleft, exec, $(RAVENSLIDE) prev"
	@hyprctl keyword bind "SUPER CTRL, TAB, exec, $(RAVEN_CAROUSEL) start"
	@hyprctl keyword bind "SUPER CTRL, right, exec, $(RAVEN_CAROUSEL) next"
	@hyprctl keyword bind "SUPER CTRL, left, exec, $(RAVEN_CAROUSEL) prev"
	@hyprctl keyword bind "SUPER CTRL, return, exec, $(RAVEN_CAROUSEL) open"
	@hyprctl keyword bind "SUPER CTRL, escape, exec, $(RAVEN_CAROUSEL) cancel"
	@echo "Applied runtime binds."

reload-config:
	@hyprctl configerrors
	@hyprctl reload config-only
	@hyprctl configerrors

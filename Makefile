PROJECT = emqx_influx_exporter
PROJECT_DESCRIPTION = "Emqx InfluxDB Exporter"
PROJECT_VERSION = 0.0.1

PATH := $(CURDIR)/elixir/bin:$(PATH)

all: elixir/lib/elixir/ebin/elixir.app
	mix local.hex --force
	mix deps.get
	mix compile --force
	-rm -rf $(CURDIR)/elixir/lib/mix/test

elixir/lib/elixir/ebin/elixir.app:
	git clone -b v1.7 --depth 1 https://github.com/elixir-lang/elixir.git
	echo "start to build elixir ..."
	make -C elixir -f Makefile

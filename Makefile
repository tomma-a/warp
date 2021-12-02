# Figure out which compiler to use (prefer gdc, fall back to dmd).
ifeq (,$(DC))
	DC:=$(shell which gdc 2>/dev/null)
ifeq (,$(DC))
	DC:=dmd
endif
endif

ifeq (gdc,$(notdir $(DC)))
	DFLAGS=-c -O4 -frelease -fno-bounds-check -fbuiltin
	OFSYNTAX=-o
else
ifeq (dmd,$(notdir $(DC)))
	DFLAGS= -O -inline -release
	OFSYNTAX=-of
else
    $(error Unsupported compiler: $(DC))
endif
endif

CC=cc
CXX=c++
CFLAGS=
CXXFLAGS=
WARPDRIVE=warpdrive
GENERATED_DEFINES=defines_gcc4_8_5.d defines_gxx4_8_5.d

# warp sources
SRCS=cmdline.d constexpr.d context.d directive.d expanded.d file.d \
id.d lexer.d loc.d macros.d main.d number.d outdeps.d ranges.d skip.d \
sources.d stringlit.d textbuf.d charclass.d util.d

# Binaries generated
BIN:=warp $(WARPDRIVE)

# Rules

all : $(BIN)

clean :
	rm -rf $(BIN) $(addsuffix .o, $(BIN)) $(GENERATED_DEFINES)

warp : $(SRCS)
	$(DC) $(DFLAGS) $(OFSYNTAX)$@ $(SRCS)

$(WARPDRIVE) : warpdrive.d $(GENERATED_DEFINES)
	$(DC) -version=gcc4_8_5 $(DFLAGS) $(OFSYNTAX)$@ $^


#########################################################################
##                    The ATS Programming Language                     ##
##          Unleashing the Potentials of Types and Templates!          ##
##                      http://www.ats-lang.org/                       ##
#########################################################################
## GNUMakefile for ATS2-Postiats

# Usage Information #####################################################

# Place this Makefile at the root directory of your ATS project.
# After running commands 'make', 'make all' or 'make run', a new
# directory 'build' will be automatically created.
# 
# Example (project: helloworld):
#
# \build
#    \bin (resulting executable)
#       helloworld
#    \obj (intermediate .o files)
#       main_dats.o
#    \src (intermediate .c files)
#       main_dats.c
# \src
#	   \dats (project .dats files)
#       main.dats
#    \sats (proejct .sats files)
# Makefile (this file)

# Project Configuration #################################################

# Project Name
PROJECT=helloworld

# Directory containing project .sats files
SATSDIR=src/sats
# Directory containing project .dats files
DATSDIR=src/dats

# Linking
INCLUDE:=
LIBRARY:=

# C compiler flags
CFLAGS=-g
# CFLAGS=-g
# CFLAGS=-g -O
# CFLAGS=-g -O2

# Memory allocator mode (none, libc, Bohem-gc)
# GCFLAG=
# GCFLAG=-DATS_MEMALLOC_LIBC
GCFLAG=-DATS_MEMALLOC_GCBDW

# Garbarge collection mode (only applies if memory allocation is Bohem-gc)
# LIBGC=
LIBGC=-lgc

# Command-line Tools ####################################################

# C compiler
CC=gcc

# ATS compiler
PATSCC=patscc
PATSOPT=patsopt

# Cleanup
RMRF=rm -rf

# Main Recipes (editing is not recommended) #############################

# Build the project
all: build/bin/$(PROJECT)
# Build the project then run the resulting executable
run: build/bin/$(PROJECT) ; ./build/bin/$(PROJECT)
# Cleanup the project
clean:: ; $(RMRF) build

# More Recipes (editing is not recommended) #############################

SRCSATS := $(shell find $(SATSDIR) -name '*.sats')
SRCDATS := $(shell find $(DATSDIR) -name '*.dats')

OBJSATS := \
$(patsubst $(SATSDIR)/%.sats, build/obj/%_sats.o, $(SRCSATS))
OBJDATS := \
$(patsubst $(DATSDIR)/%.dats, build/obj/%_dats.o, $(SRCDATS))

BUILD=build build/bin build/obj build/src
$(shell mkdir -p $(BUILD))

build/bin/$(PROJECT) : \
$(OBJSATS) $(OBJDATS) ; \
$(PATSCC) -o $@ \
$(INCLUDE) $(GCFLAG) $^ $(LIBGC) $(LIBRARY)

build/src/%_sats.c: \
$(SATSDIR)/%.sats ; $(PATSOPT) -o $@ --static $<
build/src/%_dats.c: \
$(DATSDIR)/%.dats ; $(PATSOPT) -o $@ --dynamic $<

build/obj/%_sats.o: \
build/src/%_sats.c; \
$(PATSCC) $(INCLUDE) $(CFLAGS) -o $@ -c $<
build/obj/%_dats.o: \
build/src/%_dats.c; \
$(PATSCC) $(INCLUDE) $(CFLAGS) $(GCFLAG) -o $@ -c $<

.SECONDARY:
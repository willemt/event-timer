CONTRIB_DIR = ..
HEAP_DIR = $(CONTRIB_DIR)/CHeap

GCOV_OUTPUT = *.gcda *.gcno *.gcov 
GCOV_CCFLAGS = -fprofile-arcs -ftest-coverage
SHELL  = /bin/bash
CC     = gcc
CCFLAGS = -g -O2 -Wall -Werror -W -fno-omit-frame-pointer -fno-common -fsigned-char $(GCOV_CCFLAGS) -I$(HEAP_DIR)

all: tests

cheap:
	mkdir -p $(HEAP_DIR)/.git
	git --git-dir=$(HEAP_DIR)/.git init 
	pushd $(HEAP_DIR); git pull git@github.com:willemt/CHeap.git; popd

download-contrib: cheap

main.c:
	if test -d $(HEAP_DIR); \
	then echo have contribs; \
	else make download-contrib; \
	fi
	sh make-tests.sh > main.c

tests: main.c event_timer.o test_event_timer.c CuTest.c main.c $(HEAP_DIR)/heap.c 
	$(CC) $(CCFLAGS) -o $@ $^
	./tests
	gcov main.c test_event_timer.c event_timer.c

event_timer.o: event_timer.c 
	$(CC) $(CCFLAGS) -c -o $@ $^

clean:
	rm -f main.c event_timer.o tests $(GCOV_OUTPUT)

CONTRIB_DIR = deps

GCOV_OUTPUT = *.gcda *.gcno *.gcov 
GCOV_CCFLAGS = -fprofile-arcs -ftest-coverage
SHELL  = /bin/bash
CC     = gcc
CCFLAGS = -I. -Itests -Ideps/heap -g -O2 -Wall -Werror -W -fno-omit-frame-pointer -fno-common -fsigned-char $(GCOV_CCFLAGS)
all: test

main.c:
	sh tests/make-tests.sh tests/test_*.c > main.c

test: main.c event_timer.o tests/test_event_timer.c tests/CuTest.c main.c deps/heap/heap.c 
	$(CC) $(CCFLAGS)  -o $@ $^
	./test
	gcov main.c event_timer.c

event_timer.o: event_timer.c 
	$(CC) $(CCFLAGS) -c -o $@ $^

clean:
	rm -f main.c event_timer.o test $(GCOV_OUTPUT)

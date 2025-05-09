CFLAGS:=-std=c11 -g -static -fno-common $(CFLAGS)
SRCS=$(wildcard src/*.c)
OBJS=$(SRCS:.c=.o)
BIN=chibicc-uxn

$(BIN): $(OBJS)
	$(CC) -o $@ $(OBJS) $(LDFLAGS)

$(OBJS): src/chibi.h

# TODO: support uxn chibicc compiling itself?
#chibicc-gen2: chibicc $(SRCS) chibi.h
#	./self.sh

# TODO: support extern tests, maybe via an uxntal file
#extern.o: tests-extern
#	gcc -xc -c -o extern.o tests-extern

test: $(BIN) #extern.o
	cc -I. -P -E -x c tests -o tmp-tests.c
	./$(BIN) -O0 tmp-tests.c > tmp-tests-O0.tal
	uxnasm tmp-tests-O0.tal tmp-tests-O0.rom
	uxncli tmp-tests-O0.rom
	./$(BIN) -O1 tmp-tests.c > tmp-tests-O1.tal
	uxnasm tmp-tests-O1.tal tmp-tests-O1.rom
	uxncli tmp-tests-O1.rom

#test-gen2: chibicc-gen2 extern.o
#	./chibicc-gen2 tests > tmp.s
#	gcc -static -o tmp tmp.s extern.o
#	./tmp

clean:
	rm -rf $(BIN) chibicc-gen* *.o src/*.o *~ tmp*

.PHONY: test clean

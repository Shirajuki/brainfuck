## Brainfuck interpreter and encoder using Lex (Flex)

### Usage
1. Clone the repository `https://github.com/Shirajuki/brainfuck-interpreter.git`

2. Compile the lex program
```sh
make
```

3. Run the ELF binary `bfenc` to encode ascii string to brainfuck code
```
./bfenc < test_file1 > output
```

4. Run the ELF binary `bfint` to interpret brainfuck code
```
./bfint < test_file2
```


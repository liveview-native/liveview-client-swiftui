# sort_json
A small utility for rapidly re-formatting every JSON file in a directory with sorted keys. Used to ensure the output of docc is stable, which it ordinarily is not. A small Rust program is used because a shell script is vastly slower (1-2min compared to <2sec) and is dominated by the cost of launching a process for every single file.
